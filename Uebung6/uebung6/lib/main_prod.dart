import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uebung6/flavor.dart';
import 'package:uebung6/my_app.dart';

void main() {
  runApp(Provider<Flavor>.value(
    value: Flavor.prod,
    child: const MyApp(),
    ));
}
