import 'dart:convert';

import 'package:dropdown_plus/dropdown_plus.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

class Create_Order_Uniform extends StatefulWidget {
  static const Color contentColorOrange = Color(0xFF00705B);
  final Color leftBarColor = Color(0xFFCB6600);
  final Color rightBarColor = Color(0xFF5BECD2);
  @override
  _CreateOrderUniformState createState() => _CreateOrderUniformState();
}

class _CreateOrderUniformState extends State<Create_Order_Uniform> {
  int hsd = 350;
  int hobc = 330;
  int pmg = 332;
  int hsdt = 0;
  int hobct = 0;
  int pmgt = 0;
  List data = [];
  String? _mySelection;
  TextEditingController hsdController = new TextEditingController();
  TextEditingController pmgController = new TextEditingController();
  TextEditingController hobcController = new TextEditingController();
  TextEditingController depotController = new TextEditingController();
  TextEditingController tlController = new TextEditingController();
  var _site = "Self";

  @override
  void initState() {
    super.initState();
    this.getDepot();
  }

  int _selectedIndex = 1;
  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('EEE d MMM kk:mm:ss').format(now);
    return Scaffold(
      backgroundColor: Color(0xffefeded),
      appBar: AppBar(
        titleSpacing: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back_ios),
          //replace with our own icon data.
        ),
        iconTheme: IconThemeData(
          color: Colors.black, //change your color here
        ),
        backgroundColor: Colors.white,
        elevation: 10,
        title: Text(
          'Uniform',
          style: GoogleFonts.montserrat(
              fontWeight: FontWeight.w700,
              fontStyle: FontStyle.normal,
              color: Color(0xff12283D),
              fontSize: 16),
        ),
      ),
      body: SingleChildScrollView(
          child: Container(
        padding: EdgeInsets.only(left:8,top: 60,right: 8),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Card(
                  elevation: 5,
                  child: Padding(padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text(
                            'Uniform Details',
                            style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                          ),
                        ),
                        SizedBox( height: 10,),
                        TextDropdownFormField(
                          options: ["Pump attendant", "Winter jacket", "Bay the Way"],
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(18.0),
                            ),
                            suffixIcon: Icon(Icons.arrow_drop_down_circle_outlined),
                            labelText: "Select uniform type",
                          ),
                          dropdownHeight: 160,
                        ),
                        SizedBox( height: 10,),
                        Row(
                          children: [
                            Expanded(
                              child: TextField(
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  labelText: 'Quantity for Small',
                                  border: OutlineInputBorder(),
                                  hintText: '0',
                                ),
                              ),
                            ),
                            SizedBox(width: 10), // Add some spacing between the two text fields
                            Expanded(
                              child: TextField(
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  labelText: 'Quantity for Medium',
                                  border: OutlineInputBorder(),
                                  hintText: '0',
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox( height: 10,),
                        Row(
                          children: [
                            Expanded(
                              child: TextField(
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  labelText: 'Quantity for Large',
                                  border: OutlineInputBorder(),
                                  hintText: '0',
                                ),
                              ),
                            ),
                            SizedBox(width: 10), // Add some spacing between the two text fields
                            Expanded(
                              child: TextField(
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  labelText: 'Quantity for Extra Large',
                                  border: OutlineInputBorder(),
                                  hintText: '0',
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox( height: 10,),
                        Container(
                          child:Row(
                            children: [
                              Expanded(
                                child: ElevatedButton(
                                  child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Text(
                                      'Confirmed Order',
                                      style: GoogleFonts.raleway(
                                        fontWeight: FontWeight.w700,
                                        fontStyle: FontStyle.normal,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                  onPressed: () {
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

              ],
        ),
      )),
    );
  }

  Future<String> getDepot() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var user_id = await sharedPreferences.getString("userId");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var id = prefs.getString("Id");
    var res = await http.get(Uri.parse(
        "http://151.106.17.246:8080/hascol/api/dealer_depot.php?accesskey=12345&user_id=$id"));
    var resBody = json.decode(res.body);

    setState(() {
      data = resBody;
      print(data.length);
    });

    // print(data[0]["id"]);
    // print("Sapcode " + code.toString());

    return Future.value("Data download successfully");
  }
}
