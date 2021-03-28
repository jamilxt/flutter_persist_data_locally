import 'package:flutter/material.dart';
import 'package:flutter_persist_data_locally/data/moor_db.dart';
import 'package:flutter_persist_data_locally/screens/home.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Provider(
      create: (context) => BlogDb(),
      child: MaterialApp(
        title: 'GlobeApp',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: HomeScreen(),
      ),
    );
  }
}
