import 'package:flutter/material.dart';
import 'package:yupcity_admin/models/yupcity_register.dart';
import 'package:yupcity_admin/models/yupcity_trap_poi.dart';
import 'package:yupcity_admin/screens/dashboard/components/trap_line_chart.dart';

import '../../constants.dart';

class TrapDetails extends StatefulWidget {

  final List<YupcityRegister> allRegistries;
  final YupcityTrapPoi currentTrap;

  TrapDetails(this.allRegistries,this.currentTrap);
  @override
  State<TrapDetails> createState() => _TrapDetailsState();
}

class _TrapDetailsState extends State<TrapDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title:  Text("Centro La Maquinista"),
        backgroundColor: secondaryColor
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: EdgeInsets.all(defaultPadding),
                    decoration: BoxDecoration(
                      color: secondaryColor,
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                    ),
                    child:  Text("Estado: disponible",),
                  ),

              Text("Creado el: 12-12-23", style: TextStyle(
                fontSize: 10,
              ),),
            ]),
            SizedBox(height: 10,),

            Container(
              padding: EdgeInsets.all(defaultPadding),
              decoration: BoxDecoration(
                color: secondaryColor,
                borderRadius: const BorderRadius.all(Radius.circular(10)),
              ),
              child: Column(
                children: [

                  Text("Descripcion opcional del trap segun se haya colocado el admin al crearlo ", style: TextStyle(
                    fontSize: 12,)),
                ],
              ),
            ),
            LineChartSample2(
            ),
            Expanded(
              child: ListView.separated(
                shrinkWrap: true,
                separatorBuilder: (context, index){ return Divider(color: Colors.blueGrey,height: 8, thickness: 1,);},
                itemCount: 10,
                itemBuilder: (context, index){
                  return ListTile(
                    leading: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text("123 min", style: TextStyle(fontSize: 12),),
                        Text("de uso", style: TextStyle(fontSize: 10),),
                        SizedBox(height: 10,)
                      ],
                    ),
                    title: Text("Opened"),
                    subtitle: Text("User Id : 238947203947323", style: TextStyle(color: Colors.white, fontSize: 10),),
                    trailing: Text("12-12-23"),
                  );
                },

              ),
            )
          ],
        ),
      ),
    );
  }

  _TrapDetailsState();



  Widget createListLogsWidget(List<YupcityRegister> registries) {
    return ListView.builder(
        itemCount: registries.length,
        itemBuilder: (context, index) {
          return ListTile(
            leading: Text(registries[index].minFromToClose!),
            title: Text(registries[index].action!),
            subtitle: Text(registries[index].userId!),
            trailing: Text(registries[index].createdAt!),
          );

        }
    );
  }

}
