// ignore_for_file: constant_identifier_names

import "package:flutter/material.dart";

class Constants {
  static const String DEVICE_USERNAME = 'DEVICE-USERNAME';
  static const String DEVICE_PASSWORD = "DEVICE-PASSWORD";
  static const String ACCESS_TOKEN = "ACCESS-TOKEN";
  static const String ID_TOKEN = "ID-TOKEN";
  static const String REFRESH_TOKEN = "REFRESH-TOKEN";
  static const String CLOCK_DRIFT = "CLOCK-DRIFT";
  static const String DEVICE_ATTEMPTS = "DEVICE-ATTEMPTS";
  static const String DEVICE_PIN = "IS-USER-PIN-SET";

  static const int DEVICE_ATTEMPTS_INITIAL_VALUE = 10;
  static const String PASSWORD_ATTEMPTS_EXCEEDED = "Password attempts exceeded";

  static const String USER_POOL_ID = "USER_POOL_ID";
  static const String USER_POOL_CLIENT_ID = "USER_POOL_CLIENT_ID";

  static const String DOMAIN_URL = "DOMAIN_URL";
  static const STAGE = "STAGE";

  static const String COLOR_PRIMARY = "PRIMARY";
  static const String COLOR_INFO = "INFO";
  static const String COLOR_ERROR = "ERROR";
  static const String COLOR_SUCCESS = "SUCCESS";
  static const String COLOR_WARNING = "WARNING";
  static const String COLOR_SECONDARY = "SECONDARY";
  static const String COLOR_ACCENT = "ACCENT";
  static const String COLOR_TEXT_BLACK = "TEXT_BLACK";

  static const Map<String, Color> MATERIAL_COLORS = {
    COLOR_PRIMARY: Color.fromARGB(255, 21, 101, 192),
    COLOR_INFO: Color.fromARGB(255, 117, 117, 117),
    COLOR_ERROR: Color.fromARGB(255, 183, 28, 28),
    COLOR_SUCCESS: Color.fromARGB(255, 0, 191, 165),
    COLOR_WARNING: Color.fromARGB(255, 255, 160, 0),
    COLOR_ACCENT: Color.fromARGB(255, 121, 134, 203),
    COLOR_SECONDARY: Color.fromARGB(255, 0, 176, 255),
    COLOR_TEXT_BLACK: Color.fromARGB(255, 27, 27, 27),
  };

  static Color? getSnackbarColor(type) {
    switch (type) {
      case COLOR_SUCCESS:
        return MATERIAL_COLORS[COLOR_SUCCESS];
      case COLOR_ERROR:
        return MATERIAL_COLORS[COLOR_ERROR];
      default:
        return MATERIAL_COLORS[COLOR_INFO];
    }
  }

  static const String JWT_EXPIRATION_KEY = "exp";

  static const String REPORT_STATUS_DRAFT = "draft";
  static const String REPORT_STATUS_CLOSED = "closed";

  static const String MESSAGE_SUCCESS = "SUCCESS";
  static const String MESSAGE_ERROR = "ERROR";

  static MaterialStateProperty<Size> get largeSizeButton =>
      MaterialStateProperty.all<Size>(Size.fromHeight(58));

  static const String HTTP_HEADERS_CONTENT_TYPE = "Content-Type";
  static const String HTTP_HEADERS_CONTENT_TYPE_VALUE_JSON = "application/json";
  static const String HTTP_HEADERS_AUTHORIZATION = "Authorization";
  static const String HTTP_HEADERS_AUTHORIZATION_BASIC = "Basic ";
  static const String HTTP_HEADERS_AUTHORIZATION_BEARER = "Bearer ";
  static const List<String> USER_INTERESTS = [
    "Reading",
    "Bird watching",
    "Gardening",
    "Volunteering",
    "Learning about history",
    "Walking",
    "Music",
    "Playing games",
    "Food",
    "Languages",
    "Arts & crafts"
  ];
}
