import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert' as convert;

class CoreBase {
  String urlBase = 'http://localhost:3333/';
  Dio dio = Dio();

  //METODOO GET
  Future<dynamic> getMethod (url, headers) async {
    //OBTENHO AS PREFERENCIAS DO APP
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');
    var user_id = prefs.getInt('id');
    var email = prefs.getString('email');
    var password = prefs.getString('password');

    if(token == null) return;

    //REALIZO A REQUISIÇÃO QUE VEIO
    Response response = await dio.get('$urlBase$url', 
    options: Options(
        headers: { 
        'Authorization': "Bearer "+token,
        'user_id': user_id,
        }
      )
    ).catchError((e) {
      print(e.response.data);
    });

    //CASO RETORNE UM 401 QUER DIZER QUE O TOKEN ESPIROU OU USUARIO NÃO EXISTE MAIS
    if(response?.statusCode == 401) {
      //ENTÃO FAZ O LOGIN NOVAMENTE
      var r = await dio.post('http://localhost:3333/sessions', data: { 'email': email, 'password': password }).catchError((e) {
        print(e);
      });

      if (r?.statusCode == 200) {
        //CASO LOGIN TEVE SUCESSO SALVA O NOVO TOKEN
        await prefs.setString('token', r.data[0]['token']);

        //CHAMA A FUNÇÃO REDUNTANTEMENTE PARA EXECUTAR O COMANDO NOVAMENTE AGORA COM O TOKEN NOVO
        CoreBase coreBase = CoreBase();
        var response = await coreBase.getMethod(url, headers);
        return response;
      } else {
        return response;
      }
    } else {
      return response;
    }
  }
  
  Future postMethod(url, data, headers) async {
    //OBTENHO AS PREFERENCIAS DO APP
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');
    var user_id = prefs.getInt('id');
    var email = prefs.getString('email');
    var password = prefs.getString('password');

    if(token == null) return;
      Response response = await dio.post('$urlBase$url', data: data, options: Options(
        headers: {
          'Authorization': "Bearer "+token,
          'user_id': user_id,
        }
      )).catchError((e) {
        print(e);
      });

      //CASO RETORNE UM 401 QUER DIZER QUE O TOKEN ESPIROU OU USUARIO NÃO EXISTE MAIS
      if(response?.statusCode == 401) {
        var r = await dio.post('http://localhost:3333/sessions', data: { 'email': email, 'password': password }).catchError((e) {
          print(e);
        });

        if (r?.statusCode == 200) {
          //CASO LOGIN TEVE SUCESSO SALVA O NOVO TOKEN
        await prefs.setString('token', r.data[0]['token']);

          //CHAMA A FUNÇÃO REDUNTANTEMENTE PARA EXECUTAR O COMANDO NOVAMENTE AGORA COM O TOKEN NOVO
          CoreBase coreBase = CoreBase();
          Response response = await coreBase.postMethod(url, data, headers);
          return response;
        } else {
          return response;
        }
      } else {
        return response;
      }
  }

  Future putMethod(url, data, headers) async {
    //OBTENHO AS PREFERENCIAS DO APP
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');
    var user_id = prefs.getInt('id');
    var email = prefs.getString('email');
    var password = prefs.getString('password');

    if(token == null) return;
      Response response = await dio.put('$urlBase$url', data: data, options: Options(
        headers: {
          'Authorization': "Bearer "+token,
          'user_id': user_id,
        }
      )).catchError((e) {
        print(e);
      });

      //CASO RETORNE UM 401 QUER DIZER QUE O TOKEN ESPIROU OU USUARIO NÃO EXISTE MAIS
      if(response?.statusCode == 401) {
        var r = await dio.post('http://localhost:3333/sessions', data: { 'email': email, 'password': password }).catchError((e) {
          print(e);
        });

        if (r?.statusCode == 200) {
          //CASO LOGIN TEVE SUCESSO SALVA O NOVO TOKEN
        await prefs.setString('token', r.data[0]['token']);

          //CHAMA A FUNÇÃO REDUNTANTEMENTE PARA EXECUTAR O COMANDO NOVAMENTE AGORA COM O TOKEN NOVO
          CoreBase coreBase = CoreBase();
          Response response = await coreBase.postMethod(url, data, headers);
          return response;
        } else {
          return response;
        }
      } else {
        return response;
      }
  }
}