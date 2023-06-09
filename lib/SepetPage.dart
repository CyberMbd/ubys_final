import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'MyProductList.dart';

class SepetPage extends StatefulWidget {
  const SepetPage({Key? key}) : super(key: key);

  @override
  State<SepetPage> createState() => _SepetPageState();
}

class _SepetPageState extends State<SepetPage> {
  final _controller = ScrollController();
  final TextEditingController _controllerProductID = TextEditingController();
  final TextEditingController _controllerProductName = TextEditingController();
  final TextEditingController _controllerProductUnit = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Container(
            child: Scaffold(
                appBar: AppBar(
                  backgroundColor: const Color.fromARGB(255, 255, 162, 68),
                  title: const Text(
                    'Sepet işlemleri',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
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
                              const Text('Ürünleri çağırmak içn butona basın!'),
                              TextButton(
                                  onPressed: () {
                                    getUserProducts(); //direk çekemediğim için buton ekledim
                                  },
                                  child: const Text("Ürünleri Çek")),
                              for (var i in myProductList)
                                Column(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      i.productName.toString(),
                                      style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      i.unit.toString(),
                                      style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                )
                            ]))))));
  }

  // Kullanıcı sepet işlemleri
  // hocam burada userId, email, password bilgilerini göndererek kullanıcını
  // sepette olan ürünlerini çekiyorum.
  List<MyProductList> myProductList = [];

  Future<void> getUserProducts() async {
    final encoding = Encoding.getByName('utf-8');
    final prefs = await SharedPreferences.getInstance();
    final userID = prefs.getInt("userID");
    final email = prefs.getString("email");
    final password = prefs.getString("password");

    final URL = Uri.parse('https://node.kamanmyo.com/basket/$userID');
    var body = {'email': email, 'password': password};

    Response response = await post(URL, body: body, encoding: encoding);
    var result = jsonDecode(response.body);

    MyProductList product = MyProductList(
      productID: result['productID'] != null
          ? (result['productID'] as num?)?.toInt()
          : null,
      productName: result['productName'] != null
          ? (result['productName'] as String?)
          : "",
      unit: result['unit'] != null ? (result['unit'] as num?)?.toInt() : null,
    );
    myProductList.add(product);
    setState(() {});
  }
}
