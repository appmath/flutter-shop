import 'dart:async';
import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:flutter_shop/models/http_exception.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Auth with ChangeNotifier {
  final userDataKey = 'userData';
  final expiryDateKey = 'expiryDate';
  final userIdKey = 'userId';
  final tokenKey = 'token';

  String? _token;
  DateTime? _expiryDate;
  String? _userId;
  Timer? _authTimer;

  bool get isAuth {
    return _token != null;
  }

  String? get token {
    if (_expiryDate != null &&
        _expiryDate!.isAfter(DateTime.now()) &&
        _token != null) {
      return _token;
    }
    return null;
  }

  Future<void> _authenticate(
      String? email, String? password, String? urlSegment) async {
    final url =
        'https://identitytoolkit.googleapis.com/v1/accounts:$urlSegment?key=AIzaSyAgw6fygc4cqy6C6BZeBTUTtrPtevdlntQ';

    try {
      final response = await http.post(Uri.parse(url),
          body: json.encode({
            'email': email,
            'password': password,
            'returnSecureToken': true,
          }));
      var responseBody = json.decode(response.body);
      print('_authenticate Response: $responseBody');
      print('_authenticate response.statusCode: ${response.statusCode}');

      if (responseBody['error'] != null &&
          responseBody['error']['message'] != null) {
        throw HttpException(message: responseBody['error']['message']);
      }
      _token = responseBody['idToken'];
      // print('-----> _token: $_token');

      _userId = responseBody['localId'];
      _expiryDate = DateTime.now().add(
        Duration(
          seconds: int.parse(responseBody['expiresIn']),
        ),
      );
      _autoLogout();
      // if (response.statusCode >= 400) {
      //   throw HttpException(message: responseBody['error']['message']);
      // }

      notifyListeners();
      final prefs = await SharedPreferences.getInstance();
      final userData = json.encode({
        tokenKey: _token,
        userIdKey: _userId,
        expiryDateKey: _expiryDate!.toIso8601String()
      });
      prefs.setString(userDataKey, userData);
    } catch (e) {
      rethrow;
    }
  }

  String? get userId => _userId;

  Future<void> signup(String? email, String? password) async {
    return _authenticate(email, password, 'signUp');
  }

  Future<void> login(String? email, String? password) async {
    return _authenticate(email, password, 'signInWithPassword');
  }

  Future<bool> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    print('prefs.getString(userDataKey) : ${prefs.getString(userDataKey)}');
    if (!prefs.containsKey(userDataKey)) {
      return false;
    }

    final extractedUserData =
        prefs.getString(userDataKey) as Map<String, dynamic>;
    final expiryDate = DateTime.parse(extractedUserData[expiryDateKey]);

    if (expiryDate.isBefore(DateTime.now())) {
      return false;
    }

    _token = extractedUserData[tokenKey];
    _userId = extractedUserData[userIdKey];
    _expiryDate = expiryDate;
    notifyListeners();
    _autoLogout();
    return true;
  }

  Future<void> logout() async {
    _token = null;
    _userId = null;
    _expiryDate = null;
    if (_authTimer != null) {
      _authTimer!.cancel();
      _authTimer = null;
    }
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    // Use prefs.remove('userData') if you need to preserve some other data
    prefs.clear();
  }

  void _autoLogout() {
    print('_authTimer: $_authTimer');

    if (_authTimer != null) {
      _authTimer!.cancel();
    }
    final timeToExpiry = _expiryDate!.difference(DateTime.now()).inSeconds;
    _authTimer = Timer(Duration(seconds: timeToExpiry), logout);
    // _authTimer = Timer(Duration(seconds: 3), logout);
  }
}

// TODO
// Description: Shared preferences
// URL: https://pub.dev/packages/shared_preferences
// Install: flutter pub add shared_preferences
// App: flutter_shop,  src/mobile/flutter/learning/udemy/flutter-dart-complete-guide/flutter_shop

// Example:

// Full example
