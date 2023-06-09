import 'dart:convert';
import 'package:http/http.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; //traihi lokalize etmek için
import 'package:crypto/crypto.dart';
import 'package:email_validator/email_validator.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _controller = ScrollController();
  String _errorMessage = '';
  String registerStatusMessage = "";
  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();
  final TextEditingController _controllerName = TextEditingController();
  final TextEditingController _controllerSurname = TextEditingController();
  final TextEditingController _controllerGender = TextEditingController();
  final TextEditingController _controllerBirthdate = TextEditingController();
  DateTime selectedDate = DateTime.now();

  @override
  void initState() {
    _controllerBirthdate.text = "";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Container(
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Kayıt Ol',
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
                    TextFormField(
                      controller: _controllerName,
                      decoration: const InputDecoration(
                          icon: Icon(Icons.text_fields), labelText: 'Adınız'),
                    ),
                    TextFormField(
                      controller: _controllerSurname,
                      decoration: const InputDecoration(
                          icon: Icon(Icons.text_fields),
                          labelText: 'Soyadınız'),
                    ),
                    TextFormField(
                      controller: _controllerGender,
                      decoration: const InputDecoration(
                          icon: Icon(Icons.man), labelText: 'Cinsiyetiniz'),
                    ),
                    TextFormField(
                      controller: _controllerBirthdate,
                      decoration: const InputDecoration(
                          icon: Icon(Icons.calendar_today),
                          labelText: 'Doğum tarihiniz'),
                      onTap: () async {
                        DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(1900),
                            lastDate: DateTime.now());
                        if (pickedDate != null) {
                          print(pickedDate);
                          String formattedDate = DateFormat('yyyy-MM-dd')
                              .format(pickedDate)
                              .toString();
                          print(formattedDate);
                          setState(() {
                            _controllerBirthdate.text =
                                formattedDate; //set output date to TextField value.
                          });
                        } else {
                          print("Tarih seçilmedi");
                        }
                      },
                    ),
                    TextButton(
                        onPressed: () {
                          print("register"); //kayıt ol butonu ekle
                          addNewUser();
                        },
                        child: const Text("Kayıt Ol")),
                    if (registerStatusMessage != "")
                      Text(
                        registerStatusMessage,
                        style: const TextStyle(color: Colors.red),
                      )
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

  _selectDate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate, // Refer step 1
      firstDate: DateTime(1900),
      lastDate: DateTime(2025),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

// sha1 şifreleme
  String encryptPassword(String password) {
    var bytes = utf8.encode(password);
    Digest sha1Result = sha1.convert(bytes);
    String passwordHash = sha1Result.toString();
    print(passwordHash);
    return passwordHash;
  }

  Future<void> addNewUser() async {
    final encoding = Encoding.getByName('utf-8');
    final URL = Uri.parse('https://node.kamanmyo.com/user/create');
    String passwordHash = encryptPassword(_controllerPassword.text);

    var body = {
      'email': _controllerEmail.text,
      'password': passwordHash,
      'name': _controllerName.text,
      'surname': _controllerSurname.text,
      'gender': _controllerGender.text,
      'date': _controllerBirthdate.text
    };
    print("post yapıyoruz");
    print(body);
    Response response = await post(URL, body: body, encoding: encoding);
    var result = jsonDecode(response.body);
    print(result);
    if (result["status"] == "true") {
      _controllerEmail.text = '';
      _controllerPassword.text = '';
      _controllerName.text = '';
      _controllerSurname.text = '';
      _controllerGender.text = '';
      _controllerBirthdate.text = '';
      registerStatusMessage = result["desc"];
    } else {
      registerStatusMessage = result["desc"];
    }
  }
}
