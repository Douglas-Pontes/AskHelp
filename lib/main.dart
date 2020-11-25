import 'package:askhelpapp/pages/Chamados.dart';
import 'package:askhelpapp/pages/login.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  Future<bool> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if(prefs.getString('token') != '' && prefs.getString('token') != null) {
      return true;
    } else {
      return false;
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'AskHelp',
      home: FutureBuilder(
        future: getToken(), 
        builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
          if(snapshot.hasError) {
            return Login();
          } else if(snapshot.hasData && snapshot.data == true) {
            return Chamados();
          } else {
            return Login();
          }
        }
      ) 
    );
  }
}