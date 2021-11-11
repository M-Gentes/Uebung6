// Copyright 2019 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:cloud_firestore/cloud_firestore.dart';
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

/// Simplest possible model, with just one field.
///
/// [ChangeNotifier] is a class in `flutter:foundation`. [Counter] does
/// _not_ depend on Provider.
class Counter with ChangeNotifier {
  int value = 0;

  void increment() {
    value += 1;
    notifyListeners();
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
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

  final ListUpdater upd = ListUpdater();
  final fieldText = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Demo Home Page'),
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
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     // You can access your providers anywhere you have access
      //     // to the context. One way is to use Provider.of<Counter>(context).
      //     //
      //     // The provider package also defines extension methods on context
      //     // itself. You can call context.watch<Counter>() in a build method
      //     // of any widget to access the current state of Counter, and to ask
      //     // Flutter to rebuild your widget anytime Counter changes.
      //     //
      //     // You can't use context.watch() outside build methods, because that
      //     // often leads to subtle bugs. Instead, you should use
      //     // context.read<Counter>(), which gets the current state
      //     // but doesn't ask Flutter for future rebuilds.
      //     //
      //     // Since we're in a callback that will be called whenever the user
      //     // taps the FloatingActionButton, we are not in the build method here.
      //     // We should use context.read().

      //     // var counter = context.read<Counter>();
      //     // counter.increment();

      //     Provider.of<ShopList>(context, listen: false).create("HALLO");
      //   },
      //   tooltip: 'Increment',
      //   child: const Icon(Icons.add),
      // ),
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
    print("async start");

    Future.delayed(Duration.zero, () {
      var prov = Provider.of<ShopList>(context, listen: false);
      prov.init().then((value) {
        print("async done");
      });
    });

    super.initState();
    // var prov = Provider.of<ShopList>(context);
    // prov.init().then((value) {
    //   print("async done");
    //   super.initState();
    // });
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
            icon: Icon(item.check ? Icons.done : Icons.train),
            onPressed: () {
              list.check(item.id);
              // list.remove(list.items.values[index]);
            },
          ),
          trailing: IconButton(
            icon: const Icon(Icons.remove_circle_outline),
            onPressed: () {
              list.delete(item.id);
              // list.remove(list.items.values[index]);
            },
          ),
          title: Text(list.items[index].title),
        );
      },
    );
  }
}
