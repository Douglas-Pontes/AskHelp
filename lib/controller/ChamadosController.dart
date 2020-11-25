import 'package:askhelpapp/config/CoreBase.dart';
import 'package:askhelpapp/model/Chamado.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:smart_select/smart_select.dart';

class ChamadosController extends GetxController {
  CoreBase _api = CoreBase();

  var cusIcon = Icon(Icons.search, color: Colors.white).obs;
  setCusIcon(Icon _icon){
    cusIcon.value = _icon;
  }

  RxString filtro = ''.obs;
  setFiltro(String _str) {
    filtro.value = _str;
  }

  RxInt status = 6.obs;
  setStatus(int _str) {
    status.value = _str;
  }

  RxInt prioridade = 6.obs;
  setPrioridade2(int _str) {
    prioridade.value = _str;
  }

  RxInt ordem = 0.obs;
  setOrdem(o){
    ordem.value = o;
  }

  RxList<Chamado> chamados = List<Chamado>().obs;
  RxList<PopupMenuItem<int>> listprioridades = List<PopupMenuItem<int>>().obs;
  RxList<PopupMenuItem<int>> liststatus = List<PopupMenuItem<int>>().obs;
  RxList<PopupMenuItem<int>> listordem = List<PopupMenuItem<int>>().obs;

  RxList<SmartSelectOption<String>> liststatus2 = List<SmartSelectOption<String>>().obs;
  RxList<SmartSelectOption<String>> listclassificacoes = List<SmartSelectOption<String>>().obs;
  
  Future getChamados() async {
    chamados.clear();
    Response response = await _api.postMethod('chamadosbyparams', {
      "status_id": status.value,
      "prioridade_id": prioridade.value,
      "id": filtro.value,
      "ordem": ordem.value
    }, null);

    if(response.statusCode == 200) {
      response.data.forEach((item) {
        chamados.add(Chamado.fromJson(item));
      });
      update(['lista']);
    }
  }

  Future getClassificacoes() async {
    listclassificacoes.clear();
    Response response = await _api.getMethod('classificacao', null);
    if(response?.statusCode == 200) {
      response.data.forEach((item) {
        listclassificacoes.add(SmartSelectOption<String>(value: item['id'].toString(), title: item['Descricao']));
      });
    }
  }

  Future getStatus() async {
    liststatus.clear();
    Response response = await _api.getMethod('status', null);
    if(response?.statusCode == 200) {
      liststatus.add(const PopupMenuItem<int>(
        value: 6,
        child: Text('Todos'),
      ));
      response.data.forEach((item) {
        liststatus.add(
          PopupMenuItem<int>(
            value: item['id'],
            child: Text(item['Descricao']),
          )
        );
        liststatus2.add(SmartSelectOption<String>(value: item['id'].toString(), title: item['Descricao']));
      });
      update(['listastatus']);
    }
  }

  Future getPrioridade() async {
    listprioridades.clear();
    Response response = await _api.getMethod('prioridade', null);
    if(response?.statusCode == 200) {
      listprioridades.add(const PopupMenuItem<int>(
        value: 6,
        child: Text('Todos'),
      ));

      response.data.forEach((item) {
        listprioridades.add(
          PopupMenuItem<int>(
            value: item['id'],
            child: Text(item['Descricao']),
          )
        );
      });
      update(['listaprioridades']);
    }
  }

  void inserirOrdem(){
    listordem.value = [];
    listordem.add(PopupMenuItem<int>(
      value: 0,
      child: Text('Mais antigo'),
    ));
    listordem.add(PopupMenuItem<int>(
      value: 1,
      child: Text('Mais recente'),
    ));
  }

  Future trocarStatus(Chamado c) {
    Get.bottomSheet(
      Container(
        height: 100,
        color: Colors.white,
        child: SmartSelect<String>.single(
          placeholder: 'Selecione o status',
          title: 'Selecionar Status',
          value: c.statusId.toString(),
          options: liststatus2,
          selected: true,
          isTwoLine: false,
          onChange: (val) async {
            if(val == c.statusId.toString()) return;
            c.statusId = int.parse(val);

            Response response = await _api.putMethod('chamados', c.toJson(), null);

            if(response.statusCode == 200) {
              getChamados();
              Get.back();
              Get.snackbar('Sucesso!', 'Chamado alterado com sucesso!', snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.white);
            }
          },
          modalType:
              SmartSelectModalType.bottomSheet,
        ),
      )
    );
  }

  Future darFeedback(Chamado c) {
    Get.bottomSheet(
      Container(
        height: 100,
        color: Colors.white,
        child: SmartSelect<String>.single(
          placeholder: 'Selecione o feedback',
          title: 'Selecionar Feedback',
          value: c.classificacaoId.toString(),
          options: listclassificacoes,
          selected: true,
          isTwoLine: false,
          onChange: (val) async {
            if(val == c.classificacaoId.toString()) return;
            c.classificacaoId = int.parse(val);

            Response response = await _api.putMethod('chamados', c.toJson(), null);

            if(response.statusCode == 200) {
              getChamados();
              Get.back();
              Get.snackbar('Sucesso!', 'Feedback enviado com sucesso!!', snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.white);
            }
          },
          modalType:
              SmartSelectModalType.bottomSheet,
        ),
      )
    );
  }

  void init() {
    getStatus();
    getPrioridade();
    getClassificacoes();
    inserirOrdem();
    getChamados();
  }

  @override
  void onInit() {
    ever(prioridade, (i) => getChamados());
    ever(status, (i) => getChamados());
    ever(filtro, (i) => getChamados());
    ever(ordem, (i) => getChamados());
  }
}