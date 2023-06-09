import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'CategoryList.dart';

class CategoryPage extends StatefulWidget {
  const CategoryPage({Key? key}) : super(key: key);

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  final _controller = ScrollController();
  final TextEditingController _controllerCategoryName = TextEditingController();
  final TextEditingController _controllerMainCategoryID =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Container(
        child: Scaffold(
            appBar: AppBar(
              backgroundColor: const Color.fromARGB(255, 255, 162, 68),
              title: const Text(
                'Kategori ekle',
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
                      const Text('Kategorileri çağırmak içn butona basın!'),
                      TextButton(
                          onPressed: () {
                            getCategoryList();
                          },
                          child: const Text("Kategorileri Çek")),
                      const Text('Kategori ismini giriniz'),
                      TextFormField(
                        controller: _controllerCategoryName,
                        decoration:
                            const InputDecoration(labelText: 'Kategori Name'),
                      ),
                      TextFormField(
                        controller: _controllerMainCategoryID,
                        decoration:
                            const InputDecoration(labelText: 'Ana kategori ID'),
                      ),
                      TextButton(
                          onPressed: () {
                            if (updatedCategoryID != 0) {
                              updateCategory();
                            } else {
                              addNewCategory();
                            }
                          },
                          child: Text((updatedCategoryID == 0)
                              ? "Kategoriyi Kaydet"
                              : "Kategoriyi Güncelle")),
                      for (var i in categoryList)
                        Column(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              i.categoryName.toString(),
                              style: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            TextButton(
                                onPressed: () {
                                  deleteCategory(i.categoryID);
                                  getCategoryList();
                                },
                                child: const Text("Kategoriyi Sil")),
                            TextButton(
                                onPressed: () {
                                  _controllerCategoryName.text =
                                      i.categoryName.toString();
                                  updatedCategoryID = i.categoryID!;
                                  setState(() {});
                                },
                                child: const Text("Kategoriyi Güncelle"))
                          ],
                        )
                    ]),
              ),
            )),
      ),
    );
  }

  int updatedCategoryID = 0;
  List<CategoryList> categoryList = [];

  Future<void> getCategoryList() async {
    categoryList = [];
    final URL = Uri.parse('https://node.kamanmyo.com/categories');
    Response response = await get(URL);
    var result = jsonDecode(response.body);
    print(response.body);
    for (var u in result["data"]) {
      CategoryList category = CategoryList(
          categoryID: u["categoryID"],
          categoryName: u["categoryName"],
          mainCategoryID: u["mainCategoryID"]);
      categoryList.add(category);
    }
    setState(() {});
  }

  Future<void> deleteCategory(int? categoryID) async {
    final URL =
        Uri.parse('https://node.kamanmyo.com/category/delete/$categoryID');
    Response response = await delete(URL);
    var result = jsonDecode(response.body);
    getCategoryList();
  }

  Future<void> addNewCategory() async {
    final encoding = Encoding.getByName('utf-8');
    final URL = Uri.parse('https://node.kamanmyo.com/category/create');
    var body = {
      'categoryName': _controllerCategoryName.text,
      'mainCategoryID': _controllerMainCategoryID.text,
    };

    Response response = await post(URL, body: body, encoding: encoding);
    var result = jsonDecode(response.body);
    _controllerCategoryName.text = '';
    _controllerMainCategoryID.text = '';
    getCategoryList();
  }

  Future<void> updateCategory() async {
    final encoding = Encoding.getByName('utf-8');
    final URL = Uri.parse(
        'https://node.kamanmyo.com/category/update/$updatedCategoryID');
    var body = {
      'categoryName': _controllerCategoryName.text,
      'mainCategoryID': _controllerMainCategoryID.text,
    };
    Response response = await put(URL, body: body, encoding: encoding);
    var result = jsonDecode(response.body);
    print(response.body);
    _controllerCategoryName.text = '';
    _controllerMainCategoryID.text = '';
    getCategoryList();
  }
}
