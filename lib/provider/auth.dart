import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shop_app/models/httpException.dart';

class Auth with ChangeNotifier{
  String? _token;
  DateTime? _expiryDate;
  String? _userId;
  Timer? _authTimer;

  bool get isAuth {
    return isToken != null;
  }
String? get userId{
  return _userId;
}
  String? get isToken{
    if(_expiryDate != null && _expiryDate!.isAfter(DateTime.now()) && _token != null){
      return _token;
    }
    return null;
  }
  
  Future<void> _authantication(String email, String password, String urlsegment) async {
  final url = Uri.parse('https://identitytoolkit.googleapis.com/v1/accounts:$urlsegment?key=AIzaSyDjeXjGfSUUc6gcUcHkJ55NHrgODr1a9Fo');

  try{
  final response = await http.post(url, body: json.encode(
    {
      'email': email,
      'password': password,
      'returnSecureToken': true
    }
  )

  );
  // print(json.decode(response.body));
  final responseData = json.decode(response.body);
  if(responseData['error'] != null){
    throw HttpException(responseData['error']['message']);
  }
  _token = responseData['idToken'];
  _userId = responseData['localId'];
  _expiryDate = DateTime.now().add(
    Duration(
      seconds: int.parse(
        responseData['expiresIn']
        )
  )
  );
  _autoLogout();
  notifyListeners();
  final pref = await SharedPreferences.getInstance();
  final userData = json.encode({
    'token': _token, 
    'userId': _userId,
    'expiryDate': _expiryDate!.toIso8601String()
    });
  pref.setString('userData', userData);
  } catch (error){
    throw error;
  }
  }

  Future<void> signup(String email, String password) async {
    return _authantication(email, password, 'signUp');
  }

  Future<void> login(String email, String password) async {
    return _authantication(email, password, 'signInWithPassword');
  }

  Future<bool>  tryAutoLogin() async {
    final pref = await SharedPreferences.getInstance();
    if(!pref.containsKey('userData')){
      return false;
    }
    final extractedUserData = json.decode(pref.getString('userData') as String) as Map<String, Object>;
    final expiryDate = DateTime.parse(extractedUserData['expiryDate'] as String);

    if(expiryDate.isBefore(DateTime.now())){
      return false;
    }

    _token = extractedUserData['token'] as String;
    _userId = extractedUserData['userId'] as String;
    _expiryDate = expiryDate;
    notifyListeners();
    _autoLogout();
    return true;
  }


  Future<void> logout() async {
    _token = null;
    _userId = null;
    _expiryDate = null;
    if(_authTimer != null){
      _authTimer!.cancel();
      _authTimer = null;
    }
    notifyListeners();
    final pref = await SharedPreferences.getInstance();
    pref.clear();
  }

  void _autoLogout(){
    if(_authTimer != null){
      _authTimer!.cancel();
    }
    final timeToExpire = _expiryDate!.difference(DateTime.now()).inSeconds;
    _authTimer = Timer(Duration(seconds: timeToExpire), logout);
  }
}