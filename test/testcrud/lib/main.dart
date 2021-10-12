// ignore_for_file: avoid_print

/* 1. Hardcoded

- Guck auf Terminal
- Guck auf Firebase dabei
- Click Read = null
- Click Create -> Read = John Peter
- Click Update -> Read = Alan Peter
- Click Delete -> Read = null


2. Ohne Hardcoded Key

Code: 
- Add 'CreateNew'
- Add 'ReadAll'
Terminal:
- Guck auf Firebase dabei
1 Click Read
2 Click CreateNew 1x -> ReadAll -> 1 Eintrag Mehr
3 Click CreateNew 4x -> ReadAll -> 4 Einträge Mehr
4 Lösche Einträge in Firebase -> Read = Einträge weg, nicecreme.

.. löschen modifiyieren etc

*/

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  final FirebaseFirestore firestore = FirebaseFirestore.instance;


  void _create() async {
    try {
      await firestore.collection('users').doc('testUser').set({
        'firstName': 'John',
        'lastName': 'Peter',
      });
    } catch (e) {
      print(e);
    }
  }

  void _createNew() async {
    try {
      await firestore.collection('users').doc().set({
        'firstName': 'John',
        'lastName': 'Peter',
      });
    } catch (e) {
      print(e);
    }
  }

  void _read() async {
    DocumentSnapshot documentSnapshot;
    try {
      documentSnapshot = await firestore.collection('users').doc('testUser').get();
      print(documentSnapshot.data().toString());
    } catch (e) {
      print(e);
    }
  }

  void _readAll() async {
    QuerySnapshot querySnapshot;
    try {
      print('-------------- Start of _readAll ----------------');
      querySnapshot = await firestore.collection('users').get();
      querySnapshot.docs.forEach((doc) {
        print(doc.data().toString());
      });
      print('-------------- End of _readAll ----------------');
    } catch (e) {
      print(e);
    }
  }

  void _update() async {
    try {
      firestore.collection('users').doc('testUser').update({
        'firstName': 'Alan',
      });
    } catch (e) {
      print(e);
    }
  }

  void _delete() async {
    try {
      firestore.collection('users').doc('testUser').delete();
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Flutter CRUD with Firebase"),
      ),
      body: Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
          ElevatedButton(
            child: const Text("Create"),
            onPressed: _create,
          ),
          ElevatedButton(
            child: const Text("Read"),
            onPressed: _read,
          ),
          ElevatedButton(
            child: const Text("Update"),
            onPressed: _update,
          ),
          ElevatedButton(
            child: const Text("Delete"),
            onPressed: _delete,
          ),


          ElevatedButton(
            child: const Text("CreateNew"),
            onPressed: _createNew,
          ),
          ElevatedButton(
            child: const Text("ReadAll"),
            onPressed: _readAll,
          ),

          // UserInformation()
        ]),
      ),
    );
  }
}

// -----------------------------------------------------------------------------