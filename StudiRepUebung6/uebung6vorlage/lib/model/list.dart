import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

/* --------------------------------- Updater -------------------------------- */
// connects to and communitcates with the Firebase

class ListUpdater {
  static final FirebaseFirestore firestore = FirebaseFirestore.instance;

  static Future<ShopItem> create(String title) async {
    DocumentReference item = await firestore
        .collection("shopItems")
        .add({"title": title, "check": false});
    return ShopItem(item.id, title);
  }

  static Future<List<ShopItem>> readAll() async {
    var querySnapshot = await firestore.collection("shopItems").get();
    var list = <ShopItem>[];
    querySnapshot.docs.forEach((element) => {
          list.add(ShopItem.checked(
              element.id, element.get("title"), element.get("check")))
        });

    return list;
  }

  static Future<ShopItem> check(String id, bool check) async {
    firestore.collection("shopItems").doc(id).update({"check": check});
    DocumentSnapshot documentSnapshot =
        await firestore.collection("shopItems").doc(id).get();
    ShopItem item =
        ShopItem(documentSnapshot.id, documentSnapshot.get("title"));
    item.check = check;
    return item;
  }

  static Future<bool> delete(String id) async {
    try {
      firestore.collection("shopItems").doc(id).delete();
    } catch (e) {
      return false;
    }
    return true;
  }
}

/* ---------------------------------- Item ---------------------------------- */

class ShopItem {
  String id;
  bool check = false;
  String title;

  //Konstruktor
  ShopItem(this.id, this.title);
  ShopItem.checked(this.id, this.title, this.check);
}

/* ---------------------------------- List ---------------------------------- */

class ShopList extends ChangeNotifier {
  // https://api.flutter.dev/flutter/dart-core/Map-class.html
  // empty map with key String and value ShopItem
  final Map<String, ShopItem> _items = {};
  List<ShopItem> get items => _items.values.toList();

  void create(String title) async {
    ShopItem item = await ListUpdater.create(title);
    _items.putIfAbsent(item.id, () => item);
    notifyListeners();
  }

  // adds all objects currently in the database to _items
  Future<void> init() async {
    var list = await ListUpdater.readAll();
    list.forEach((e) => _items[e.id] = e);
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
    var shopItem = await ListUpdater.check(id, !item.check);
    _items[id] = shopItem;
    notifyListeners();
  }
}
