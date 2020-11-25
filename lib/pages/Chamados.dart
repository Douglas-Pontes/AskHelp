import 'package:askhelpapp/controller/ChamadosController.dart';
import 'package:askhelpapp/model/Chamado.dart';
import 'package:askhelpapp/pages/AddChamados.dart';
import 'package:askhelpapp/pages/Login.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Chamados extends StatelessWidget {
  final ChamadosController controller = Get.put(ChamadosController());
  

  @override
  Widget build(BuildContext context) {
    controller.init();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff2e8a5b),
        leading: IconButton(
          onPressed: () async {
            SharedPreferences prefs = await SharedPreferences.getInstance();
            prefs.clear();
            Get.offAll(Login());
          },
          icon: Icon(Icons.close, color: Colors.white),
        ),
        title: Obx(() => controller.cusIcon.value.icon == Icons.cancel ? TextField(
          autofocus: true,
          cursorColor: Colors.white,
          decoration: InputDecoration(
            hintText: 'Pesquise por protocolo',
            hintStyle: TextStyle(color: Colors.grey[400]),
            enabledBorder: UnderlineInputBorder(borderSide: BorderSide.none)
          ),
          onSubmitted: (val) {
            controller.setFiltro(val);
          },
          textInputAction: TextInputAction.go,
          style: TextStyle(
            color: Colors.white,
            fontSize: 16.0
          ),
        ) : Text('Chamados', style: TextStyle(fontSize: 14))),
        actions: [
          Obx(() => controller.cusIcon.value.icon == Icons.search ? 
          Row(
            children: [
              Text('Sta.', style: TextStyle(fontSize: 14)),
              _ddStatus(),
            ]
          )
          : SizedBox()),
          Obx(() => controller.cusIcon.value.icon == Icons.search ? 
          Row(
            children: [
              Text('Pri.', style: TextStyle(fontSize: 14)),
              _ddPrioridade(),
            ]
          )
          : SizedBox()),
          Obx(() => IconButton(
            onPressed: (){
              if(controller.cusIcon.value.icon == Icons.search)
                controller.setCusIcon(Icon(Icons.cancel, color: Colors.white));
              else {
                controller.setCusIcon(Icon(Icons.search, color: Colors.white));
                controller.setFiltro(null);
              }
            },
            icon: controller.cusIcon.value
          )),
        ],
      ),
      body: Container(
        width: Get.width,
        height: Get.height,
        color: Color(0xff1c2b36),
        child: GetBuilder(
          id: 'lista',
          init: controller,
          builder: (_) => ListView.builder(
          itemCount: controller.chamados.length,
          itemBuilder: (BuildContext context, int index) {
            Chamado chamado = controller.chamados[index];

            return Column(
              children: [
                index == 0 
                ?
                  Container(
                    alignment: Alignment.centerRight,
                    margin: const EdgeInsets.only(right: 20, top: 10, bottom: 5),
                    height: 20,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text('Ordenar', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 12)),
                        _ddOrdem()
                      ],
                    )
                  )
                : SizedBox(),
                GestureDetector(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                    margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10)
                    ),
                    child: Stack(
                      children: [
                        Align(
                          alignment: Alignment.centerRight,
                          child: Icon(
                            Icons.warning,
                            size: 16,
                            color: chamado.prioridadeId == 1 ? Colors.grey : chamado.prioridadeId == 2 ? Colors.orange : chamado.prioridadeId == 3 ? Colors.red : Colors.red
                          )
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('${chamado.id} - ${chamado.assunto}', style: TextStyle(color: Color(0xff2e8a5b), fontWeight: FontWeight.w700)),
                            Text(chamado.descricao, style: TextStyle(color: Colors.grey, fontStyle: FontStyle.italic)),
                            Text('${chamado.tipoChamado}', style: TextStyle(color: Colors.grey, fontStyle: FontStyle.italic)),
                            Text('${chamado.usuario} - ${chamado.dp}', style: TextStyle(fontWeight: FontWeight.w700)),
                            SizedBox(height: 4),
                            chamado.classificacao != null ? 
                            GestureDetector(
                              onTap: () {
                                if(chamado.type == '2' && chamado.statusId == 4) controller.darFeedback(chamado);
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.yellow,
                                  borderRadius: BorderRadius.circular(5)
                                ),
                                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                                child: Text('Feedback: ${chamado.classificacao}', style: TextStyle(color: Colors.black, fontSize: 12, fontWeight: FontWeight.w700))
                              ),
                            ) : SizedBox(),
                            SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(chamado.data == null ? 'Sem data' : chamado.data, style: TextStyle(color: Colors.grey, fontStyle: FontStyle.italic, fontSize: 12)),
                                GestureDetector(
                                  onTap: () {
                                    if(chamado.type != '2')
                                      controller.trocarStatus(chamado);
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: chamado.statusId == 1 ? Colors.grey : chamado.statusId == 2 ? Colors.orange : chamado.statusId == 3 ? Colors.black : chamado.statusId == 4 ? Color(0xff2e8a5b) : Colors.grey,
                                      borderRadius: BorderRadius.circular(10)
                                    ),
                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                                    child: Text('${chamado.status}', style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w700
                                    )),
                                  ),
                                )
                              ],
                            )
                          ],
                        ),
                      ]
                    ),
                  )
                ),
              ],
            );
          }
        ))
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Get.to(AddChamados(controller), transition: Transition.rightToLeftWithFade),
        backgroundColor: Color(0xff2e8a5b),
        child: Icon(Icons.add),
      ),
    );
  }

  Widget _ddPrioridade(){
    return GetBuilder(
    id: 'listaprioridades',
    init: controller,
    builder: (_) => PopupMenuButton<int>(
      icon: Icon(Icons.filter_list, size: 22),
      shape: RoundedRectangleBorder(),
      onSelected: (int result) {
        controller.setPrioridade2(result);
      },
      itemBuilder: (BuildContext context) => controller.listprioridades,
    ));
  }

  Widget _ddStatus(){
    return GetBuilder(
    id: 'listastatus',
    init: controller,
    builder: (_) => PopupMenuButton<int>(
      icon: Icon(Icons.filter_list, size: 22),
      shape: RoundedRectangleBorder(),
      onSelected: (int result) {
        controller.setStatus(result);
      },
      itemBuilder: (BuildContext context) => controller.liststatus,
    ));
  }

  Widget _ddOrdem(){
    return GetBuilder(
    id: 'listordem',
    init: controller,
    builder: (_) => PopupMenuButton<int>(
      padding: const EdgeInsets.only(bottom: 5),
      icon: Icon(Icons.filter_list, size: 22, color: Colors.white),
      shape: RoundedRectangleBorder(),
      onSelected: (int result) {
        controller.setOrdem(result);
      },
      itemBuilder: (BuildContext context) => controller.listordem,
    ));
  }
}