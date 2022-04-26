import 'package:flutter/material.dart';
import 'package:yupcity_admin/models/yupcity_register.dart';
import 'package:yupcity_admin/models/yupcity_trap_poi.dart';
import 'package:yupcity_admin/responsive.dart';
import 'package:yupcity_admin/screens/dashboard/components/trap_line_chart.dart';
import 'package:yupcity_admin/screens/pdf_report_page.dart';

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
                    child:  Text("Disponible",),
                  ),
                  ElevatedButton.icon(
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.symmetric(
                        horizontal: defaultPadding ,
                        vertical:
                        defaultPadding / (Responsive.isMobile(context) ? 2 : 1),
                      ),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => PDFReportPage(widget.allRegistries, widget.currentTrap)),
                      );
                    },
                    icon: Icon(Icons.add),
                    label: Text("Create report"),
                  ),

            ]),

            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text("Creado el: 12-12-23", style: TextStyle(
                        fontSize: 10,
                      ),),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(defaultPadding),
                  decoration: BoxDecoration(
                    color: secondaryColor,
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                  ),
                  child: Text("Descripcion opcional del trap segun se haya colocado el admin al crearlo ", style: TextStyle(
                    fontSize: 12,)),
                ),
              ],
            ),
            LineChartSample2(
            ),
            Expanded(
              child: ListView.separated(
                shrinkWrap: true,
                separatorBuilder: (context, index){ return Divider(color: Colors.blueGrey,height: 8, thickness: 1,);},
                itemCount: 10,
                itemBuilder: (context, index){
                  var color = orange;
                  var textTitle = "Closed";
                  bool isOpened = false;

                  if(index % 2 == 0 ){
                    color = Color.fromRGBO(0,160,130,1);
                    textTitle = "Opened";
                    isOpened = true;
                  }
                  return

                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Container(
                        height: 70,
                        color: secondaryColor,
                        child: Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: Row(
                            children: <Widget>[
                              Container(
                                color: color,
                                width: 70,
                                height: 70,
                                child: createLeading(isOpened),
                              ),
                              SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment:
                                  CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(textTitle),
                                    Text('User id: 32589y394t4',
                                        style: TextStyle(color: Colors.grey))
                                  ],
                                ),
                              ),
                              Text('12-12-12',
                                  style: TextStyle(color: Colors.grey))
                            ],
                          ),
                        ),
                      ),
                    );

                  /*  ListTile(
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
                  );*/
                },

              ),
            )
          ],
        ),
      ),
    );
  }

  Widget createLeading(bool isOpened){
    if(isOpened ){
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
        Text("123 min", style: TextStyle(fontSize: 12),),
        Text("de uso", style: TextStyle(fontSize: 12),)
      ],);
    }else{
      return Icon(Icons.lock_outline, color: Colors.white);
    }
  }


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
