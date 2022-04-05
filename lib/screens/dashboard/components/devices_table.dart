import 'package:yupcity_admin/models/Device.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:yupcity_admin/models/user.dart';
import 'package:yupcity_admin/models/yupcity_trap_poi.dart';

import '../../../constants.dart';

class DevicesTable extends StatelessWidget {


  final List<YupcityUser> allUser;
  final List<YupcityTrapPoi> allTraps;

  DevicesTable(this.allUser, this.allTraps);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(defaultPadding),
      decoration: BoxDecoration(
        color: secondaryColor,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Traps",
            style: Theme.of(context).textTheme.subtitle1,
          ),
          SizedBox(
            width: double.infinity,
            child: DataTable2(
              columnSpacing: defaultPadding,
              minWidth: 1600,
              columns: [
                DataColumn(
                  label: Text("Nombre / Lugar"),
                ),
                DataColumn(
                  label: Text("Nº de usos"),
                ),
                DataColumn(
                  label: Text("Descripción"),
                ),

              ],
              rows: List.generate(
                allTraps.length,
                (index) => devicesDataRow(allTraps[index]),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

DataRow devicesDataRow(YupcityTrapPoi trap) {
  return DataRow(
    cells: [
      DataCell(
        Row(
          children: [
           /* SvgPicture.asset(
              fileInfo.icon!,
              height: 15,
              width: 15,
            ),*/
            Icon(Icons.lock_outline, color: Colors.lightBlue,),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
              child: Text(trap.center!),
            ),
          ],
        ),
      ),
      DataCell(Text(trap.lat.toString()!)),
      DataCell(Text(trap.centerDescription!)),

    ],
  );
}
