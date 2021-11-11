import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

/* --------------------------------- Updater -------------------------------- */

class ListUpdater {
  static final FirebaseFirestore firestore = FirebaseFirestore.instance;

  static Future<ShopItem> create(String title) async {
    var doc_ref = await firestore
        .collection('state')
        .add({'title': title, 'check': false});
    var doc_snap = await doc_ref.get();
    var key = doc_snap.id;
    var data = doc_snap.data();
    var item = ShopItem(key, data?['title'], data?['check']);
    return item;
  }

  static Future<List<ShopItem>> readAll() async {
    var col_snap = await firestore.collection('state').get();
    List<ShopItem> list = [];
    col_snap.docs.forEach((element) {
      var data = element.data();
      // var aaa = data["title"].toString();
      // var bbb = data["check"].toString() == 'true';
      list.add(ShopItem(element.id, data['title'], data['check']));
    });
    return list;
  }

  static Future<ShopItem> check(String id, bool check) async {
    var doc = firestore.collection('state').doc(id);
    await doc.update({'check': check});
    var doc_snap = await firestore.collection('state').doc(id).get();
    var data = doc_snap.data();
    var item = ShopItem(id, data?['title'], data?['check']);
    return item;
  }

  static Future<bool> delete(String id) async {
    var delete = await firestore.collection('state').doc(id).delete();
    var doc_snap = await firestore.collection('state').doc(id).get();
    return !doc_snap.exists;
  }
}

/* ---------------------------------- Item ---------------------------------- */

@immutable
class ShopItem {
  final String id;
  final String title;
  final bool check;

  ShopItem(this.id, this.title, this.check);

  @override
  String toString() {
    return "$id, $title, $check";
  }
}

/* ---------------------------------- List ---------------------------------- */

class ShopList extends ChangeNotifier {
  // https://api.flutter.dev/flutter/dart-core/Map-class.html
  //Leere Map _items mit Key String und Value ShopItem
  final Map<String, ShopItem> _items = {};
  List<ShopItem> get items => _items.values.toList();

  void create(String title) async {
    var item = await ListUpdater.create(title);
    _items[item.id] = item;
    notifyListeners();
  }

  Future<void> init() async {
    var list = await ListUpdater.readAll();
    _items.clear();
    list.forEach((element) {
      _items[element.id] = element;
      print(element);
    });
    notifyListeners();
  }

  void delete(String id) async {
    var list = await ListUpdater.delete(id);
    if (list) {
      _items.remove(id);
      notifyListeners();
    }
  }

  void check(String id) async {
    var item = _items[id]!;
    var list = await ListUpdater.check(id, !item.check);
    _items[id] = list;
    notifyListeners();
  }
}
