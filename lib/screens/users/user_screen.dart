
import 'package:event_bus/event_bus.dart';
import 'package:get_it/get_it.dart';
import 'package:yupcity_admin/models/events/NavigationScreen.dart';
import 'package:yupcity_admin/models/yupcity_register.dart';

import '../../../constants.dart';

import 'package:yupcity_admin/models/user.dart';
import 'package:yupcity_admin/models/yupcity_trap_poi.dart';
import 'package:yupcity_admin/screens/dashboard/components/header.dart';
import 'package:flutter/material.dart';
import 'user_table.dart';

class UserScreen extends StatelessWidget {
  final List<YupcityUser> allUser;
  final List<YupcityTrapPoi> allTraps;
  final List<YupcityRegister> allRegistries;

  UserScreen(this.allUser, this.allTraps, this.allRegistries);


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: EdgeInsets.all(defaultPadding),
        child: Column(
          children: [
            Header(route: "users", itemList: allUser),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                IconButton(
                  icon: Icon(Icons.arrow_back),
                  onPressed: () {
                    String route = "dashboard";
                    GetIt.I.get<EventBus>().fire(NavigationScreen(routeName: route));
                  },

                ),
              ],
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 5,
                  child: Column(
                    children: [
                     // MyFiles(),

                      SizedBox(height: defaultPadding),
                      //todo: add line_chart
                      UserTable(allUser, allRegistries),
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
