import 'package:askhelpapp/config/CoreBase.dart';
import 'package:askhelpapp/controller/ChamadosController.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_select/smart_select.dart';

class AddChamadosController extends GetxController {
  CoreBase _api = CoreBase();
  
  RxList<SmartSelectOption<String>> prioridades = List<SmartSelectOption<String>>().obs;
  RxList<SmartSelectOption<String>> tiposchamado = List<SmartSelectOption<String>>().obs;
  RxList<SmartSelectOption<String>> tags = List<SmartSelectOption<String>>().obs;

  RxInt prioridade_id = 0.obs;
  RxInt tipo_chamado_id = 0.obs;
  setPrioridade(int p) {
    prioridade_id.value = p;
    update(['listaprioridade']);
  }
  setTipoChamado(int t) {
    tipo_chamado_id.value = t;
    update(['listatiposchamado']);
  }

  RxList tagsselecionada = List<String>().obs;
  setTagsSelecionada(List<String> list){
    tagsselecionada.value = list;
    update(['listatags']);
  }

  RxString assunto = ''.obs;
  RxString descricao = ''.obs;
  setAssunto(String str) => assunto.value = str;
  setDescricao(String str) => descricao.value = str;

  Future getPrioridade() async {
    prioridades = List<SmartSelectOption<String>>().obs;
    Response response = await _api.getMethod('prioridade', null);
    if(response?.statusCode == 200) {
      response.data.forEach((item) {
        prioridades.add(SmartSelectOption<String>(value: item['id'].toString(), title: item['Descricao']));
      });
      update(['listaprioridade']);
    }
  }
  
  Future getTipoChamado() async {
    tiposchamado = List<SmartSelectOption<String>>().obs;
    Response response = await _api.getMethod('tipochamado', null);
    if(response?.statusCode == 200) {
      response.data.forEach((item) {
        tiposchamado.add(SmartSelectOption<String>(value: item['id'].toString(), title: item['Descricao']));
      });
      update(['listatiposchamado']);
    }
  }

  Future getTags() async {
    tiposchamado = List<SmartSelectOption<String>>().obs;
    Response response = await _api.getMethod('tags', null);
    if(response?.statusCode == 200) {
      response.data.forEach((item) {
        tags.add(SmartSelectOption<String>(value: item['id'].toString(), title: item['Descricao']));
      });
      update(['listatags']);
    }
  }
  
  Future addChamado(ChamadosController chamadosController) async {
    if(assunto.value == '') {
      Get.snackbar('Atenção!', 'Por favor preencha um assunto!', snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.red, colorText: Colors.white);
      return;
    } else if(descricao.value == '') {
      Get.snackbar('Atenção!', 'Por favor preencha uma descrição!', snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.red, colorText: Colors.white);
      return;
    } else if(tipo_chamado_id.value == 0) {
      Get.snackbar('Atenção!', 'Por favor selecione um tipo!', snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.red, colorText: Colors.white);
      return;
    } else if(prioridade_id.value == 0) {
      Get.snackbar('Atenção!', 'Por favor selecione uma prioridade!', snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.red, colorText: Colors.white);
      return;
    } else if(tagsselecionada.length == 0) {
      Get.snackbar('Atenção!', 'Por favor selecione pelo menos uma tag!', snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.red, colorText: Colors.white);
    }
    
    SharedPreferences prefs = await SharedPreferences.getInstance();

    Response response = await _api.postMethod('chamados', {
      "Assunto": assunto.value,
      "Descricao": descricao.value,
      "classificacao_id": 6,
      "tipo_chamado_id": tipo_chamado_id.value,
      "prioridade_id": prioridade_id.value,
      "status_id": 1,
      "pessoa_agente_id": 1018,
      "pessoa_usuario_id": prefs.getInt('id'),
      "arrtags": tagsselecionada.value
    }, null);

    if(response.statusCode == 200) {
      prioridade_id.value = 0;
      tipo_chamado_id.value = 0;
      setAssunto('');
      setDescricao('');
      tagsselecionada.clear();
      update(['listaprioridade', 'listatiposchamado', 'listatags']);
      chamadosController.getChamados();
      Get.back();
      Get.snackbar('Sucesso!', 'Chamado adicionado com sucesso!', snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.white);
    } else {
      Get.snackbar('Atenção!', 'Verifique sua conexão com a internet!', snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.white);
    }
  }

  @override
  void onInit() {
    getPrioridade();
    getTipoChamado();
    getTags();
  }
}