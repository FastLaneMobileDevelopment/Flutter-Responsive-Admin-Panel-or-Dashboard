import 'package:event_bus/event_bus.dart';
import 'package:get_it/get_it.dart';
import 'package:yupcity_admin/models/RecentFile.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:yupcity_admin/models/events/UserSearchEvent.dart';
import 'package:yupcity_admin/models/user.dart';

import '../../../constants.dart';

class UserTable extends StatefulWidget {
  final allUsers;

  UserTable(this.allUsers);

  @override
  State<UserTable> createState() => _UserTableState();

}

class _UserTableState extends State<UserTable> {

  List<YupcityUser> userList = [];
  var eventBus = GetIt.I.get<EventBus>();

  @override
  void initState() {
    super.initState();
    userList = widget.allUsers;

    eventBus.on<UserSearchEvent>().listen((event) {
      if (mounted) {
        setState(() {
        userList = event.users;
        });
      }
    });

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
            "Usuarios",
            style: Theme.of(context).textTheme.subtitle1,
          ),
          SizedBox(
            width: double.infinity,
            child: DataTable2(
              columnSpacing: defaultPadding,
              minWidth: 800,
              columns: [
                DataColumn(
                  label: Text("Email"),
                ),
                DataColumn(
                  label: Text("Usos total"),
                ),
                /*DataColumn(
                  label: Text("Size"),
                ),*/
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
              child: Text(user.email ?? "", overflow: TextOverflow.clip,),
            ),
          ],
        ),
      ),
      DataCell(Text(user.username ?? "", overflow: TextOverflow.ellipsis,)),
      //DataCell(Text(fileInfo.size!)),
    ],
  );
}
