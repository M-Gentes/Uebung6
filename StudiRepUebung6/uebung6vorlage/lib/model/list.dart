import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

/* --------------------------------- Updater -------------------------------- */
// connects to and communitcates with the Firebase 

class ListUpdater {
  static final FirebaseFirestore firestore = FirebaseFirestore.instance;

  // TODO 0: to properly integrate the database into a project you will need to know how to use asynchronous Dart functions see https://dart.dev/codelabs/async-await for further informatio

  // TODO connect to the Firebase collection and create a new entry with the provided String as the title and false as the default value for whether or not the item is checked then create a new instance of ShopItem and return it
  // Firebase will provide an ID for the entry as part of the answer message
  static Future<ShopItem> create(String title) async {
  }

  // TODO retrieve all entries from your Firebase collection and return them in form of a list
  static Future<List<ShopItem>> readAll() async {
  }

  // TODO set the value of your checked variable in your collection to the one provided
  static Future<ShopItem> check(String id, bool check) async {
  }

  // TODO delete the entry for a given id
  static Future<bool> delete(String id) async {
  }
}

/* ---------------------------------- Item ---------------------------------- */

//TODO this class is used to store database entries for use within the app. you will need variables for the ID provided by Firestore, the title and whether the item is checked
@immutable
class ShopItem {
}

/* ---------------------------------- List ---------------------------------- */

class ShopList extends ChangeNotifier {
  // https://api.flutter.dev/flutter/dart-core/Map-class.html
  // empty map with key String and value ShopItem
  final Map<String, ShopItem> _items = {};
  List<ShopItem> get items => _items.values.toList();


  void create(String title) async {
    var item = await ListUpdater.create(title);
    //TODO add the created item to the _items map
    notifyListeners();
  }

  // adds all objects currently in the database to _items
  Future<void> init() async {
    var list = await ListUpdater.readAll();
    //TODO add all items to the _items map
    notifyListeners();
  }

  void delete(String id) async {
    var list = await ListUpdater.delete(id);
    if (list) {
      //TODO remove the item from the _items map
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