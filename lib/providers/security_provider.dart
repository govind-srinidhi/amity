import "package:flutter/foundation.dart";
import "package:flutter/services.dart";
import "package:flutter_secure_storage/flutter_secure_storage.dart";
import "package:path_provider/path_provider.dart";
import "package:amity/constants/app_constants.dart";
import "package:amity/controllers/authentication_controller.dart";
import "package:amity/controllers/configuration_controller.dart";

import "package:shared_preferences/shared_preferences.dart";

class SecurityProvider extends ChangeNotifier {
  final _storage = FlutterSecureStorage();
  int attempts = 0;
  bool devicePinSet = false;
  Future<bool> initCompleted = Future<bool>.value(false);
  String? devicePin;
  String? _idToken;
  String? _accessToken;
  String? _refreshToken;
  String? _clockDrift;

  void setIdToken(String idToken) {
    _idToken = idToken;
  }

  String? getIdToken() {
    return _idToken;
  }

  void setAccessToken(String accessToken) {
    _accessToken = accessToken;
  }

  String? getAccessToken() {
    return _accessToken;
  }

  void setRefreshToken(String refreshToken) {
    _refreshToken = refreshToken;
  }

  String? getRefreshToken() {
    return _refreshToken;
  }

  void setClockDrift(String clockDrift) {
    _clockDrift = clockDrift;
  }

  String? getClockDrift() {
    return _clockDrift;
  }

  SecurityProvider() {
    initSecurity();
  }

  Future<void> _deleteStorage() async {
    final cacheDir = await getTemporaryDirectory();
    if (cacheDir.existsSync()) {
      cacheDir.deleteSync(recursive: true);
    }

    final appDir = await getApplicationSupportDirectory();
    if (appDir.existsSync()) {
      appDir.deleteSync(recursive: true);
    }
    eraseAllData();
    await SystemChannels.platform.invokeMethod("SystemNavigator.pop");
  }

  /// + method: initSecurity.
  /// + parameters: None.
  /// + description: checks for jail break, intializes keys and stores in
  ///   key chain, initializes login attempts. once all bootup tasks are completed
  ///   it notifies its listeners.
  /// + returns: void.
  Future<void> initSecurity() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.getBool("first_run") ?? true) {
      await _storage.deleteAll();
      await prefs.setBool("first_run", false);
    }

    String? attemptsStr = await _storage.read(key: Constants.DEVICE_ATTEMPTS);
    attemptsStr ??= Constants.DEVICE_ATTEMPTS_INITIAL_VALUE.toString();

    attempts = int.parse(attemptsStr);
    devicePin = await _storage.read(key: Constants.DEVICE_PIN);

    devicePinSet = devicePin != null;
    initCompleted = Future<bool>.value(true);
    notifyListeners();
  }

  Future<void> resetAttempts() async {
    return await _storage.write(
        key: Constants.DEVICE_ATTEMPTS,
        value: Constants.DEVICE_ATTEMPTS_INITIAL_VALUE.toString());
  }

  void incrementAttempts() async {
    attempts++;
    if (attempts == 5) {
      eraseAllData();
    } else {
      await _storage.write(
          key: Constants.DEVICE_ATTEMPTS, value: attempts.toString());
      notifyListeners();
    }
  }

  Future<void> decrementAttemps() async {
    attempts--;

    if (attempts == 0) {
      return await eraseAllData();
    } else {
      await _storage.write(
          key: Constants.DEVICE_ATTEMPTS, value: attempts.toString());
      notifyListeners();
    }
  }

  Future<void> setUserPin() async {
    await _storage.write(key: Constants.DEVICE_PIN, value: "1");
    devicePinSet = true;
    notifyListeners();
  }

  Future<void> eraseAllData() async {
    await _storage.delete(key: Constants.DEVICE_ATTEMPTS);
    await _storage.delete(key: Constants.DEVICE_PIN);
    await _storage.delete(key: Constants.DEVICE_USERNAME);
    await _storage.delete(key: Constants.DEVICE_PASSWORD);
    devicePin = "";
    attempts = Constants.DEVICE_ATTEMPTS_INITIAL_VALUE;
    devicePinSet = false;
    initCompleted = Future<bool>.value(false);

    await ConfigurationController("configurations").deleteConfigurationFile();
    await ConfigurationController("user_details").deleteConfigurationFile();
    await AuthenticationController().deleteAuthenticationFile();
    notifyListeners();
  }
}
