import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yupcity_admin/bloc/chart/chart_bloc.dart';
import 'package:yupcity_admin/bloc/chart/chart_bloc_event.dart';
import 'package:yupcity_admin/bloc/chart/chart_bloc_state.dart';
import 'package:yupcity_admin/i18n.dart';
import 'package:yupcity_admin/models/UserGrowthWeekly.dart';
import 'package:yupcity_admin/models/user.dart';
import 'package:yupcity_admin/services/application/chart_logic.dart';

int columIndex = 0;

var dateTimeEnd = DateTime.now();

class UserGrowthChart extends StatefulWidget {
  final List<YupcityUser> allUsers;

  UserGrowthChart(this.allUsers);

  @override
  State<UserGrowthChart> createState() => _UserGrowthChartState();
}

class _UserGrowthChartState extends State<UserGrowthChart> {
  var _chartBloc = ChartBloc(logic: YupcityChartLogic());
  var isLoading = true;
  UserGrowthWeekly userGrowthWeekly = UserGrowthWeekly();
  List<Color> gradientColors = [
    const Color(0xff23b6e6),
    const Color(0xff02d39a),
  ];




   @override
  void initState() {
     _chartBloc.add(GetUserDataLast7DaysEvent(widget.allUsers,));
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    columIndex = 0;
    return BlocProvider(
      create: (context) => _chartBloc,
      child: BlocListener<ChartBloc, ChartBlocState>(
        listener: (context, state) {
          if(state is LoadingUserChartBlocState){
            if(mounted){
              setState(() {
                isLoading = true;
              });
            }
          }else if(state is UpdatedUserDataChartBlocState){
            setState(() {
              isLoading = false;
              userGrowthWeekly = state.userGrowthWeekly ;
            });
            debugPrint(userGrowthWeekly.toString());
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
              return Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: AspectRatio(
                  aspectRatio: 1.7,
                  child: Card(
                    elevation: 0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    color: const Color(0xff2c4260),
                    child:  _BarChart(userGrowthWeekly),
                  ),
                ),
              );

            }},
        ),
      ),
    );
  }







}


class _BarChart extends StatelessWidget {

  UserGrowthWeekly userGrowthChart;

  _BarChart(this.userGrowthChart);
  late BuildContext ctx ;

  @override
  Widget build(BuildContext context) {
     ctx = context;
    return BarChart(
      BarChartData(
        barTouchData: barTouchData,
        titlesData: titlesData,
        borderData: borderData,
        barGroups: barGroups(userGrowthChart),
        gridData: FlGridData(show: false),
        alignment: BarChartAlignment.spaceAround,
        maxY: 20,
      ),
    );
  }



  BarTouchData get barTouchData => BarTouchData(
    enabled: false,
    touchTooltipData: BarTouchTooltipData(
      tooltipBgColor: Colors.transparent,
      tooltipPadding: const EdgeInsets.all(0),
      tooltipMargin: 8,
      getTooltipItem: (
          BarChartGroupData group,
          int groupIndex,
          BarChartRodData rod,
          int rodIndex,
          ) {
        return BarTooltipItem(
          rod.toY.round().toString(),
          const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        );
      },
    ),
  );

  Widget getTitles(double value, TitleMeta meta,) {
    const  style = TextStyle(
      color: Color(0xff7589a2),
      fontWeight: FontWeight.bold,
      fontSize: 14,
    );

    String text= "";
    int distanceDay  = ((6 - columIndex)*-1).toInt();
    columIndex++;
    int weekday = dateTimeEnd.add(Duration(days: distanceDay)).weekday;
    debugPrint(weekday.toString());

    switch (weekday) {
      case 1:
        text = I18n.of(ctx).monday;
        break;
      case 2:
        text = I18n.of(ctx).tuesday;
        break;
      case 3:
        text = I18n.of(ctx).wednesday;
        break;
      case 4:
        text = I18n.of(ctx).thursday;
        break;
      case 5:
        text = I18n.of(ctx).friday;
        break;
      case 6:
        text = I18n.of(ctx).saturday;
        break;
      case 7:
        text = I18n.of(ctx).sunday;
        break;
      default:
        text = "";
        break;
    }
    return Center(child: Text(text, style: style));
  }

  FlTitlesData get titlesData => FlTitlesData(
    show: true,
    bottomTitles: AxisTitles(
      sideTitles: SideTitles(
        interval: 1,
        showTitles: true,
        reservedSize: 30,
        getTitlesWidget: getTitles,
      ),
    ),
    leftTitles: AxisTitles(
      sideTitles: SideTitles(showTitles: false),
    ),
    topTitles: AxisTitles(
      sideTitles: SideTitles(showTitles: false),
    ),
    rightTitles: AxisTitles(
      sideTitles: SideTitles(showTitles: false),
    ),

  );

  FlBorderData get borderData => FlBorderData(
    show: false,
  );

  final _barsGradient = const LinearGradient(
    colors: [
      Colors.lightBlueAccent,
      Colors.greenAccent,
    ],
    begin: Alignment.bottomCenter,
    end: Alignment.topCenter,
  );

  List<BarChartGroupData> barGroups(UserGrowthWeekly week){
    List<BarChartGroupData> barChart = [];

    for(var i = 0; i <= 6; i++) {
      int distanceDay = ((6 - columIndex) * -1).toInt();
      columIndex++;
      int weekday = dateTimeEnd
          .add(Duration(days: distanceDay))
          .weekday;

      switch (weekday) {
        case 1:
          barChart.add(
            BarChartGroupData(
              x: 0,
              barRods: [
                BarChartRodData(
                  toY: week.monday.length.toDouble(),
                  gradient: _barsGradient,
                )
              ],
              showingTooltipIndicators: [0],
            ),
          );
          break;
        case 2:
          barChart.add(
            BarChartGroupData(
              x: 0,
              barRods: [
                BarChartRodData(
                  toY: week.tuesday.length.toDouble(),
                  gradient: _barsGradient,
                )
              ],
              showingTooltipIndicators: [0],
            ),
          );
          break;
        case 3:
          barChart.add(
            BarChartGroupData(
              x: 0,
              barRods: [
                BarChartRodData(
                  toY: week.wednesday.length.toDouble(),
                  gradient: _barsGradient,
                )
              ],
              showingTooltipIndicators: [0],
            ),
          );
          break;
        case 4:
          barChart.add(
            BarChartGroupData(
              x: 0,
              barRods: [
                BarChartRodData(
                  toY: week.thursday.length.toDouble(),
                  gradient: _barsGradient,
                )
              ],
              showingTooltipIndicators: [0],
            ),
          );
          break;
        case 5:
          barChart.add(
            BarChartGroupData(
              x: 0,
              barRods: [
                BarChartRodData(
                  toY: week.friday.length.toDouble(),
                  gradient: _barsGradient,
                )
              ],
              showingTooltipIndicators: [0],
            ),
          );
          break;
        case 6:
          barChart.add(
            BarChartGroupData(
              x: 0,
              barRods: [
                BarChartRodData(
                  toY: week.saturday.length.toDouble(),
                  gradient: _barsGradient,
                )
              ],
              showingTooltipIndicators: [0],
            ),
          );
          break;
        case 7:
          barChart.add(
            BarChartGroupData(
              x: 0,
              barRods: [
                BarChartRodData(
                  toY: week.sunday.length.toDouble(),
                  gradient: _barsGradient,
                )
              ],
              showingTooltipIndicators: [0],
            ),
          );
          break;
        default:
          barChart.add(
            BarChartGroupData(
              x: 0,
              barRods: [
                BarChartRodData(
                  toY: 0,
                  gradient: _barsGradient,
                )
              ],
              showingTooltipIndicators: [0],
            ),
          );
          break;
      }
    }

    return barChart;
  }


}
