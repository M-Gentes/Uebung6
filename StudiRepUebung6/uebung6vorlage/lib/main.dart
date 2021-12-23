// Copyright 2019 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './model/list.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    // Provide the model to all widgets within the app. We're using
    // ChangeNotifierProvider because that's a simple way to rebuild
    // widgets when a model changes. We could also just use
    // Provider, but then we would have to listen to Counter ourselves.
    //
    // Read Provider's docs to learn about all the available providers.

    //https://pub.dev/documentation/provider/latest/provider/ChangeNotifierProvider-class.html
    ChangeNotifierProvider(
      // Initialize the model in the builder. That way, Provider
      // can own Counter's lifecycle, making sure to call `dispose`
      // when not needed anymore.
      create: (context) => ShopList(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter CRUD Uebung 6',
      theme: ThemeData(
        brightness: Brightness.light,
        /* light theme settings */
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        /* dark theme settings */
      ),
      themeMode: ThemeMode.dark,
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  MyHomePage({Key? key}) : super(key: key);

  final fieldText = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('BuyBye - Einkaufsliste'),
        leading: const Icon(Icons.shopping_cart_sharp),
      ),
      body: Column(children: <Widget>[
        const Expanded(child: SList()),
        TextField(
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'Hinzufügen',
          ),
          onSubmitted: (String value) async {
            Provider.of<ShopList>(context, listen: false).create(value);
            fieldText.clear();
          },
          controller: fieldText,
        )
      ]),
    );
  }
}

class SList extends StatefulWidget {
  const SList({Key? key}) : super(key: key);

  @override
  State<SList> createState() => _SListState();
}

class _SListState extends State<SList> {
  @override
  void initState() {
    Future(() {
      var prov = Provider.of<ShopList>(context, listen: false);
      prov.init().then((value) {});
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var list = context.watch<ShopList>();
    return ListView.builder(
      itemCount: list.items.length,
      itemBuilder: (context, index) {
        var item = list.items[index];
        return ListTile(
          leading: IconButton(
            color:
                (item.check ? Colors.lightGreen[700] : Colors.deepOrange[700]),
            icon: Icon(item.check ? Icons.check_box : Icons.assignment_late),
            onPressed: () {
              list.check(item.id);
            },
          ),
          trailing: IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              list.delete(item.id);
            },
          ),
          title: Text(list.items[index].title),
        );
      },
    );
  }
}
