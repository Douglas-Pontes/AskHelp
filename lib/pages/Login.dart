import 'package:askhelpapp/controller/LoginController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

class Login extends GetWidget<LoginController> {
  final LoginController controller = Get.put(LoginController());
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: Get.width,
        height: Get.height,
        color: Color(0xff1c2b36),
        alignment: Alignment.center,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('ASKHELP', style: TextStyle(fontSize: 56, fontWeight: FontWeight.w700, color: Colors.white)),
            _input(1),
            SizedBox(height: 10),
            _input(2),
            SizedBox(height: 15),
            GestureDetector(
              onTap: () => controller.login(),
              child: Container(
                height: 40,
                width: Get.width-40,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white, width: 1),
                  borderRadius: BorderRadius.circular(7),
                  color: Color(0xff2e8a5b)
                ),
                child: Align(
                  alignment: Alignment.center,
                  child: Text('ENTRAR', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 14))
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _input(int type){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          alignment: Alignment.centerLeft,
          margin: const EdgeInsets.only(left: 20),
          child: Text(type == 1 ? 'Email' : 'Senha', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700))
        ),
        Container(
          width: Get.width - 40,
          height: 40,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(5)
          ),
          margin: const EdgeInsets.only(left: 20),
          child: TextField(
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.only(left: 5, bottom: 5),
              hintStyle: TextStyle(
                fontSize: 12,
                color: Colors.grey
              ),
              hintText: type == 1 ? 'Digite seu e-mail' : 'Digite sua senha'
            ),
            keyboardType: type == 1 ? TextInputType.emailAddress : TextInputType.visiblePassword,
            obscureText: type == 2 ? true : false,
            onChanged: (val) {
              if(type == 1) controller.setEmail(val);
              else if(type == 2) controller.setPassword(val);
            },
          ),
        ),
      ],
    );
  }
}