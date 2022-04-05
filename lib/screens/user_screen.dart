
import '../../constants.dart';

import 'package:yupcity_admin/models/user.dart';
import 'package:yupcity_admin/models/yupcity_trap_poi.dart';
import 'package:yupcity_admin/screens/dashboard/components/header.dart';
import 'package:flutter/material.dart';
import 'dashboard/components/user_table.dart';

class UserScreen extends StatelessWidget {
  final List<YupcityUser> allUser;
  final List<YupcityTrapPoi> allTraps;

  UserScreen(this.allUser, this.allTraps);


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: EdgeInsets.all(defaultPadding),
        child: Column(
          children: [
            Header(route: "users", itemList: allUser),
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
                      UserTable(allUser),
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
