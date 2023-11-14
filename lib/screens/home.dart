import 'dart:convert';

import 'package:fl_chart/fl_chart.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hascol_dealer/screens/complaint_list.dart';
import 'package:hascol_dealer/screens/lubricant_list.dart';
import 'package:hascol_dealer/screens/order_list.dart';
import 'package:hascol_dealer/screens/profile.dart';
import 'package:hascol_dealer/screens/uniform_list.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class Home extends StatefulWidget {
  static const Color contentColorOrange = Color(0xFF00705B);
  final Color leftBarColor = Color(0xFFCB6600);
  final Color rightBarColor = Color(0xFF5BECD2);
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<Home> {
  String dealershipName = "";
  String sap_no = "";
  String account = "";
  String initials = ''; // Initialize the initials variable
  late Future<List<Map<String, dynamic>>?> data;
  List<chartdata> ChartData = [];
  List<StackedColumnSeries<chartdata, String>> generateSeries() {
    final List<StackedColumnSeries<chartdata, String>> seriesList = [];
    final dataKeys =
        ChartData.isNotEmpty ? ChartData[0].data.keys.toList() : [];

    for (int i = 0; i < dataKeys.length; i++) {
      final key = dataKeys[i];
      final series = StackedColumnSeries<chartdata, String>(
        dataSource: ChartData,
        xValueMapper: (chartdata ch, _) => ch.x,
        yValueMapper: (chartdata ch, _) => ch.data[key],
        name: key,
        color: barColors[i % barColors.length],
      );
      seriesList.add(series);
    }

    return seriesList;
  }

  final List<Color> barColors = [
    Color(0xff90ee90),
    Color(0xffffa500),
    Color(0xffffc0cb),
    Color(0xffadd8e6),
    Color(0xffdda0dd),
    Color(0xffffff00),
    Color(0xfff5f5dc),
    Color(0xff87ceeb),
    Color(0xffe6e6fa),
    Color(0xff00ff7f),
  ];
  final double width = 7;
  late List<BarChartGroupData> rawBarGroups;
  late List<BarChartGroupData> showingBarGroups;
  int _selectedIndex = 0;
  int touchedGroupIndex = -1;
  @override
  void initState() {
    super.initState();
    // Call the method to load and print data when the home page is initialized.
    loadDataFromSharedPreferences();
    data = fetchData();
    fetchDataAndUpdateChart();
  }

  Future<void> loadDataFromSharedPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    final name = prefs.getString("name");

    setState(() {
      dealershipName = name ?? '';
      sap_no = prefs.getString("sap_no") ??
          ''; // Use an empty string if the name is null
      account = prefs.getString("account") ??
          ''; // Use an empty string if the name is null
      // sap_no = sap_no ?? ''; // Use an empty string if the name is null
      if (dealershipName.length >= 2) {
        // Get the first two characters and convert them to uppercase
        initials = dealershipName.substring(0, 2).toUpperCase();
      } else if (dealershipName.isNotEmpty) {
        // If the name is less than 2 characters, use it as is
        initials = dealershipName.toUpperCase();
      }
    });
  }

  Future<List<Map<String, dynamic>>?> fetchData() async {
    final url = Uri.parse(
        "http://151.106.17.246:8080/OMCS-CMS-APIS/get/dealers_products.php?key=03201232927&dealer_id=3");

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> jsonResponse = json.decode(response.body);
        List<Map<String, dynamic>> data =
            jsonResponse.cast<Map<String, dynamic>>();
        return data;
      } else {
        // Handle the error, e.g., show an error message
        return null;
      }
    } catch (exception) {
      // Handle exceptions
      return null;
    }
  }

  Future<void> fetchDataAndUpdateChart() async {
    final url =
        'http://151.106.17.246:8080/OMCS-CMS-APIS/get/month_order_graph.php?key=03201232927&dealer_id=3';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(response.body);

      final List<chartdata> updatedChartData = [];

      for (final monthData in jsonData) {
        final String monthName = monthData['name'];
        final Map<String, int> monthDataMap = {};

        for (final entry in monthData['data']) {
          final key = entry.keys.first;
          final value = entry[key];
          monthDataMap[key] = value;
        }

        updatedChartData.add(chartdata(monthName, monthDataMap));
      }

      // Update the ChartData list with the new data
      setState(() {
        ChartData = updatedChartData;
      });
    } else {
      // Handle API error
      print('Failed to fetch data from the API');
    }
  }

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('EEE d MMM kk:mm:ss').format(now);
    return Scaffold(
      backgroundColor: Color(0xffea1b25),
      body: RefreshIndicator(
        onRefresh: () async {
          loadDataFromSharedPreferences();
          data = fetchData();
          await fetchDataAndUpdateChart();
        },
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(
              top: 54.0,
            ),
            child: Column(
              children: [
                ClipRect(
                  child: Stack(children: [
                    Opacity(
                      opacity: 0.5,
                      child: Image.asset('assets/images/puma png.png'),
                    ),
                    Container(
                      child: Column(
                        children: [
                          ClipRRect(
                            child: Container(
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image:
                                  AssetImage('assets/images/puma png.png'),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 10, left: 10),
                                    child: CircleAvatar(
                                      backgroundColor: Color(0xffffffff),
                                      radius: 15,
                                      child: Text(
                                        '$initials',
                                        style: GoogleFonts.raleway(
                                          fontSize: 16,
                                          color: Colors.black,
                                          fontWeight: FontWeight.w700,
                                          fontStyle: FontStyle.normal,
                                        ),
                                      ), //Text
                                    ),
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                ],
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 40,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Card(
                                color: Color(0xff3a833c),
                                elevation: 20,
                                child: SizedBox(
                                  width:
                                  MediaQuery.of(context).size.width / 1.25,
                                  height: 140,
                                  child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Column(
                                      mainAxisAlignment:
                                      MainAxisAlignment.start,
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: [
                                        //CircleAvatar
                                        const SizedBox(
                                          height: 10,
                                        ), //SizedBox
                                        Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              '$dealershipName',
                                              style: GoogleFonts.raleway(
                                                fontSize: 16,
                                                color: Color(0xffffffff),
                                                fontWeight: FontWeight.w500,
                                                fontStyle: FontStyle.normal,
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 1,
                                            ),
                                            Icon(
                                              Icons
                                                  .keyboard_arrow_down_outlined,
                                              color: Color(0xffffffff),
                                              size: 20.0,
                                            ),
                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              '$sap_no',
                                              style: GoogleFonts.raleway(
                                                fontSize: 16,
                                                color: Color(0xffffffff),
                                                fontWeight: FontWeight.w500,
                                                fontStyle: FontStyle.normal,
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 1,
                                            ),
                                            // Icon(
                                            //   Icons.keyboard_arrow_down_outlined,
                                            //   color: Color(0xffffffff),
                                            //   size: 20.0,
                                            // ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              'Current Balance',
                                              style: GoogleFonts.raleway(
                                                fontSize: 14,
                                                color: Color(0xffffffff),
                                                fontWeight: FontWeight.w500,
                                                fontStyle: FontStyle.normal,
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Row(
                                          children: [
                                            CircleAvatar(
                                                backgroundColor: Color(
                                                    0xffffffff), //0xff7DBDBD
                                                radius: 15,
                                                child: Icon(
                                                  FluentIcons.payment_32_filled,
                                                  color: Colors.grey,
                                                  size: 18,
                                                ) //Text
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Column(
                                              crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  'PKR. ${account}',
                                                  style: GoogleFonts.raleway(
                                                    fontSize: 14,
                                                    color: Color(0xffffffff),
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                                Text(
                                                  'Updated On : ${formattedDate}',
                                                  style: GoogleFonts.raleway(
                                                    fontSize: 10,
                                                    color: Color(0xffffffff),
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
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment
                                .spaceEvenly, // Adjust alignment as needed
                            children: <Widget>[
                              Column(
                                children: <Widget>[
                                  Container(
                                    width: 100.0,
                                    height: 100.0,
                                    decoration: BoxDecoration(
                                      color: Colors
                                          .white, // Set your desired color
                                      borderRadius: BorderRadius.circular(
                                          10.0), // Adjust the radius as needed
                                    ),
                                    child: Column(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(4.0),
                                          child: GestureDetector(
                                            child: Container(
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                border: Border.all(
                                                  color: Color(
                                                      0xffec1b24), // Set the color of the border
                                                  width:
                                                  1, // Set the width of the border
                                                ),
                                              ),
                                              child: CircleAvatar(
                                                radius:
                                                28, // Adjust the size of the circular avatar
                                                backgroundColor: Color(
                                                    0xffffffff), // You can set the background color
                                                child: Image.asset(
                                                  "assets/images/cargo (1).png",
                                                  width: 35,
                                                  height: 35,
                                                ),
                                              ),
                                            ),
                                            onTap: () {
                                              // Navigate to the OrderScreen when tapped
                                              Navigator.of(context).push(
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          Orders()));
                                            },
                                          ),
                                        ),
                                        Text(
                                          "Order",
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold),
                                        ), //Color(0xff01764a)
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                children: <Widget>[
                                  Container(
                                    width: 100.0,
                                    height: 100.0,
                                    decoration: BoxDecoration(
                                      color: Colors
                                          .white, // Set your desired color
                                      borderRadius: BorderRadius.circular(
                                          10.0), // Adjust the radius as needed
                                    ),
                                    child: Column(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(4.0),
                                          child: GestureDetector(
                                            child: Container(
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                border: Border.all(
                                                  color: Color(
                                                      0xffec1b24), // Set the color of the border
                                                  width:
                                                  1, // Set the width of the border
                                                ),
                                              ),
                                              child: CircleAvatar(
                                                radius:
                                                28, // Adjust the size of the circular avatar
                                                backgroundColor: Color(
                                                    0xffffffff), // Color(0xff01764a),You can set the background color
                                                child: Image.asset(
                                                  'assets/images/engine-oil (3).png',
                                                  width: 38,
                                                  height: 38,
                                                ),
                                              ),
                                            ),
                                            onTap: () {
                                              // Navigate to the OrderScreen when tapped
                                              Navigator.of(context).push(
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          Lubricant()));
                                            },
                                          ),
                                        ),
                                        Text(
                                          "Lubricant",
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold),
                                        ), //Color(0xff01764a)
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                children: <Widget>[
                                  Container(
                                    width: 100.0,
                                    height: 100.0,
                                    decoration: BoxDecoration(
                                      color: Colors
                                          .white, // Set your desired color
                                      borderRadius: BorderRadius.circular(
                                          10.0), // Adjust the radius as needed
                                    ),
                                    child: Column(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(4.0),
                                          child: GestureDetector(
                                            child: Container(
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                border: Border.all(
                                                  color: Color(
                                                      0xffec1b24), // Set the color of the border
                                                  width:
                                                  1, // Set the width of the border
                                                ),
                                              ),
                                              child: CircleAvatar(
                                                radius:
                                                28, // Adjust the size of the circular avatar
                                                backgroundColor: Color(
                                                    0xffffffff), //Color(0xff01764a),// You can set the background color
                                                child: Image.asset(
                                                  "assets/images/shirt1.png",
                                                  width: 38,
                                                  height: 38,
                                                ),
                                              ),
                                            ),
                                            onTap: () {
                                              // Navigate to the OrderScreen when tapped
                                              Navigator.of(context).push(
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          Uniform()));
                                            },
                                          ),
                                        ),
                                        Text(
                                          "Uniforms",
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold),
                                        ), //Color(0xff01764a)
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                        ],
                      ),
                    ),
                  ]),
                ),
                Align(
                  alignment: FractionalOffset.bottomCenter,
                  child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30.0),
                          topRight: Radius.circular(30.0),
                        ),
                      ),
                      margin: EdgeInsets.all(0),
                      child: Column(
                        children: [
                          Divider(
                            color: Color(
                                0x4f5d5d5d), // Set the color of the divider
                            height: 20.0, // Set the height of the divider
                            thickness: 5.0, // Set the thickness of the divider
                            indent: 185.0, // Set the left indent of the divider
                            endIndent:
                            185.0, // Set the right indent of the divider
                          ),
                          SizedBox(height: 10),
                          Card(
                            child: Column(
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: Text(
                                    "Order History",
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 10),
                                  child: SfCartesianChart(
                                    primaryYAxis: NumericAxis(),
                                    primaryXAxis: CategoryAxis(
                                      majorGridLines:
                                      MajorGridLines(color: Colors.white),
                                    ),
                                    legend: Legend(
                                      isVisible: true,
                                      position: LegendPosition.top,
                                      textStyle:
                                      TextStyle(color: Color(0xff636465)),
                                    ),
                                    series: generateSeries(),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          FutureBuilder<List<Map<String, dynamic>>?>(
                            future: data,
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return CircularProgressIndicator();
                              } else if (snapshot.hasError) {
                                return Text('Error: ${snapshot.error}');
                              } else if (!snapshot.hasData ||
                                  snapshot.data == null) {
                                return Text('No data available.');
                              } else {
                                List<Map<String, dynamic>> apiData =
                                snapshot.data!;
                                return ListView(
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  children: apiData.map((item) {
                                    return Card(
                                      color: Color(0xffF0F0F0),
                                      child: Column(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Padding(
                                            padding: const EdgeInsets.all(8),
                                            child: Row(
                                              mainAxisAlignment:
                                              MainAxisAlignment
                                                  .spaceBetween,
                                              children: <Widget>[
                                                Text(
                                                  '${item['name']}',
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Color(0xff01764a),
                                                    fontSize: 18.0,
                                                  ),
                                                ),
                                                Row(
                                                  children: <Widget>[
                                                    Icon(
                                                      FluentIcons
                                                          .clock_arrow_download_20_regular, // Choose the clock icon you prefer
                                                      color: Color(
                                                          0xff01764a), // Set the color of the clock icon
                                                      size: 16,
                                                    ),
                                                    SizedBox(
                                                      width: 5,
                                                    ),
                                                    Text(
                                                      '${item['update_time']}',
                                                      style: TextStyle(
                                                        fontWeight:
                                                        FontWeight.bold,
                                                        color:
                                                        Color(0xff01764a),
                                                        fontSize: 10,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Row(
                                              mainAxisAlignment:
                                              MainAxisAlignment
                                                  .spaceBetween,
                                              children: <Widget>[
                                                Text(
                                                  'Indent Price',
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Color(0xff01764a),
                                                  ),
                                                ),
                                                Text(
                                                  'Nozel Price',
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Color(0xff01764a),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                              left: 8.0,
                                              right: 8.0,
                                              bottom: 8.0,
                                            ),
                                            child: Row(
                                              mainAxisAlignment:
                                              MainAxisAlignment
                                                  .spaceBetween,
                                              children: <Widget>[
                                                Text(
                                                  'PKR: ${item['indent_price']}',
                                                  style: TextStyle(
                                                    color: Color(0xff01764a),
                                                  ),
                                                ),
                                                Text(
                                                  'PKR: ${item['nozel_price']}',
                                                  style: TextStyle(
                                                    color: Color(0xff01764a),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  }).toList(),
                                );
                              }
                            },
                          ),
                          /*
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
                                        'Indent Price',
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
                      SizedBox( height: 10,),
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
                  ),*/
                        ],
                      )),
                ),
                /*
                ClipRect(
                  child: Stack(children: [
                    Opacity(
                      opacity: 0.5,
                      child: Image.asset('assets/images/puma png.png'),
                    ),
                    Container(
                      child: Column(
                        children: [
                          ClipRRect(
                            child: Container(
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image:
                                      AssetImage('assets/images/puma png.png'),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 10, left: 10),
                                    child: CircleAvatar(
                                      backgroundColor: Color(0xffffffff),
                                      radius: 15,
                                      child: Text(
                                        '$initials',
                                        style: GoogleFonts.raleway(
                                          fontSize: 16,
                                          color: Colors.black,
                                          fontWeight: FontWeight.w700,
                                          fontStyle: FontStyle.normal,
                                        ),
                                      ), //Text
                                    ),
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                ],
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 40,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Card(
                                color: Color(0xff3a833c),
                                elevation: 20,
                                child: SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width / 1.25,
                                  height: 140,
                                  child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        //CircleAvatar
                                        const SizedBox(
                                          height: 10,
                                        ), //SizedBox
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              '$dealershipName',
                                              style: GoogleFonts.raleway(
                                                fontSize: 16,
                                                color: Color(0xffffffff),
                                                fontWeight: FontWeight.w500,
                                                fontStyle: FontStyle.normal,
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 1,
                                            ),
                                            Icon(
                                              Icons
                                                  .keyboard_arrow_down_outlined,
                                              color: Color(0xffffffff),
                                              size: 20.0,
                                            ),
                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              '$sap_no',
                                              style: GoogleFonts.raleway(
                                                fontSize: 16,
                                                color: Color(0xffffffff),
                                                fontWeight: FontWeight.w500,
                                                fontStyle: FontStyle.normal,
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 1,
                                            ),
                                            // Icon(
                                            //   Icons.keyboard_arrow_down_outlined,
                                            //   color: Color(0xffffffff),
                                            //   size: 20.0,
                                            // ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              'Current Balance',
                                              style: GoogleFonts.raleway(
                                                fontSize: 14,
                                                color: Color(0xffffffff),
                                                fontWeight: FontWeight.w500,
                                                fontStyle: FontStyle.normal,
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Row(
                                          children: [
                                            CircleAvatar(
                                                backgroundColor: Color(
                                                    0xffffffff), //0xff7DBDBD
                                                radius: 15,
                                                child: Icon(
                                                  FluentIcons.payment_32_filled,
                                                  color: Colors.grey,
                                                  size: 18,
                                                ) //Text
                                                ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  'PKR. ${account}',
                                                  style: GoogleFonts.raleway(
                                                    fontSize: 14,
                                                    color: Color(0xffffffff),
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                                Text(
                                                  'Updated On : ${formattedDate}',
                                                  style: GoogleFonts.raleway(
                                                    fontSize: 10,
                                                    color: Color(0xffffffff),
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
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment
                                .spaceEvenly, // Adjust alignment as needed
                            children: <Widget>[
                              Column(
                                children: <Widget>[
                                  Container(
                                    width: 100.0,
                                    height: 100.0,
                                    decoration: BoxDecoration(
                                      color: Colors
                                          .white, // Set your desired color
                                      borderRadius: BorderRadius.circular(
                                          10.0), // Adjust the radius as needed
                                    ),
                                    child: Column(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(4.0),
                                          child: GestureDetector(
                                            child: Container(
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                border: Border.all(
                                                  color: Color(
                                                      0xffec1b24), // Set the color of the border
                                                  width:
                                                      1, // Set the width of the border
                                                ),
                                              ),
                                              child: CircleAvatar(
                                                radius:
                                                    28, // Adjust the size of the circular avatar
                                                backgroundColor: Color(
                                                    0xffffffff), // You can set the background color
                                                child: Image.asset(
                                                  "assets/images/cargo (1).png",
                                                  width: 35,
                                                  height: 35,
                                                ),
                                              ),
                                            ),
                                            onTap: () {
                                              // Navigate to the OrderScreen when tapped
                                              Navigator.of(context).push(
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          Orders()));
                                            },
                                          ),
                                        ),
                                        Text(
                                          "Order",
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold),
                                        ), //Color(0xff01764a)
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                children: <Widget>[
                                  Container(
                                    width: 100.0,
                                    height: 100.0,
                                    decoration: BoxDecoration(
                                      color: Colors
                                          .white, // Set your desired color
                                      borderRadius: BorderRadius.circular(
                                          10.0), // Adjust the radius as needed
                                    ),
                                    child: Column(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(4.0),
                                          child: GestureDetector(
                                            child: Container(
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                border: Border.all(
                                                  color: Color(
                                                      0xffec1b24), // Set the color of the border
                                                  width:
                                                      1, // Set the width of the border
                                                ),
                                              ),
                                              child: CircleAvatar(
                                                radius:
                                                    28, // Adjust the size of the circular avatar
                                                backgroundColor: Color(
                                                    0xffffffff), // Color(0xff01764a),You can set the background color
                                                child: Image.asset(
                                                  'assets/images/engine-oil (3).png',
                                                  width: 38,
                                                  height: 38,
                                                ),
                                              ),
                                            ),
                                            onTap: () {
                                              // Navigate to the OrderScreen when tapped
                                              Navigator.of(context).push(
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          Lubricant()));
                                            },
                                          ),
                                        ),
                                        Text(
                                          "Lubricant",
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold),
                                        ), //Color(0xff01764a)
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                children: <Widget>[
                                  Container(
                                    width: 100.0,
                                    height: 100.0,
                                    decoration: BoxDecoration(
                                      color: Colors
                                          .white, // Set your desired color
                                      borderRadius: BorderRadius.circular(
                                          10.0), // Adjust the radius as needed
                                    ),
                                    child: Column(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(4.0),
                                          child: GestureDetector(
                                            child: Container(
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                border: Border.all(
                                                  color: Color(
                                                      0xffec1b24), // Set the color of the border
                                                  width:
                                                      1, // Set the width of the border
                                                ),
                                              ),
                                              child: CircleAvatar(
                                                radius:
                                                    28, // Adjust the size of the circular avatar
                                                backgroundColor: Color(
                                                    0xffffffff), //Color(0xff01764a),// You can set the background color
                                                child: Image.asset(
                                                  "assets/images/shirt1.png",
                                                  width: 38,
                                                  height: 38,
                                                ),
                                              ),
                                            ),
                                            onTap: () {
                                              // Navigate to the OrderScreen when tapped
                                              Navigator.of(context).push(
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          Uniform()));
                                            },
                                          ),
                                        ),
                                        Text(
                                          "Uniforms",
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold),
                                        ), //Color(0xff01764a)
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                        ],
                      ),
                    ),
                  ]),
                ),
                Align(
                  alignment: FractionalOffset.bottomCenter,
                  child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30.0),
                          topRight: Radius.circular(30.0),
                        ),
                      ),
                      margin: EdgeInsets.all(0),
                      child: Column(
                        children: [
                          Divider(
                            color: Color(
                                0x4f5d5d5d), // Set the color of the divider
                            height: 20.0, // Set the height of the divider
                            thickness: 5.0, // Set the thickness of the divider
                            indent: 185.0, // Set the left indent of the divider
                            endIndent:
                                185.0, // Set the right indent of the divider
                          ),
                          SizedBox(height: 10),
                          Card(
                            child: Column(
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: Text(
                                    "Order History",
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 10),
                                  child: SfCartesianChart(
                                    primaryYAxis: NumericAxis(),
                                    primaryXAxis: CategoryAxis(
                                      majorGridLines:
                                          MajorGridLines(color: Colors.white),
                                    ),
                                    legend: Legend(
                                      isVisible: true,
                                      position: LegendPosition.top,
                                      textStyle:
                                          TextStyle(color: Color(0xff636465)),
                                    ),
                                    series: generateSeries(),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          FutureBuilder<List<Map<String, dynamic>>?>(
                            future: data,
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return CircularProgressIndicator();
                              } else if (snapshot.hasError) {
                                return Text('Error: ${snapshot.error}');
                              } else if (!snapshot.hasData ||
                                  snapshot.data == null) {
                                return Text('No data available.');
                              } else {
                                List<Map<String, dynamic>> apiData =
                                    snapshot.data!;
                                return ListView(
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  children: apiData.map((item) {
                                    return Card(
                                      color: Color(0xffF0F0F0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Padding(
                                            padding: const EdgeInsets.all(8),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: <Widget>[
                                                Text(
                                                  '${item['name']}',
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Color(0xff01764a),
                                                    fontSize: 18.0,
                                                  ),
                                                ),
                                                Row(
                                                  children: <Widget>[
                                                    Icon(
                                                      FluentIcons
                                                          .clock_arrow_download_20_regular, // Choose the clock icon you prefer
                                                      color: Color(
                                                          0xff01764a), // Set the color of the clock icon
                                                      size: 16,
                                                    ),
                                                    SizedBox(
                                                      width: 5,
                                                    ),
                                                    Text(
                                                      '${item['update_time']}',
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color:
                                                            Color(0xff01764a),
                                                        fontSize: 10,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: <Widget>[
                                                Text(
                                                  'Indent Price',
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Color(0xff01764a),
                                                  ),
                                                ),
                                                Text(
                                                  'Nozel Price',
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Color(0xff01764a),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                              left: 8.0,
                                              right: 8.0,
                                              bottom: 8.0,
                                            ),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: <Widget>[
                                                Text(
                                                  'PKR: ${item['indent_price']}',
                                                  style: TextStyle(
                                                    color: Color(0xff01764a),
                                                  ),
                                                ),
                                                Text(
                                                  'PKR: ${item['nozel_price']}',
                                                  style: TextStyle(
                                                    color: Color(0xff01764a),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  }).toList(),
                                );
                              }
                            },
                          ),
                          /*
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
                                        'Indent Price',
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
                      SizedBox( height: 10,),
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
                  ),*/
                        ],
                      )),
                ),
                */
              ],
            ),
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
            unselectedLabelStyle:
                const TextStyle(color: Color(0xff8d8d8d), fontSize: 14),
            unselectedFontSize: 14,
            showUnselectedLabels: true,
            showSelectedLabels: true,
            selectedIconTheme: IconThemeData(
              color: Color(0xff12283D),
            ),
            type: BottomNavigationBarType.shifting,
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                  icon: Icon(
                    FluentIcons.home_32_regular,
                    size: 20,
                  ),
                  label: 'Home',
                  backgroundColor: Colors.white),
              BottomNavigationBarItem(
                  icon: Icon(
                    FluentIcons.weather_sunny_16_regular,
                    size: 20,
                  ),
                  label: 'Complaint',
                  backgroundColor: Colors.white),
              BottomNavigationBarItem(
                icon: Icon(
                  FluentIcons.inprivate_account_16_regular,
                  size: 20,
                ),
                label: 'Profile',
                backgroundColor: Colors.white,
              ),
            ],
            selectedItemColor: Color(0xff12283D),
            iconSize: 40,
            onTap: _onItemTapped,
            elevation: 15),
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
        MaterialPageRoute(builder: (context) => Complaints()),
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

class chartdata {
  final String x;
  final Map<String, int> data;

  chartdata(this.x, this.data);
}
