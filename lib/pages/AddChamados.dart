import 'package:askhelpapp/controller/AddChamadosController.dart';
import 'package:askhelpapp/controller/ChamadosController.dart';
import 'package:askhelpapp/model/Chamado.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:smart_select/smart_select.dart';

class AddChamados extends StatelessWidget {
  ChamadosController chamadosController;
  AddChamados(this.chamadosController);

  final AddChamadosController controller = Get.put(AddChamadosController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff2e8a5b),
        title: Text('Adicionar')
      ),
      backgroundColor: Color(0xff1c2b36),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Assunto', style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w700)),
              SizedBox(height: 5),
              Container(
                height: 70,
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(5)
                ),
                child: TextField(
                  maxLength: 50,
                  onChanged: (t) {
                    controller.setAssunto(t);
                  },
                )
              ),
              SizedBox(height: 15),
              Text('Descrição', style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w700)),
              SizedBox(height: 5),
              Container(
                height: 140,
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(5)
                ),
                child: TextField(
                  maxLength: 200,
                  minLines: 7,
                  maxLines: 8,
                  onChanged: (t) {
                    controller.setDescricao(t);
                  },
                )
              ),
              SizedBox(height: 15),
              Text('Tipo Chamado', style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w700)),
              SizedBox(height: 5),
              Container(
                height: 55,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(5)
                ),
                child: GetBuilder(
                    id: 'listatiposchamado',
                    init: controller,
                    builder: (_) => SmartSelect<String>.single(
                    placeholder: 'Selecionar',
                    title: 'Tipo Chamado',
                    value: controller.tipo_chamado_id.toString(),
                    options: controller.tiposchamado,
                    selected: true,
                    isTwoLine: false,
                    onChange: (val) async {
                      controller.setTipoChamado(int.parse(val));
                      FocusManager.instance.primaryFocus.unfocus();
                    },
                    modalType:
                        SmartSelectModalType.bottomSheet,
                  )
                )
              ),
              SizedBox(height: 15),
              Text('Prioridade', style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w700)),
              SizedBox(height: 5),
              Container(
                height: 55,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(5)
                ),
                child: GetBuilder(
                  id: 'listaprioridade',
                  init: controller,
                  builder: (_) => SmartSelect<String>.single(
                    placeholder: 'Selecionar',
                    title: 'Prioridade',
                    value: controller.prioridade_id.toString(),
                    options: controller.prioridades,
                    selected: true,
                    isTwoLine: false,
                    onChange: (val) async {
                      controller.setPrioridade(int.parse(val));
                      FocusManager.instance.primaryFocus.unfocus();
                    },
                    modalType:
                        SmartSelectModalType.bottomSheet,
                    )
                  )
                ),
                SizedBox(height: 15),
                Text('Tags', style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w700)),
                SizedBox(height: 5),
                Container(
                  height: 55,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(5)
                  ),
                  child: GetBuilder(
                    id: 'listatags',
                    init: controller,
                    builder: (_) => SmartSelect<String>.multiple(
                      placeholder: 'Selecionar',
                      title: 'Tags',
                      value: controller.tagsselecionada.value,
                      options: controller.tags,
                      selected: true,
                      isTwoLine: false,
                      onChange: (val) async {
                        controller.setTagsSelecionada(val);
                        FocusManager.instance.primaryFocus.unfocus();
                      },
                      modalType:
                          SmartSelectModalType.fullPage,
                      )
                    )
                ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(0xff2e8a5b),
        onPressed: () {
          controller.addChamado(chamadosController);
        },
        child: Icon(Icons.check),
      ),
    );
  }
}