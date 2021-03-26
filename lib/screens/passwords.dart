import 'package:flutter/material.dart';
import '../data/shared_prefs.dart';
import './password_detail.dart';
import '../data/sembast_db.dart';
import '../models/password.dart';

class PasswordsScreen extends StatefulWidget {
  @override
  _PasswordsScreenState createState() => _PasswordsScreenState();
}

class _PasswordsScreenState extends State<PasswordsScreen> {
  int settingColor = 0xff1976d2;
  double fontSize = 16;
  SPSettings settings;

  @override
  void initState() {
    settings = SPSettings();
    settings.init().then((value) {
      setState(() {
        settingColor = settings.getColor();
        fontSize = settings.getFontSize();
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Passwords List'),
        backgroundColor: Color(settingColor),
      ),
      body: Container(),
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          backgroundColor: Color(settingColor),
          onPressed: () {
            showDialog(
                context: context,
                builder: (context) {
                  return PasswordDetailDialog(Password('', ''), true);
                });
          }),
    );
  }
}
