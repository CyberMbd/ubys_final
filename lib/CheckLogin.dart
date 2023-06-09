import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import 'package:http/http.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import 'HomePage.dart';

class CheckLoginPage extends StatefulWidget {
  const CheckLoginPage({Key? key}) : super(key: key);

  @override
  State<CheckLoginPage> createState() => _CheckLoginPageState();
}

class _CheckLoginPageState extends State<CheckLoginPage> {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp();
  }

  Future<void> checkLogin() async {
    final encoding = Encoding.getByName('utf-8');
    final URL = Uri.parse('https://node.kamanmyo.com/user/check');

    final prefs = await SharedPreferences.getInstance();
    // Try reading data from the counter key. If it doesn’t exist, return 0.
    final email = prefs.getString('email') ?? '';
    final password = prefs.getString('password') ?? '';
    if (email != '' && password != '') {
      var body = {'email': email, 'password': password};
      print(body);

      Response response = await post(URL, body: body, encoding: encoding);
      var result = jsonDecode(response.body);
      print(result);
    }
  }
}
