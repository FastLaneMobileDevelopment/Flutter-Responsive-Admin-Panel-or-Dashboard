import 'package:event_bus/event_bus.dart';
import 'package:get_it/get_it.dart';
import 'package:yupcity_admin/controllers/CurrentMenuController.dart';
import 'package:yupcity_admin/models/events/LanguageEvent.dart';
import 'package:yupcity_admin/models/events/RefreshEvent.dart';
import 'package:yupcity_admin/models/events/TrapSearchEvent.dart';
import 'package:yupcity_admin/models/events/UserSearchEvent.dart';
import 'package:yupcity_admin/models/user.dart';
import 'package:yupcity_admin/models/yupcity_trap_poi.dart';
import 'package:yupcity_admin/responsive.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import '../../../constants.dart';

class Header extends StatelessWidget {
  const Header({
    Key? key,
    required this.route,
    required this.itemList,
  }) : super(key: key);

  final String route;
  final List itemList;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [

        if (!Responsive.isDesktop(context))
          IconButton(
            icon: Icon(Icons.menu),
            onPressed: GetIt.I.get<CurrentMenuController>().controlMenu,
          ),
        if (!Responsive.isMobile(context))
          Text(
            route,
            style: Theme.of(context).textTheme.headline6,
          ),
        if (!Responsive.isMobile(context))
          Spacer(flex: Responsive.isDesktop(context) ? 2 : 1),
        if(route == "users")
        Expanded(child:
         SearchField(route: route,items: itemList,)),
        if (route == "devices")
          Expanded(child:
          SearchField(route: route,items: itemList,)),
        if(route == "dashboard")
            Expanded(child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(onPressed: () {
                  GetIt.I.get<EventBus>().fire(RefreshEvent());
                }, icon: Icon(Icons.refresh)),
                LanguageCard(),
              ],
            )),
         
      ],
    );
  }
}

class LanguageCard extends StatefulWidget {
  const LanguageCard({
    Key? key,
  }) : super(key: key);

  @override
  State<LanguageCard> createState() => _LanguageCardState();
}

class _LanguageCardState extends State<LanguageCard> {

  List<String> items = ["ESPAÑOL", "ENGLISH"];

  @override
  Widget build(BuildContext context) {


    return Container(
      margin: EdgeInsets.only(left: defaultPadding),
      padding: EdgeInsets.symmetric(
        horizontal: defaultPadding,
        vertical: defaultPadding / 2,
      ),
      decoration: BoxDecoration(
        color: secondaryColor,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        border: Border.all(color: Colors.white10),
      ),
      child:
      DropdownButton<String>(alignment: AlignmentDirectional.center,
        isDense: true,
        hint: Icon(Icons.language),
        onChanged: (String? newValue) =>
            {
              if(newValue == "ESPAÑOL"){
               GetIt.I.get<EventBus>().fire(LanguageEvent(currentLanguage: "es"))
              }else {
                GetIt.I.get<EventBus>().fire(LanguageEvent(currentLanguage: "en"))
              }

            },
        items: items
            .map<DropdownMenuItem<String>>(
                (String value) => DropdownMenuItem<String>(
              value: value,
              child: Text(value, style: TextStyle(fontSize: 12),),
            ))
            .toList(),
        icon: Icon(Icons.arrow_drop_down),
        underline: Container(),
      ),
      /*Row(
        children: [
          Icon(Icons.language),
          if (!Responsive.isMobile(context))
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: defaultPadding / 2),
              child: Text(I18n.of(context).language),
            ),
          Icon(Icons.keyboard_arrow_down),
        ],
      ),*/
    );
  }
}

class SearchField extends StatelessWidget {
   SearchField({
    Key? key,

    required this.route,
    required this.items
  }) : super(key: key);

  final route;
  List items;

  @override
  Widget build(BuildContext context) {

    return TextField(
      onChanged:(value) => _search(route, items, value),
      decoration: InputDecoration(
        hintText: "Search",
        fillColor: secondaryColor,
        filled: true,
        border: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: const BorderRadius.all(Radius.circular(10)),
        ),
        suffixIcon: InkWell(
          onTap: () {
            debugPrint("search");
          },
          child: Container(
            padding: EdgeInsets.all(defaultPadding * 0.75),
            margin: EdgeInsets.symmetric(horizontal: defaultPadding / 2),
            decoration: BoxDecoration(
              color: primaryColor,
              borderRadius: const BorderRadius.all(Radius.circular(10)),
            ),
            child: SvgPicture.asset("assets/icons/Search.svg"),
          ),
        ),
      ),
    );
  }
   _search(String route, List items, String value) {
     var eventBus = GetIt.I.get<EventBus>();
     List<YupcityUser> searchUsers = [];

     List<YupcityTrapPoi> searchTraps = [];


     //Search User
     if (route == "users") {
       for (var user in items) {
         if(user.email != null){
           if (user.email.startsWith(value)) {
             searchUsers.add(user);
           }
         }
       }

       eventBus.fire(UserSearchEvent(users: searchUsers));
     }

     if (route == "devices") {
       for (var trap in items) {
         if  (trap is YupcityTrapPoi) {
           var centerText = (trap.center ?? "").toLowerCase();
           var centerDescriptionText = (trap.centerDescription ?? "").toLowerCase();
           if (centerText.indexOf(value) > -1 || centerDescriptionText.indexOf(value) > -1) {
             searchTraps.add(trap);
           }
         }
       }

       eventBus.fire(TrapSearchEvent(traps: searchTraps));
     }
   }
}
