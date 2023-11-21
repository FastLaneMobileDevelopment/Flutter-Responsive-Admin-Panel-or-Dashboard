import 'package:yupcity_admin/i18n.dart';
import 'package:yupcity_admin/models/events/NavigationScreen.dart';
import 'package:event_bus/event_bus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get_it/get_it.dart';
import 'package:yupcity_admin/responsive.dart';
import 'package:yupcity_admin/screens/login_page.dart';
import 'package:yupcity_admin/services/local_storage_service.dart';
import 'package:yupcity_admin/services/login_service.dart';

import '../../../constants.dart';

class SideMenu extends StatelessWidget {
  const SideMenu({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: bgColor,
      child: ListView(
        children: [
          DrawerHeader(
            child: Image.asset("assets/images/yupcharge_logo.png", color: Colors.white,),
          ),
          DrawerListTile(
            title: "Dashboard",
            svgSrc: "assets/icons/menu_dashbord.svg",
            press: () {
              String route = "dashboard";
              GetIt.I.get<EventBus>().fire(NavigationScreen(routeName: route));
              Navigator.pop(context);
            },
          ),
          DrawerListTile(
            title: I18n.of(context).users,
            svgSrc: "assets/icons/menu_profile.svg",
            press: () {
              String route = "users";
              GetIt.I.get<EventBus>().fire(NavigationScreen(routeName: route));
              Navigator.pop(context);
            },
          ),
          DrawerListTile(
            title: I18n.of(context).traps,
            svgSrc: "assets/icons/menu_tran.svg",
            press: () {
              String route = "devices";
              GetIt.I.get<EventBus>().fire(NavigationScreen(routeName: route));
              Navigator.pop(context);
            },
          ),
          /*Responsive.isMobile(context)  ?
          DrawerListTile(
            title: "Set Trap Location",
            svgSrc: "assets/icons/menu_tran.svg",
            press: () {
              String route = "pin_trap";
              GetIt.I.get<EventBus>().fire(NavigationScreen(routeName: route));
              Navigator.pop(context);
            },
          ) : Container(),*/
          DrawerListTile(
            title: I18n.of(context).log_out,
            svgSrc: "assets/icons/menu_store.svg",
            press: () {
              String route = "devices";
              LoginService.RemoveLogin();
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) =>  LoginScreenPage()),

              );

            },
          ),

        ],
      ),
    );
  }
}

class DrawerListTile extends StatelessWidget {
  const DrawerListTile({
    Key? key,
    // For selecting those three line once press "Command+D"
    required this.title,
    required this.svgSrc,
    required this.press,
  }) : super(key: key);

  final String title, svgSrc;
  final VoidCallback press;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: press,
      horizontalTitleGap: 0.0,
      leading: SvgPicture.asset(
        svgSrc,
        color: orange,
        height: 19,
      ),
      title: Text(
        title,
        style: TextStyle(color: Colors.white),
      ),
    );
  }
}
