import "dart:core";

import "package:amazon_cognito_identity_dart_2/cognito.dart";
import "package:flutter/widgets.dart";
import "package:jwt_decode/jwt_decode.dart";
import "package:amity/constants/app_constants.dart";
import "package:amity/providers/security_provider.dart";
import "package:amity/schemas/configuration_schema.dart";
import "package:amity/services/authentication_service.dart";
import "package:amity/utils/common_utils.dart";
import "package:provider/provider.dart";
import "package:uuid/uuid.dart";

class AuthenticationController {
  Future<bool> signUp(String email, String password) async {
    var uuid = Uuid();
    try {
      final AuthenticationService authenticationService =
          AuthenticationService();
      String username = uuid.v4();
      bool signUpSuccess = await authenticationService.signUp(
          username, password, [AttributeArg(name: 'email', value: email)]);

      List<ConfigurationSchema> configurationList = [];

      configurationList.add(
          ConfigurationSchema(key: Constants.DEVICE_USERNAME, value: username));

      configurationList.add(
          ConfigurationSchema(key: Constants.DEVICE_PASSWORD, value: password));

      await authenticationService
          .saveConfigurationFile(configurationList.toString());

      return signUpSuccess;
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, ConfigurationSchema>>
      getuserCredentialsFromStorage() async {
    AuthenticationService authenticationService = AuthenticationService();

    String configurationData =
        await authenticationService.readConfigurationFile();

    if (configurationData == null || configurationData.isEmpty) {
      throw Exception("User Details Not Found");
    }

    Map<String, ConfigurationSchema> userCredentialsMap = {};

    List<ConfigurationSchema> configurationlist =
        CommonUtils.convertJSONToListSchema<ConfigurationSchema>(
            configurationData, ConfigurationSchema());

    for (var credentials in configurationlist) {
      userCredentialsMap[credentials.key as String] = credentials;
    }
    return userCredentialsMap;
  }

  Future<bool> signIn(BuildContext context, String? pin) async {
    AuthenticationService authenticationService = AuthenticationService();
    Map<String, ConfigurationSchema> userCredentialsMap =
        await getuserCredentialsFromStorage();

    String username =
        userCredentialsMap[Constants.DEVICE_USERNAME]?.value as String;
    String password =
        pin ?? userCredentialsMap[Constants.DEVICE_PASSWORD]?.value as String;

    try {
      CognitoUserSession? session =
          await authenticationService.signIn(username, password);

      Provider.of<SecurityProvider>(context, listen: false)
          .setAccessToken(session?.accessToken.jwtToken as String);

      Provider.of<SecurityProvider>(context, listen: false)
          .setIdToken(session?.idToken.jwtToken as String);

      Provider.of<SecurityProvider>(context, listen: false)
          .setRefreshToken(session?.refreshToken?.token as String);

      Provider.of<SecurityProvider>(context, listen: false)
          .setClockDrift(session?.clockDrift?.toString() as String);

      return true;
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> signoutUser(BuildContext context) async {
    String accessToken = Provider.of<SecurityProvider>(context, listen: false)
        .getAccessToken() as String;

    String idToken = Provider.of<SecurityProvider>(context, listen: false)
        .getIdToken() as String;

    String refreshToken = Provider.of<SecurityProvider>(context, listen: false)
        .getRefreshToken() as String;

    String clockDrift = Provider.of<SecurityProvider>(context, listen: false)
        .getClockDrift() as String;

    Map<String, ConfigurationSchema> userCredentialsMap =
        await getuserCredentialsFromStorage();

    String username =
        userCredentialsMap[Constants.DEVICE_USERNAME]?.value as String;

    CognitoUserSession session = CognitoUserSession(
      CognitoIdToken(idToken),
      CognitoAccessToken(accessToken),
      refreshToken: CognitoRefreshToken(refreshToken),
      clockDrift: int.parse(clockDrift),
    );
    try {
      return await AuthenticationService().signoutUser(username, session);
    } catch (e) {
      //TO-DO
    }
    return true;
  }

  bool checkTokenValidity(String token) {
    if (DateTime.now()
        .add(Duration(minutes: 1))
        .isBefore(tokenExpiration(token))) {
      return true;
    }
    return false;
  }

  DateTime tokenExpiration(String token) {
    Map<String, dynamic> payloadMap = Jwt.parseJwt(token);

    return DateTime.fromMillisecondsSinceEpoch(
        payloadMap[Constants.JWT_EXPIRATION_KEY] * 1000);
  }

  Future<CognitoUserSession?> refreshSession(
      CognitoUserSession session, String username) async {
    if (!checkTokenValidity(session.idToken.jwtToken as String)) {
      return await AuthenticationService().refreshSession(username, session);
    } else {
      return session;
    }
  }

  Future<void> deleteAuthenticationFile() async {
    return await AuthenticationService().deleteAuthenticationFile();
  }
}
