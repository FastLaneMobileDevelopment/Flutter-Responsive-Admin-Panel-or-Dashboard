import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yupcity_admin/bloc/devices/devices_bloc.dart';
import 'package:yupcity_admin/bloc/devices/devices_bloc_event.dart';
import 'package:yupcity_admin/bloc/devices/devices_bloc_state.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:yupcity_admin/i18n.dart';
import 'package:yupcity_admin/models/yupcity_register.dart';
import 'package:yupcity_admin/models/yupcity_trap_poi.dart';
import 'package:yupcity_admin/screens/trap_details.dart';
import 'package:yupcity_admin/services/application/devices_logic.dart';

import '../../../constants.dart';

class DevicesTable extends StatefulWidget {
  final List<YupcityRegister> allRegistries;
  final List<YupcityTrapPoi> allTraps;

  DevicesTable(this.allRegistries, this.allTraps);

  @override
  State<DevicesTable> createState() => _DevicesTableState();
}

class _DevicesTableState extends State<DevicesTable> {
  var _devicesBloc = DevicesBloc(logic: YupcityDevicesLogic());
  List<YupcityTrapPoi> trapsList = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _devicesBloc.add(
        GetTrapsWithRegistriesEvent(widget.allTraps, widget.allRegistries));
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _devicesBloc,
      child: BlocListener<DevicesBloc, DevicesBlocState>(
        listener: (context, state) {
          if (state is LoadingTrapsBlocState) {
            if (mounted) {
              setState(() {
                isLoading = true;
              });
            }
          } else if (state is UpdatedDataTrapsBlocState) {
            setState(() {
              isLoading = false;
              trapsList = state.allTraps ?? [];
            });
          } else if (state is ErrorTrapBlocState) {}
        },
        child: BlocBuilder<DevicesBloc, DevicesBlocState>(
          builder: (context, state) {
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
                    I18n.of(context).traps,
                    style: Theme.of(context).textTheme.subtitle1,
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: DataTable2(
                      columnSpacing: defaultPadding,
                      minWidth: 800,
                      columns: [
                        DataColumn(
                          label: Text(I18n.of(context).place_alias),
                        ),
                        DataColumn(
                          label: Text(I18n.of(context).number_of_uses),
                        ),
                        DataColumn(
                          label: Text(I18n.of(context).description),
                        ),
                      ],
                      rows: List.generate(
                        trapsList.length,
                        (index) => devicesDataRow(
                            trapsList[index], context, widget.allRegistries),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  DataRow devicesDataRow(
      YupcityTrapPoi trap, BuildContext context, allRegistries) {
    return DataRow(
      cells: [
        DataCell(
            Row(
              children: [
                Icon(
                  Icons.lock_outline,
                  color: Colors.lightBlue,
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: defaultPadding),
                  child: Text(trap.center!),
                ),
              ],
            ), onTap: () {
          moveToDetail(context, allRegistries, trap);
        }),
        DataCell(Text(trap.numberOfUses.toString()), onTap: () {
          moveToDetail(context, allRegistries, trap);
        }),
        DataCell(Text(trap.centerDescription ?? ""), onTap: () {
          moveToDetail(context, allRegistries, trap);
        }),
      ],
    );
  }

  void moveToDetail(BuildContext context, allRegistries, YupcityTrapPoi trap) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => TrapDetails(allRegistries, trap)),
    );
  }
}
