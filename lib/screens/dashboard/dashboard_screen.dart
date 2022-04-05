import 'package:yupcity_admin/models/CardInfo.dart';
import 'package:yupcity_admin/models/user.dart';
import 'package:yupcity_admin/models/yupcity_register.dart';
import 'package:yupcity_admin/models/yupcity_trap_poi.dart';
import 'package:yupcity_admin/screens/dashboard/components/my_fields.dart';
import 'package:flutter/material.dart';

import '../../constants.dart';
import 'components/header.dart';


class DashboardScreen extends StatelessWidget {

  final List<YupcityUser> allUser;
  final List<YupcityTrapPoi> allTraps;
  final List<YupcityRegister> allRegistries;

  DashboardScreen(this.allUser, this.allTraps, this.allRegistries);
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: EdgeInsets.all(defaultPadding),
        child: Column(
          children: [
           Header(route: "dashboard", itemList: allUser,),
            SizedBox(height: defaultPadding),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 5,
                  child: Column(
                    children: [
                      MyFiles(_createCards(allUser,allTraps,allRegistries)),
                      SizedBox(height: defaultPadding),
                      //RecentFiles(),
                      /*  if (Responsive.isMobile(context))
                        SizedBox(height: defaultPadding),
                      if (Responsive.isMobile(context)) StarageDetails(),*/
                    ],
                  ),
                ),
                /*if (!Responsive.isMobile(context))
                  SizedBox(width: defaultPadding),
                // On Mobile means if the screen is less than 850 we dont want to show it
                if (!Responsive.isMobile(context))
                  Expanded(
                    flex: 2,
                    child: StarageDetails(),
                  ),*/
              ],
            )
          ],
        ),
      ),
    );
  }

  List<CardInfo> _createCards( List<YupcityUser> allUsers, List<YupcityTrapPoi> allTraps, List<YupcityRegister> allRegistries,){
    List<CardInfo> cardsList = [];

    cardsList.add(
      CardInfo(
      title: "Usuarios",
      total: allUser.length,
      svgSrc: "assets/icons/menu_profile.svg",
      route: "users",
      color: Color(0xFFFFA113),
      percentage: 100,
      )
    );
    //TODO registries
    cardsList.add(
        CardInfo(
          title: "Usos",
          total: allRegistries.length,
          svgSrc: "assets/icons/key.svg",
          route: "users",
          color: Color(0xFFFFA113),
          percentage: 100,
        )
    );
    cardsList.add(
        CardInfo(
          title: "Traps",
          total: allTraps.length,
          svgSrc: "assets/icons/scooter.svg",
          route: "devices",
          color: primaryColor,
          percentage: 100,
        )
    );
    cardsList.add(
        CardInfo(
          title: "Traps ocupados",
          total: 0,
          svgSrc: "assets/icons/lock.svg",
          route: "devices",
          color: primaryColor,
          percentage: 100,
        )
    );

    return cardsList;

  }
}
