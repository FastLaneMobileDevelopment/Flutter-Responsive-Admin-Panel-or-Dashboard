import 'package:event_bus/event_bus.dart';
import 'package:get_it/get_it.dart';
import 'package:yupcity_admin/i18n.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:yupcity_admin/models/events/UserSearchEvent.dart';
import 'package:yupcity_admin/models/user.dart';
import 'package:yupcity_admin/models/yupcity_register.dart';

import '../../../constants.dart';

class UserTable extends StatefulWidget {
  final allUsers;

  final allRegistries;

  UserTable(this.allUsers, this.allRegistries);

  @override
  State<UserTable> createState() => _UserTableState();

}

class _UserTableState extends State<UserTable> {

  List<YupcityUser> userList = [];
  List<YupcityRegister> allRegistries = [];
  var eventBus = GetIt.I.get<EventBus>();

  @override
  void initState() {
    super.initState();
    userList = widget.allUsers;
    allRegistries = widget.allRegistries;
    userList = _getRegistriesForUsers(userList, allRegistries);
    eventBus.on<UserSearchEvent>().listen((event) {
      if (mounted) {
        setState(() {
        userList = event.users;
        });
      }
    });

  }

  List<YupcityUser> _getRegistriesForUsers(List<YupcityUser> userList,List<YupcityRegister> registerList){
    for(var registry in registerList){
      for(var user in userList){
        if(registry.userId == user.sId){
          user.numberOfUses++;
        }
      }
    }
    return userList;
  }

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
          I18n.of(context).users,
            style: Theme.of(context).textTheme.subtitle1,
          ),
          SizedBox(
            width: double.infinity,
            child: DataTable2(
              columnSpacing: defaultPadding,
              minWidth: 1000,
              columns: [
                DataColumn2(
                  size: ColumnSize.L,
                  label: Text("Email"),
                ),
                DataColumn2(
                  size: ColumnSize.S,
                  label: Text(I18n.of(context).uses_total),
                ),
                DataColumn2(
                  size: ColumnSize.M,
                  label: Text(I18n.of(context).name),
                ),
              ],
              rows: List.generate(
                  userList.length,
                (index) {
                    return recentFileDataRow(userList[index]);
                }
              ),
            ),
          ),
        ],
      ),
    );
  }
}




DataRow recentFileDataRow(YupcityUser user) {

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
            Icon(Icons.account_box_rounded, color: Colors.blue,),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
              child: Text(user.email ?? "", overflow: TextOverflow.ellipsis,),
            ),
          ],
        ),
      ),
      DataCell(Text(user.numberOfUses.toString() ?? "0", overflow: TextOverflow.ellipsis,)),
      DataCell(Text(user.username ?? "", overflow: TextOverflow.ellipsis,)),
    ],
  );
}
