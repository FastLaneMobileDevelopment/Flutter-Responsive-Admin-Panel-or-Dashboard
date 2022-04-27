import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yupcity_admin/bloc/chart/chart_bloc.dart';
import 'package:yupcity_admin/bloc/chart/chart_bloc_event.dart';
import 'package:yupcity_admin/bloc/chart/chart_bloc_state.dart';
import 'package:yupcity_admin/i18n.dart';
import 'package:yupcity_admin/models/user.dart';
import 'package:yupcity_admin/models/yupcity_register.dart';
import 'package:yupcity_admin/models/yupcity_trap_poi.dart';
import 'package:yupcity_admin/services/application/chart_logic.dart';

import '../../../constants.dart';
import 'chart.dart';
import 'storage_info_card.dart';

class StarageDetails extends StatefulWidget {
  final List<YupcityUser> allUsers;
  final List<YupcityTrapPoi> allTraps;
  final List<YupcityRegister> allRegistries;

  StarageDetails(this.allUsers, this.allTraps, this.allRegistries);

  @override
  State<StarageDetails> createState() => _StarageDetailsState();
}

class _StarageDetailsState extends State<StarageDetails> {

  var _chartBloc = ChartBloc(logic: YupcityChartLogic());
  var isLoading = true;
  List<YupcityUser> users7List = [];
  List<YupcityTrapPoi> traps7List = [];
  List<YupcityRegister> register7List = [];

   @override
  void initState() {
     _chartBloc.add(GetDataLast7DaysEvent(widget.allUsers, widget.allTraps, widget.allRegistries));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {


    return BlocProvider(
      create: (context) => _chartBloc,
      child: BlocListener<ChartBloc, ChartBlocState>(
        listener: (context, state) {
          if(state is LoadingChartBlocState){
            if(mounted){
              setState(() {
                isLoading = true;
              });
            }
          }else if(state is UpdatedDataChartBlocState){
            setState(() {
              isLoading = false;
              users7List = state.allUsers ?? [];
              traps7List = state.allTraps ?? [];
              register7List = state.registries ?? [];
            });
          }else if( state is ErrorChartBlocState){
           setState(() {
             isLoading = true;
           });
          }
        },
        child: BlocBuilder<ChartBloc, ChartBlocState>(
          builder: (context, state) {
            if(isLoading){
              return Center(child: CircularProgressIndicator(),);
            }else {
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
                    I18n.of(context).last_seven_days,

                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: defaultPadding),
                    Chart(users7List,traps7List,register7List),
                    StorageInfoCard(
                      svgSrc: "assets/icons/Documents.svg",
                      title: I18n.of(context).users,
                      amountFiltered: users7List.length.toString() + " "+ I18n.of(context).new_,
                      amountTotal: widget.allUsers.length,
                    ),
                    StorageInfoCard(
                      svgSrc: "assets/icons/media.svg",
                      title: I18n.of(context).traps,
                      amountFiltered: traps7List.length.toString() +" "+ I18n.of(context).new_,
                      amountTotal: widget.allTraps.length,
                    ),
                    StorageInfoCard(
                      svgSrc: "assets/icons/folder.svg",
                      title: I18n.of(context).number_of_uses,
                      amountFiltered: register7List.length.toString() +" "+
                          I18n.of(context).new_,
                      amountTotal: widget.allRegistries.length,
                    ),
                    /*StorageInfoCard(
                    svgSrc: "assets/icons/unknown.svg",
                    title: "Unknown",
                    amountFiltered: "1.3GB",
                    amountTotal: 140,
                  ),*/
                  ],
                ),
              );
            }},
        ),
      ),
    );
  }
}
