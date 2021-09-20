import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

// class _MyAppState extends State<MyApp> {
//   late Future<Album> futureAlbum;

//   @override
//   void initState() {
//     super.initState();
//     futureAlbum = fetchAlbum();
//   }

Future<Login> register(String username, String password, String first_name,
    String last_name, String email) async {
  http.Response response = await http.post(
      Uri.parse("https://masfirstassignment.herokuapp.com/api/register"),
      body: {
        "username": username,
        "password": password,
        "first_name": first_name,
        "last_name": last_name,
        "email": email
      });
  if (response.statusCode == 200) {
    var registerData = json.decode(response.body);
    return new Login(allow: true, username: registerData["username"]);
  } else {
    var registerData = json.decode(response.body);
    return new Login(allow: false, username: registerData["username"]);
  }
}

Future<Login> loginCheck(username, password) async {
  http.Response response = await http.post(
      Uri.parse("https://masfirstassignment.herokuapp.com/api/login"),
      body: {
        "username": username,
        "password": password,
      });
  var loginData = json.decode(response.body);
  if (response.statusCode == 200) {
    String username = loginData["username"];
    var user = new Login(allow: true, username: username);
    return user;
  }
}

// register?username=testusername&password=password&first_name=bob&last_name=smith&email=test@gmail.com

class Login {
  bool allow;
  String username;

  Login({this.allow, this.username});
}

class User {
  String username;
  String first_name;
  String last_name;
  String email;

  User({this.username, this.first_name, this.last_name, this.email});
}
