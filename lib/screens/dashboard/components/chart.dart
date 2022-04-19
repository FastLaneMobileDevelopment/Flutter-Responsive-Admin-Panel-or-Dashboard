import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:yupcity_admin/i18n.dart';
import 'package:yupcity_admin/models/user.dart';
import 'package:yupcity_admin/models/yupcity_register.dart';
import 'package:yupcity_admin/models/yupcity_trap_poi.dart';

import '../../../constants.dart';

class Chart extends StatelessWidget {
  final List<YupcityUser> users;
  final List<YupcityTrapPoi> traps;
  final List<YupcityRegister> registries;

  Chart(this.users, this.traps, this.registries);


  @override
  Widget build(BuildContext context) {

    List<PieChartSectionData> paiChartSelectionDatas = [
      PieChartSectionData(
          color: primaryColor,
          value: users.length.toDouble(),
          showTitle: true,
          radius: 25,
          title: I18n.of(context).users,
      ),
      PieChartSectionData(
          color: Color(0xFF26E5FF),
          value: traps.length.toDouble(),
          showTitle: true,
          radius: 22,
          title: I18n.of(context).traps,
      ),
      PieChartSectionData(
          color: Color(0xFFFFCF26),
          value: registries.length.toDouble(),
          showTitle: true,
          radius: 19,
          title: I18n.of(context).logs,
      ),

    ];
    return SizedBox(
      height: 200,
      child: Stack(
        children: [
          PieChart(
            PieChartData(
              sectionsSpace: 0,
              centerSpaceRadius: 70,
              startDegreeOffset: -90,
              sections: paiChartSelectionDatas,
            ),
          ),
          Positioned.fill(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: defaultPadding),
               /* Text(
                  "29.1",
                  style: Theme.of(context).textTheme.headline4!.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        height: 0.5,
                      ),
                ),
                Text("of 128GB")*/
              ],
            ),
          ),
        ],
      ),
    );
  }
}


