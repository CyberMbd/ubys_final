import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart';

import 'ProductList.dart';
import 'CategoryPage.dart';
import 'SepetPage.dart';
import 'RegisterPage.dart';
import 'SignInPage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _controller = ScrollController();
  final TextEditingController _controllerProductName = TextEditingController();
  final TextEditingController _controllerProductDesc = TextEditingController();
  final TextEditingController _controllerProductUnit = TextEditingController();
  final TextEditingController _controllerProductPrice = TextEditingController();

  PickedFile? pickedFile;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Container(
            child: Scaffold(
                appBar: AppBar(
                  title: const Text(
                    'Anasayfa',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  backgroundColor: const Color.fromARGB(255, 255, 162, 68),
                  actions: [
                    //app bardaki butonlar
                    IconButton(
                        onPressed: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const RegisterPage()),
                            ),
                        icon: const Icon(Icons.app_registration_rounded)),
                    IconButton(
                        onPressed: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const SignInPage()),
                            ),
                        icon: const Icon(Icons.login)),
                  ],
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
                                  getProductList();
                                },
                                child: const Text("Ürünleri Çek")),
                            if (pickedFile != null)
                              Image.file(
                                File(pickedFile!.path),
                                height: 100,
                              ),
                            const Text('Kategori eklemek butona tıklayınız!'),
                            TextButton(
                                onPressed: () => Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const CategoryPage()),
                                    ),
                                child: const Text("kategori ekle")),
                            const Text('Sepet eklemek butona tıklayınız!'),
                            TextButton(
                                onPressed: () => Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const SepetPage()),
                                    ),
                                child: const Text("Sepet işlemleri")),
                            TextFormField(
                              controller: _controllerProductName,
                              decoration:
                                  const InputDecoration(labelText: 'Ürün Adı'),
                            ),
                            TextFormField(
                              controller: _controllerProductDesc,
                              decoration: const InputDecoration(
                                  labelText: 'Ürün Açıklaması'),
                            ),
                            TextFormField(
                              controller: _controllerProductPrice,
                              decoration: const InputDecoration(
                                  labelText: 'Ürün Fiyatı'),
                            ),
                            TextFormField(
                              controller: _controllerProductUnit,
                              decoration: const InputDecoration(
                                  labelText: 'Ürün Miktarı'),
                            ),
                            TextButton(
                                onPressed: () {
                                  _showPicker(context);
                                },
                                child: const Text("Ürün Resmi Çek")),
                            TextButton(
                                onPressed: () {
                                  if (updatedProductID != 0) {
                                    updateProduct();
                                  } else {
                                    addNewProduct();
                                  }
                                },
                                child: Text((updatedProductID == 0)
                                    ? "Ürünü Kaydet"
                                    : "Ürünü Güncelle")),
                            if (updatedProductID != 0)
                              TextButton(
                                onPressed: () {
                                  _controllerProductName.text = '';
                                  _controllerProductDesc.text = '';
                                  _controllerProductPrice.text = '';
                                  _controllerProductUnit.text = '';
                                  updatedProductID = 0;
                                  setState(() {});
                                },
                                child: const Text("Güncellemeyi İptal Et"),
                              ),
                            for (var i in productList)
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
                                    i.productDesc.toString(),
                                    style: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.normal),
                                  ),
                                  Text(
                                    "₺${i.price}",
                                    style: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.normal),
                                  ),
                                  Text(
                                    "${i.unit} adet kaldı",
                                    style: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.normal),
                                  ),
                                  Image.network(i.image.toString()),
                                  TextButton(
                                      onPressed: () {
                                        increaseBasket(i.productID);
                                      },
                                      child: const Text("Arttır")),
                                  TextButton(
                                      onPressed: () {
                                        decreaseBasket(i.productID);
                                      },
                                      child: const Text("Azalt")),
                                  TextButton(
                                      onPressed: () {
                                        deleteProduct(i.productID);
                                        getProductList();
                                      },
                                      child: const Text("Ürünü Sil")),
                                  TextButton(
                                      onPressed: () {
                                        _controllerProductName.text =
                                            i.productName.toString();
                                        _controllerProductDesc.text =
                                            i.productDesc.toString();
                                        _controllerProductPrice.text =
                                            i.price.toString();
                                        _controllerProductUnit.text =
                                            i.unit.toString();
                                        updatedProductID = i.productID!;
                                        setState(() {});
                                      },
                                      child: const Text("Ürünü Güncelle"))
                                ],
                              )
                          ],
                        ))))));
  }

  void _showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
              child: Container(
                  child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text("Gaeriden seç"),
                onTap: () {
                  _imgFromGallery();
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_camera),
                title: const Text("Kamera ile çek"),
                onTap: () {
                  _imgFromCamera();
                  Navigator.of(context).pop();
                },
              ),
            ],
          )));
        });
  }

  final _picker = ImagePicker();
  void _imgFromGallery() async {
    pickedFile =
        await _picker.getImage(source: ImageSource.gallery, imageQuality: 70);
    setState(() {});
  }

  void _imgFromCamera() async {
    pickedFile =
        await _picker.getImage(source: ImageSource.camera, imageQuality: 70);
    setState(() {});
  }

  Future<void> increaseBasket(int? productID) async {
    final encoding = Encoding.getByName('utf-8');
    final prefs = await SharedPreferences.getInstance();
    final userID = prefs.getInt("userID");
    final URL = Uri.parse('https://node.kamanmyo.com/basket/update/$userID');
    var body = {'productID': productID, 'processType': "increase"};

    Response response = await post(URL, body: body, encoding: encoding);
    var result = jsonDecode(response.body);
  }

  Future<void> decreaseBasket(int? productID) async {
    final encoding = Encoding.getByName('utf-8');
    final prefs = await SharedPreferences.getInstance();
    final userID = prefs.getInt("userID");
    final URL = Uri.parse('https://node.kamanmyo.com/basket/update/$userID');
    var body = {'productID': productID, 'processType': "decrease"};

    Response response = await post(URL, body: body, encoding: encoding);
    var result = jsonDecode(response.body);
  }

  int updatedProductID = 0;
  List<ProductList> productList = [];

  Future<void> getProductList() async {
    productList = [];
    final URL = Uri.parse('https://node.kamanmyo.com/products');
    Response response = await get(URL);
    var result = jsonDecode(response.body);
    print(response.body);
    for (var u in result["data"]) {
      ProductList product = ProductList(
          productID: u["productID"],
          productName: u["productName"],
          productDesc: u["productDesc"],
          categoryID: u["categoryID"],
          unit: u["unit"],
          price: double.parse(u["price"].toString()),
          image: u["image"]);
      productList.add(product);
    }
    setState(() {});
  }

  Future<void> deleteProduct(int? productID) async {
    final URL =
        Uri.parse('https://node.kamanmyo.com/product/delete/$productID');
    Response response = await delete(URL);
    var result = jsonDecode(response.body);
  }

  Future<void> addNewProduct() async {
    String base64 = "";
    if (pickedFile != null) {
      final byte = await File(pickedFile!.path).readAsBytes();
      base64 = base64Encode(byte);
    }

    final encoding = Encoding.getByName('utf-8');
    final URL = Uri.parse('https://node.kamanmyo.com/product/create');
    var body = {
      'productName': _controllerProductName.text,
      'productDesc': _controllerProductDesc.text,
      'productPrice': _controllerProductPrice.text,
      'productUnit': _controllerProductUnit.text,
      'productImage': base64
    };

    Response response = await post(URL, body: body, encoding: encoding);
    var result = jsonDecode(response.body);
    _controllerProductName.text = '';
    _controllerProductDesc.text = '';
    _controllerProductPrice.text = '';
    _controllerProductUnit.text = '';
    pickedFile = null;
    getProductList();
  }

  Future<void> updateProduct() async {
    String base64 = "";
    if (pickedFile != null) {
      final byte = await File(pickedFile!.path).readAsBytes();
      base64 = base64Encode(byte);
    }

    final encoding = Encoding.getByName('utf-8');
    final URL =
        Uri.parse('https://node.kamanmyo.com/product/update/$updatedProductID');
    var body = {
      'productName': _controllerProductName.text,
      'productDesc': _controllerProductDesc.text,
      'productPrice': _controllerProductPrice.text,
      'productUnit': _controllerProductUnit.text,
      'productImage': base64
    };
    Response response = await put(URL, body: body, encoding: encoding);
    var result = jsonDecode(response.body);
    print(response.body);
    _controllerProductName.text = '';
    _controllerProductDesc.text = '';
    _controllerProductPrice.text = '';
    _controllerProductUnit.text = '';
    updatedProductID = 0;
    pickedFile = null;
    getProductList();
  }
}
