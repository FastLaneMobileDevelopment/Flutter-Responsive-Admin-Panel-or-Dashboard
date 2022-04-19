import 'package:yupcity_admin/i18n.dart';
import 'package:yupcity_admin/models/yupcity_register.dart';
import 'package:yupcity_admin/models/yupcity_trap_poi.dart';
import 'package:yupcity_admin/responsive.dart';
import 'package:yupcity_admin/screens/dashboard/add_new_trap.dart';
import 'package:yupcity_admin/screens/dashboard/components/devices_table.dart';
import 'package:flutter/material.dart';

import '../../constants.dart';
import 'package:yupcity_admin/screens/dashboard/components/header.dart';


class DevicesScreen extends StatelessWidget {
  final List<YupcityRegister> allRegistries;
  final List<YupcityTrapPoi> allTraps;

  DevicesScreen(this.allRegistries, this.allTraps);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: EdgeInsets.all(defaultPadding),
        child: Column(
          children: [
            Header(route: "devices", itemList: allTraps,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
               /* Text(
                  "Devices",
                  style: Theme.of(context).textTheme.subtitle1,
                ),*/
                SizedBox(
                  width: 15,
                ),
                ElevatedButton.icon(
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.symmetric(
                      horizontal: defaultPadding * 1.5,
                      vertical:
                      defaultPadding / (Responsive.isMobile(context) ? 2 : 1),
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const AddNewTrapScreen()),
                    );
                  },
                  icon: Icon(Icons.add),
                  label: Text(I18n.of(context).add_new),
                ),
              ],
            ),
            SizedBox(height: defaultPadding),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 5,
                  child: Column(
                    children: [
                     // MyFiles(),
                      SizedBox(height: defaultPadding),
                      DevicesTable(allRegistries,allTraps),
                    ],
                  ),
                ),

              ],
            )
          ],
        ),
      ),
    );
  }
}
