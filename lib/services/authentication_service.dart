import "dart:async";
import "package:amazon_cognito_identity_dart_2/cognito.dart";
import "package:amity/app_config.dart";
import "package:amity/constants/app_constants.dart";
import "package:amity/repositories/file_repository.dart";

class AuthenticationService {
  final String filename = "device";

  Future<CognitoUserSession?> signIn(String username, String password) async {
    final userPool = CognitoUserPool(
      AppConfig.properties[Constants.USER_POOL_ID] as String,
      AppConfig.properties[Constants.USER_POOL_CLIENT_ID] as String,
    );
    final cognitoUser = CognitoUser(username, userPool);
    final authDetails =
        AuthenticationDetails(username: username, password: password);
    try {
      return await cognitoUser.authenticateUser(authDetails);
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> signUp(String username, String password,
      List<AttributeArg>? userAttributes) async {
    print('Signup:  ${AppConfig.properties[Constants.USER_POOL_ID] as String}');
    print('${AppConfig.properties[Constants.USER_POOL_CLIENT_ID] as String}');
    final userPool = CognitoUserPool(
      AppConfig.properties[Constants.USER_POOL_ID] as String,
      AppConfig.properties[Constants.USER_POOL_CLIENT_ID] as String,
    );
    try {
      await userPool.signUp(username, password, userAttributes: userAttributes);
      return true;
    } catch (e, currentTrace) {
      print(currentTrace);
      rethrow;
    }
  }

  Future<bool> changePassword(
      String username, String password, String newPassword) async {
    final userPool = CognitoUserPool(
      AppConfig.properties[Constants.USER_POOL_ID] as String,
      AppConfig.properties[Constants.USER_POOL_CLIENT_ID] as String,
    );
    final cognitoUser = CognitoUser(username, userPool);
    final authDetails = AuthenticationDetails(
      username: username,
      password: password,
    );

    //CognitoUserSession session;
    try {
      await cognitoUser.authenticateUser(authDetails);
      final cognitoPasswordChange = CognitoUser(username, userPool);
      bool passwordChanged =
          await cognitoPasswordChange.changePassword(password, newPassword);
      return passwordChanged;
    } catch (e) {
      rethrow;
    }
  }

  Future<CognitoUserSession> authenticate(
      String username, String password) async {
    final userPool = CognitoUserPool(
      AppConfig.properties[Constants.USER_POOL_ID] as String,
      AppConfig.properties[Constants.USER_POOL_CLIENT_ID] as String,
    );

    final cognitoUser = CognitoUser(username, userPool);
    final authDetails = AuthenticationDetails(
      username: username,
      password: password,
    );
    try {
      return await cognitoUser.authenticateUser(authDetails)
          as CognitoUserSession;
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> signoutUser(String username, CognitoUserSession session) async {
    final userPool = CognitoUserPool(
      AppConfig.properties[Constants.USER_POOL_ID] as String,
      AppConfig.properties[Constants.USER_POOL_CLIENT_ID] as String,
    );
    final cognitoUser =
        CognitoUser(username, userPool, signInUserSession: session);

    try {
      await cognitoUser.globalSignOut();
      return true;
    } catch (e) {
      rethrow;
    }
  }

  Future<CognitoUserSession?> refreshSession(
      String username, CognitoUserSession session) async {
    final userPool = CognitoUserPool(
      AppConfig.properties[Constants.USER_POOL_ID] as String,
      AppConfig.properties[Constants.USER_POOL_CLIENT_ID] as String,
    );

    final cognitoUser = CognitoUser(username, userPool);
    return await cognitoUser
        .refreshSession(session.refreshToken as CognitoRefreshToken);
  }

  Future<bool> saveConfigurationFile(String configurationData) {
    try {
      FileRepository(filename).writeData(configurationData);
      return Future.value(true);
    } catch (e) {
      return Future.value(false);
    }
  }

  Future<String> readConfigurationFile() async {
    try {
      return await FileRepository(filename).readData();
    } catch (e) {
      return Future.value("");
    }
  }

  Future<void> deleteAuthenticationFile() async {
    try {
      return await FileRepository(filename).deleteFile();
    } catch (e) {
      //TO DO
    }
  }
}
