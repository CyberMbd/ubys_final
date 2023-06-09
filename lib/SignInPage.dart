import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import 'package:http/http.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import 'HomePage.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({Key? key}) : super(key: key);

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final _controller = ScrollController();
  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();
  String _errorMessage = '';
  String statusMessage = "";
  // Future<bool> status = Future._falseFuture;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Container(
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            "Hello, and welcome to the Baha's Application",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          backgroundColor: const Color.fromARGB(255, 255, 162, 68),
        ),
        body: SingleChildScrollView(
          controller: _controller,
          padding: const EdgeInsets.all(5),
          child: Container(
              padding: const EdgeInsets.all(20),
              child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        _errorMessage,
                        style: const TextStyle(color: Colors.red),
                      ),
                    ),
                    TextFormField(
                      controller: _controllerEmail,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                          icon: Icon(Icons.email), labelText: 'Epostanız'),
                      onChanged: (val) {
                        validateEmail(val);
                      },
                    ),
                    TextFormField(
                      obscureText: true,
                      controller: _controllerPassword,
                      keyboardType: TextInputType.visiblePassword,
                      decoration: const InputDecoration(
                          icon: Icon(Icons.password), labelText: 'Şifreniz'),
                    ),
                    TextButton(
                        onPressed: () {
                          print("login"); //kayıt ol butonu ekle
                          singIn();
                        },
                        child: const Text("Giriş Yap")),
                    // if (status == true) {
                    //     () => Navigator.push(
                    //           context,
                    //           MaterialPageRoute(
                    //               builder: (context) => const HomePage()),
                    //         );
                    //   } else {
                    //     Padding(
                    //       padding: const EdgeInsets.all(8.0),
                    //       child: Text(
                    //         statusMessage,
                    //         style: const TextStyle(color: Colors.red),
                    //       ),
                    //     );
                    //   }
                  ])),
        ),
      ),
    ));
  }

  void validateEmail(String val) {
    if (val.isEmpty) {
      setState(() {
        _errorMessage = "Eposta boş olamaz!";
      });
    } else if (!EmailValidator.validate(val, true)) {
      setState(() {
        _errorMessage = "Geçersiz eposta adresi!";
      });
    } else {
      setState(() {
        _errorMessage = "";
      });
    }
  }

  Future<bool> singIn() async {
    final encoding = Encoding.getByName('utf-8');
    final URL = Uri.parse('https://node.kamanmyo.com/user/login');

    var body = {
      'email': _controllerEmail.text,
      'password': _controllerPassword.text
    };
    print("login post yapıyoruz");
    print(body);

    Response response = await post(URL, body: body, encoding: encoding);
    var result = jsonDecode(response.body);
    print(result);
    if (result["status"] == "true") {
      _controllerEmail.text = '';
      _controllerPassword.text = '';
      final prefs = await SharedPreferences.getInstance();
      prefs.setString('email', result["email"]);
      prefs.setString('password', result["password"]);
      prefs.setInt('userID', result["userID"]);
      statusMessage = result["desc"];
      return true;
    } else {
      statusMessage = result["desc"];
      return false;
    }
  }
}
