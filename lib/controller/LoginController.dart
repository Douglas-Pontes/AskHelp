import 'package:askhelpapp/pages/Chamados.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginController extends GetxController {
  Dio _api = Dio();
  RxString email = ''.obs;
  RxString password = ''.obs;

  setEmail(str) => email.value = str;
  setPassword(str) => password.value = str;

  Future login() async {
    if(email.value == '') {
      Get.snackbar('Atenção!', 'Por favor preencha com um email!', backgroundColor: Color(0xffffffff), snackPosition: SnackPosition.TOP);
      return;
    } else if(password.value == '') {
      Get.snackbar('Atenção!', 'Por favor preencha com uma senha!', backgroundColor: Color(0xffffffff), snackPosition: SnackPosition.TOP);
      return;
    } else if(email.value.indexOf('@') == -1) {
      Get.snackbar('Atenção!', 'Por favor preencha com um email válido', backgroundColor: Color(0xffffffff), snackPosition: SnackPosition.TOP);
      return;
    }

    Response response = await _api.post('http://localhost:3333/sessions', data: {
      "email": email.value.trim(),
      "password": password.value.trim()
    }).catchError((error) => 
      print(error)
    );

    if(response?.statusCode == 200) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setInt('id', response.data['id']);
      await prefs.setString('email', response.data['email']);
      await prefs.setString('password', response.data['password']);
      await prefs.setString('token', response.data['token']);
      await prefs.setString('type', response.data['type']);
      Get.offAll(Chamados());
    } else {
      Get.snackbar('Atenção!', 'Email ou senha incorretos!', snackPosition: SnackPosition.TOP, backgroundColor: Colors.white);
    }
  }
}