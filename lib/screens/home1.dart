import 'package:fl_chart/fl_chart.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hascol_dealer/screens/complaint.dart';
import 'package:hascol_dealer/screens/order_list.dart';
import 'package:hascol_dealer/screens/profile.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';




import 'create_order.dart';

class Home extends StatefulWidget {
  static const Color contentColorOrange = Color(0xFF00705B);
  final Color leftBarColor = Color(0xFFCB6600);
  final Color rightBarColor = Color(0xFF5BECD2);
  @override
  _HomeScreenState createState() => _HomeScreenState();
}
class _HomeScreenState extends State<Home> {
  final List<chartdata> ChartData = [
    chartdata("Jan", 500, 750, 1250),
    chartdata("Feb", 100, 900, 1000),
    chartdata("Mar", 250, 600, 850),
    chartdata("Apr", 2500, 2500, 5000),
    chartdata("May", 300, 300, 600),
    chartdata("Jun", 300, 300, 600),
    chartdata("Jul", 200, 300, 500),
    chartdata("Aug", 200, 300, 500),
    chartdata("Sep", 140, 300, 440),
    chartdata("Oct", 140, 140, 280),
    chartdata("Nov", 200, 300, 400),
    chartdata("Dec", 200, 300, 400),
  ];
  final double width = 7;
  late List<BarChartGroupData> rawBarGroups;
  late List<BarChartGroupData> showingBarGroups;
  int _selectedIndex = 0;
  int touchedGroupIndex = -1;

  @override
  void initState() {
    super.initState();

    final barGroup1 = makeGroupData(1, 5, 12);
    final barGroup2 = makeGroupData(1, 16, 12);
    final barGroup3 = makeGroupData(2, 18, 5);
    final barGroup4 = makeGroupData(3, 20, 16);
    final barGroup5 = makeGroupData(4, 17, 6);
    final barGroup6 = makeGroupData(5, 19, 1.5);
    final barGroup8 = makeGroupData(7, 24, 1.5);
    final barGroup7 = makeGroupData(6, 10, 1.5);

    final items = [
      barGroup1,
      barGroup2,
      barGroup3,
      barGroup4,
      barGroup5,
      barGroup6,
      barGroup7,
      barGroup8
    ];

    rawBarGroups = items;

    showingBarGroups = rawBarGroups;
    // getValue();
  }

  Widget leftTitles(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Color(0xff7589a2),
      fontWeight: FontWeight.bold,
      fontSize: 14,
    );
    String text;
    if (value == 0) {
      text = '1K';
    } else if (value == 10) {
      text = '5K';
    } else if (value == 19) {
      text = '10K';
    } else if (value == 25) {
      text = '15K';
    }
    else {
      return Container();
    }
    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 0,
      child: Text(text, style: style),
    );
  }

  Widget bottomTitles(double value, TitleMeta meta) {
    final titles = <String>[
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug'
    ];

    final Widget text = Text(
      titles[value.toInt()],
      style: const TextStyle(
        color: Color(0xff7589a2),
        fontWeight: FontWeight.bold,
        fontSize: 14,
      ),
    );

    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 16, //margin top
      child: text,
    );
  }

  BarChartGroupData makeGroupData(int x, double y1, double y2) {
    return BarChartGroupData(
      barsSpace: 4,
      x: x,
      barRods: [
        BarChartRodData(
          toY: y1,
          color: widget.leftBarColor,
          width: width,
        ),
        BarChartRodData(
          toY: y2,
          color: widget.rightBarColor,
          width: width,
        ),
      ],
    );
  }

  Widget makeTransactionsIcon() {
    const width = 4.5;
    const space = 3.5;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Container(
          width: width,
          height: 10,
          color: Colors.white.withOpacity(0.4),
        ),
        const SizedBox(
          width: space,
        ),
        Container(
          width: width,
          height: 28,
          color: Colors.white.withOpacity(0.8),
        ),
        const SizedBox(
          width: space,
        ),
        Container(
          width: width,
          height: 42,
          color: Colors.white.withOpacity(1),
        ),
        const SizedBox(
          width: space,
        ),
        Container(
          width: width,
          height: 28,
          color: Colors.white.withOpacity(0.8),
        ),
        const SizedBox(
          width: space,
        ),
        Container(
          width: width,
          height: 10,
          color: Colors.white.withOpacity(0.4),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('EEE d MMM kk:mm:ss').format(now);
    return Scaffold(
      backgroundColor: Color(0xffffffff),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 48.0, left: 5, right: 5),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        backgroundColor: Color(0xff12283D),
                        radius: 30,
                        child: Text(
                          'SB',
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontStyle: FontStyle.normal,
                          ),
                        ), //Text
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Welcome Home,',
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                color: Color(0xff8A8A8A),
                                fontWeight: FontWeight.w500,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                            Text(
                              'Sales Bridge',
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                color: Color(0xff000000),
                                fontWeight: FontWeight.w800,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                        // Use the FaIcon Widget + FontAwesomeIcons class for the IconData
                          icon: Icon(
                            Icons.add_box_rounded,
                            color: Color(0xff12283D),
                            size: 35,
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Create_Order()),
                            );
                            print("Pressed");
                          }),
                    ],
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Card(
                    color: Color(0xffF0F0F0),
                    elevation: 15,
                    child: SizedBox(
                      width: MediaQuery
                          .of(context)
                          .size
                          .width / 1.07,
                      height: 140,
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            //CircleAvatar
                            const SizedBox(
                              height: 10,
                            ), //SizedBox
                            Text(
                              'Ledger Balance',
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                color: Color(0xff000000),
                                fontWeight: FontWeight.w500,
                                fontStyle: FontStyle.normal,
                              ),
                            ), //Text
                            const SizedBox(
                              height: 50,
                            ),
                            Row(
                              children: [
                                CircleAvatar(
                                    backgroundColor: Color(0xff7DBDBD),
                                    radius: 15,
                                    child: Icon(
                                      FluentIcons.payment_32_filled,
                                      color: Colors.white,
                                      size: 18,
                                    ) //Text
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '3,75,000 Rs.',
                                      style: GoogleFonts.poppins(
                                        fontSize: 14,
                                        color: Color(0xff000000),
                                        fontWeight: FontWeight.w600,
                                        fontStyle: FontStyle.italic,
                                      ),
                                    ),
                                    Text(
                                      'Updated On : ${formattedDate}',
                                      style: GoogleFonts.poppins(
                                        fontSize: 10,
                                        color: Color(0xff8A8A8A),
                                        fontWeight: FontWeight.w300,
                                        fontStyle: FontStyle.italic,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),

                            //SizedBox
                            //T //SizedBox
                            //SizedBox
                          ],
                        ), //Column
                      ), //Padding
                    ), //SizedBox,
                  )
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      color: Color(0xff12283D),
                      elevation: 15,
                      child: SizedBox(
                        width: 165,
                        height: 160,
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(
                                height: 5,
                              ),
                              Card(
                                color: Color(0xff586776),
                                child: SizedBox(
                                  width: 30,
                                  height: 30,
                                  child: Icon(
                                    Icons.bookmark_border,
                                    color: Colors.white,
                                  ),
                                ),
                              ), //Text
                              const SizedBox(
                                height: 5,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Total Orders',
                                    style: GoogleFonts.poppins(
                                      color: Color(0xffffffff),
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16,
                                      fontStyle: FontStyle.normal,
                                    ),
                                  ),
                                  Text(
                                    '100 Orders',
                                    style: GoogleFonts.montserrat(
                                      color: Color(0xffc7c7c7),
                                      fontWeight: FontWeight.w600,
                                      fontSize: 12,
                                      fontStyle: FontStyle.normal,
                                    ),
                                  ),

                                  OutlinedButton(
                                    child: Text('Create Order',
                                      style: GoogleFonts.montserrat(
                                        color: Color(0xffc7c7c7),
                                        fontWeight: FontWeight.w600,
                                        fontSize: 12,
                                        fontStyle: FontStyle.normal,
                                      ),),

                                    style: OutlinedButton.styleFrom(
                                      side: BorderSide(width: 1.0, color: Color(
                                          0xd5e0e0e0)),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                    ),
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (context) =>
                                            Create_Order()),
                                      );
                                    },
                                  )

                                ],
                              ),

                              //SizedBox
                              //T //SizedBox
                              //SizedBox
                            ],
                          ), //Column
                        ), //Padding
                      ), //SizedBox,
                    ),
                  ),
                  Expanded(
                    child: Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      color: Color(0xffF0F0F0),
                      elevation: 15,
                      child: SizedBox(
                        width: 165,
                        height: 160,
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(
                                height: 5,
                              ),
                              Card(
                                color: Color(0x283C81B5),
                                child: SizedBox(
                                  width: 30,
                                  height: 30,
                                  child: Icon(
                                    Icons.crisis_alert,
                                    color: Color(0xff12283D),
                                  ),
                                ),
                              ), //Text

                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Total Complaints',
                                    style: GoogleFonts.poppins(
                                      color: Color(0xff12283D),
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16,
                                      fontStyle: FontStyle.normal,
                                    ),
                                  ),
                                  Text(
                                    '15 Complaints',
                                    style: GoogleFonts.montserrat(
                                      color: Color(0xff8D8D8D),
                                      fontWeight: FontWeight.w600,
                                      fontSize: 12,
                                      fontStyle: FontStyle.normal,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 8,
                                  ),
                                  OutlinedButton(
                                    child: Text('Create Complaint',
                                      style: GoogleFonts.montserrat(
                                        color: Color(0xff8D8D8D),
                                        fontWeight: FontWeight.w600,
                                        fontSize: 12,
                                        fontStyle: FontStyle.normal,
                                      ),),

                                    style: OutlinedButton.styleFrom(
                                      side: BorderSide(width: 1.0, color: Color(
                                          0xd5e0e0e0)),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20),

                                      ),
                                    ),
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (context) =>
                                            Create_Complaints()),
                                      );
                                      print('Pressed');
                                    },
                                  )

                                ],
                              ),

                              //SizedBox
                              //T //SizedBox
                              //SizedBox
                            ],
                          ), //Column
                        ), //Padding
                      ), //SizedBox,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              /*
              Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                color: Color(0xff12283D),
                child: AspectRatio(
                  aspectRatio: 1.3,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            makeTransactionsIcon(),
                            const SizedBox(
                              width: 38,
                            ),
                            const Text(
                              'Order History',
                              style: TextStyle(
                                  color: Colors.white, fontSize: 22),
                            ),
                            // const SizedBox(
                            //   width: 4,
                            // ),
                            // const Text(
                            //   'state',
                            //   style: TextStyle(color: Color(0xff77839a), fontSize: 16),
                            // ),
                          ],
                        ),
                        const SizedBox(
                          height: 38,
                        ),
                        Expanded(
                          child: BarChart(
                            BarChartData(
                              maxY: 20,
                              barTouchData: BarTouchData(
                                touchTooltipData: BarTouchTooltipData(
                                  tooltipBgColor: Colors.grey,
                                  getTooltipItem: (a, b, c, d) => null,
                                ),
                                touchCallback: (FlTouchEvent event, response) {
                                  if (response == null ||
                                      response.spot == null) {
                                    setState(() {
                                      touchedGroupIndex = -1;
                                      showingBarGroups = List.of(rawBarGroups);
                                    });
                                    return;
                                  }

                                  touchedGroupIndex =
                                      response.spot!.touchedBarGroupIndex;

                                  setState(() {
                                    if (!event.isInterestedForInteractions) {
                                      touchedGroupIndex = -1;
                                      showingBarGroups = List.of(rawBarGroups);
                                      return;
                                    }
                                    showingBarGroups = List.of(rawBarGroups);
                                    if (touchedGroupIndex != -1) {
                                      var sum = 0.0;
                                      for (final rod
                                      in showingBarGroups[touchedGroupIndex]
                                          .barRods) {
                                        sum += rod.toY;
                                      }
                                      final avg = sum /
                                          showingBarGroups[touchedGroupIndex]
                                              .barRods
                                              .length;

                                      showingBarGroups[touchedGroupIndex] =
                                          showingBarGroups[touchedGroupIndex]
                                              .copyWith(
                                            barRods: showingBarGroups[touchedGroupIndex]
                                                .barRods
                                                .map((rod) {
                                              return rod.copyWith(
                                                  toY: avg,
                                                  color: widget.rightBarColor);
                                            }).toList(),
                                          );
                                    }
                                  });
                                },
                              ),
                              titlesData: FlTitlesData(
                                show: true,
                                rightTitles: const AxisTitles(
                                  sideTitles: SideTitles(showTitles: false),
                                ),
                                topTitles: const AxisTitles(
                                  sideTitles: SideTitles(showTitles: false),
                                ),
                                bottomTitles: AxisTitles(
                                  sideTitles: SideTitles(
                                    showTitles: true,
                                    getTitlesWidget: bottomTitles,
                                    reservedSize: 42,
                                  ),
                                ),
                                leftTitles: AxisTitles(
                                  sideTitles: SideTitles(
                                    showTitles: true,
                                    reservedSize: 28,
                                    interval: 1,
                                    getTitlesWidget: leftTitles,
                                  ),
                                ),
                              ),
                              borderData: FlBorderData(
                                show: false,
                              ),
                              barGroups: showingBarGroups,
                              gridData: const FlGridData(show: false),
                            ),
                            swapAnimationDuration: Duration(milliseconds: 150),
                            // Optional
                            swapAnimationCurve: Curves.linear,
                          ),
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
               */
              Card(
                color: Color(0xff12283D),
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        "Order History",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Container(
                      child: SfCartesianChart(
                        primaryXAxis: CategoryAxis(),
                        legend: Legend( isVisible: true, position: LegendPosition.top,textStyle:TextStyle(color: Color(
                            0xff636465))),
                        series: <ChartSeries>[
                          StackedColumnSeries<chartdata, String>(
                            dataSource: ChartData,
                            xValueMapper: (chartdata ch, _) => ch.x,
                            yValueMapper: (chartdata ch, _) => ch.y1,
                            name: 'PMG', // Legend label
                            color: Color(0xfffd6929), // Change the color of the bars
                          ),
                          StackedColumnSeries<chartdata, String>(
                            dataSource: ChartData,
                            xValueMapper: (chartdata ch, _) => ch.x,
                            yValueMapper: (chartdata ch, _) => ch.y2,
                            name: 'HSD', // Legend label
                            color: Color(0xff5bebd1), // Change the color of the bars
                          ),
                          StackedColumnSeries<chartdata, String>(
                            dataSource: ChartData,
                            xValueMapper: (chartdata ch, _) => ch.x,
                            yValueMapper: (chartdata ch, _) => ch.y3,
                            name: 'Total', // Legend label
                            color: Color(0xff6c6074), // Change the color of the bars
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(10),
                              topRight: Radius.circular(10),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(
                height: 10,
              ),
              Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                          child: Card(
                            color: Color(0xffF0F0F0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              // Align content to the left
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    'INDENT PRICE',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xff0e4967),
                                      fontSize: 18.0,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment
                                        .spaceBetween,
                                    children: <Widget>[
                                      Text(
                                        'PMG',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xff0e4967),),
                                      ),
                                      Text(
                                        'HSD',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xff0e4967),),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 8.0, right: 8.0, bottom: 8.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment
                                        .spaceBetween,
                                    children: <Widget>[
                                      Text('330.2/Ltr',
                                        style: TextStyle(
                                            color: Color(0xff0e4967)),),
                                      Text('316.5/Ltr',
                                        style: TextStyle(
                                            color: Color(0xff0e4967)),),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          )
                      ),

                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Expanded(
                          child: Card(
                            color: Color(0xffF0F0F0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              // Align content to the left
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    'NOZZLE PRICE',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xff0e4967),
                                      fontSize: 18.0,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment
                                        .spaceBetween,
                                    children: <Widget>[
                                      Text(
                                        'PMG',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xff0e4967),),
                                      ),
                                      Text(
                                        'HSD',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xff0e4967),),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 8.0, right: 8.0, bottom: 8.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment
                                        .spaceBetween,
                                    children: <Widget>[
                                      Text('330.2/Ltr',
                                        style: TextStyle(
                                            color: Color(0xff0e4967)),),
                                      Text('316.5/Ltr',
                                        style: TextStyle(
                                            color: Color(0xff0e4967)),),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          )
                      ),

                    ],
                  ),
                ],
              ),
              // practise material.





            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: Color(0x8ca9a9a9),
              blurRadius: 20,
            ),
          ],
        ),
        child: BottomNavigationBar(

            currentIndex: _selectedIndex,
            unselectedItemColor: Color(0xff8d8d8d),
            unselectedLabelStyle: const TextStyle(
                color: Color(0xff8d8d8d), fontSize: 14),
            unselectedFontSize: 14,
            showUnselectedLabels: true,
            showSelectedLabels: true,
            selectedIconTheme: IconThemeData(
              color: Color(0xff12283D),

            ),
            type: BottomNavigationBarType.shifting,
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                  icon: Icon(FluentIcons.home_32_regular, size: 20,),
                  label: 'Home',
                  backgroundColor: Colors.white
              ),
              BottomNavigationBarItem(
                  icon: Icon(FluentIcons.weather_sunny_16_regular, size: 20,),
                  label: 'Orders',
                  backgroundColor: Colors.white
              ),
              BottomNavigationBarItem(
                icon: Icon(FluentIcons.inprivate_account_16_regular, size: 20,),
                label: 'Profile',
                backgroundColor: Colors.white,
              ),
            ],

            selectedItemColor: Color(0xff12283D),
            iconSize: 40,
            onTap: _onItemTapped,
            elevation: 15
        ),
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    if (_selectedIndex == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Orders()),
      );
    }
    if (_selectedIndex == 2) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Profile()),
      );
    }
  }
}

class chartdata{
  final String x;
  final int y1;
  final int y2;
  final int y3;
  chartdata(this.x,this.y1,this.y2,this.y3);
}

