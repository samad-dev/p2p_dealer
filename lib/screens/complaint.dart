import 'dart:convert';

import 'package:dropdown_plus/dropdown_plus.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

class Create_Complaints extends StatefulWidget {
  static const Color contentColorOrange = Color(0xFF00705B);
  final Color leftBarColor = Color(0xFFCB6600);
  final Color rightBarColor = Color(0xFF5BECD2);
  @override
  _CreateComplaintState createState() => _CreateComplaintState();
}

class _CreateComplaintState extends State<Create_Complaints> {
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
      backgroundColor: Color(0xffffffff),
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
          'Complaint Form',
          style: GoogleFonts.raleway(
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
              /*
              children: [
                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Flexible(
                      child: SizedBox(
                        width: 150,
                        child: TextFormField(

                          onTapOutside: (value) {
                            print(value);
                          },
                          controller: hsdController,
                          keyboardType: TextInputType.name,
                          style: GoogleFonts.poppins(
                            color: Color(0xffa8a8a8),
                            fontWeight: FontWeight.w300,
                            fontSize: 16,
                            fontStyle: FontStyle.normal,
                          ),
                          decoration: InputDecoration(
                            hintStyle: GoogleFonts.poppins(
                              color: Color(0xffa8a8a8),
                              fontWeight: FontWeight.w300,
                              fontSize: 16,
                              fontStyle: FontStyle.normal,
                            ),
                            labelStyle: GoogleFonts.poppins(
                              color: Color(0xffa8a8a8),
                              fontWeight: FontWeight.w300,
                              fontSize: 16,
                              fontStyle: FontStyle.normal,
                            ),
                            filled: true,
                            fillColor: Color(0xffF1F4FF),
                            hintText: 'First Name',
                            focusedBorder: OutlineInputBorder(
                                borderSide:
                                BorderSide(width: 2, color: Color(0xff3b5fe0)),
                                borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                            border: OutlineInputBorder(
                                borderSide:
                                BorderSide(width: 2, color: Color(0xffF1F4FF)),
                                borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                            labelText: 'First Name',
                          ),
                        ),
                      ),
                    ),
                    Flexible(
                      child: SizedBox(
                        width: 150,
                        child: TextFormField(
                          onFieldSubmitted: (value) {
                            print(value);
                            setState(() {
                              hsdt = int.parse(value) * 350;
                            });
                          },
                          onTapOutside: (value) {
                            print(value);
                          },
                          controller: hsdController,
                          keyboardType: TextInputType.name,
                          style: GoogleFonts.poppins(
                            color: Color(0xffa8a8a8),
                            fontWeight: FontWeight.w300,
                            fontSize: 16,
                            fontStyle: FontStyle.normal,
                          ),
                          decoration: InputDecoration(
                            hintStyle: GoogleFonts.poppins(
                              color: Color(0xffa8a8a8),
                              fontWeight: FontWeight.w300,
                              fontSize: 16,
                              fontStyle: FontStyle.normal,
                            ),
                            labelStyle: GoogleFonts.poppins(
                              color: Color(0xffa8a8a8),
                              fontWeight: FontWeight.w300,
                              fontSize: 16,
                              fontStyle: FontStyle.normal,
                            ),
                            filled: true,
                            fillColor: Color(0xffF1F4FF),
                            hintText: 'Last Name',
                            focusedBorder: OutlineInputBorder(
                                borderSide:
                                BorderSide(width: 2, color: Color(0xff3b5fe0)),
                                borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                            border: OutlineInputBorder(
                                borderSide:
                                BorderSide(width: 2, color: Color(0xffF1F4FF)),
                                borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                            labelText: 'Last Name',
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 13,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: hobcController,
                    keyboardType: TextInputType.emailAddress,
                    style: GoogleFonts.poppins(
                      color: Color(0xffa8a8a8),
                      fontWeight: FontWeight.w300,
                      fontSize: 16,
                      fontStyle: FontStyle.normal,
                    ),
                    decoration: InputDecoration(
                      hintStyle: GoogleFonts.poppins(
                        color: Color(0xffa8a8a8),
                        fontWeight: FontWeight.w300,
                        fontSize: 16,
                        fontStyle: FontStyle.normal,
                      ),
                      labelStyle: GoogleFonts.poppins(
                        color: Color(0xffa8a8a8),
                        fontWeight: FontWeight.w300,
                        fontSize: 16,
                        fontStyle: FontStyle.normal,
                      ),
                      filled: true,
                      fillColor: Color(0xffF1F4FF),
                      hintText: 'Email Address',
                      focusedBorder: OutlineInputBorder(
                          borderSide:
                          BorderSide(width: 2, color: Color(0xff3b5fe0)),
                          borderRadius:
                          BorderRadius.all(Radius.circular(10))),
                      border: OutlineInputBorder(
                          borderSide:
                          BorderSide(width: 2, color: Color(0xffF1F4FF)),
                          borderRadius:
                          BorderRadius.all(Radius.circular(10))),
                      labelText: 'Email Address',
                    ),
                  ),
                ),
                SizedBox(
                  height: 13,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(

                    controller: hobcController,
                    keyboardType: TextInputType.number,
                    style: GoogleFonts.poppins(
                      color: Color(0xffa8a8a8),
                      fontWeight: FontWeight.w300,
                      fontSize: 16,
                      fontStyle: FontStyle.normal,
                    ),
                    decoration: InputDecoration(
                      hintStyle: GoogleFonts.poppins(
                        color: Color(0xffa8a8a8),
                        fontWeight: FontWeight.w300,
                        fontSize: 16,
                        fontStyle: FontStyle.normal,
                      ),
                      labelStyle: GoogleFonts.poppins(
                        color: Color(0xffa8a8a8),
                        fontWeight: FontWeight.w300,
                        fontSize: 16,
                        fontStyle: FontStyle.normal,
                      ),
                      filled: true,
                      fillColor: Color(0xffF1F4FF),
                      hintText: 'Phone Number',
                      focusedBorder: OutlineInputBorder(
                          borderSide:
                          BorderSide(width: 2, color: Color(0xff3b5fe0)),
                          borderRadius:
                          BorderRadius.all(Radius.circular(10))),
                      border: OutlineInputBorder(
                          borderSide:
                          BorderSide(width: 2, color: Color(0xffF1F4FF)),
                          borderRadius:
                          BorderRadius.all(Radius.circular(10))),
                      labelText: 'Phone Number',
                    ),
                  ),
                ),
                SizedBox(
                  height: 13,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(

                    controller: hobcController,
                    keyboardType: TextInputType.multiline,
                    style: GoogleFonts.poppins(
                      color: Color(0xffa8a8a8),
                      fontWeight: FontWeight.w300,
                      fontSize: 16,
                      fontStyle: FontStyle.normal,
                    ),
                    decoration: InputDecoration(
                      hintStyle: GoogleFonts.poppins(
                        color: Color(0xffa8a8a8),
                        fontWeight: FontWeight.w300,
                        fontSize: 16,
                        fontStyle: FontStyle.normal,
                      ),
                      labelStyle: GoogleFonts.poppins(
                        color: Color(0xffa8a8a8),
                        fontWeight: FontWeight.w300,
                        fontSize: 16,
                        fontStyle: FontStyle.normal,
                      ),
                      filled: true,
                      fillColor: Color(0xffF1F4FF),
                      hintText: 'Please Describe Briefly',
                      focusedBorder: OutlineInputBorder(
                          borderSide:
                          BorderSide(width: 2, color: Color(0xff3b5fe0)),
                          borderRadius:
                          BorderRadius.all(Radius.circular(10))),
                      border: OutlineInputBorder(
                          borderSide:
                          BorderSide(width: 2, color: Color(0xffF1F4FF)),
                          borderRadius:
                          BorderRadius.all(Radius.circular(10))),
                      labelText: 'Please Describe Briefly',
                    ),
                  ),
                ),
                SizedBox(
                  height: 13,
                ),
                Padding(
                  padding: EdgeInsets.only(top: 20),
                  child: MaterialButton(
                    onPressed: () {
                      var amount = hsdt + pmgt + hobct;
                    },
                    child: Text(
                      'Create Complaint',
                      style: TextStyle(
                          fontSize: 15,
                          fontFamily: 'SFUIDisplay',
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                    color: Color(0xff12283d),
                    elevation: 0,
                    minWidth: 350,
                    height: 60,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50)),
                  ),
                ),
              ],
              */
              children: [
                Card(
                  elevation: 5,
                  child: Padding(padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text(
                            'Complaint  Form',
                            style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                          ),
                        ),
                        TextDropdownFormField(
                          options:["Signage", "Lightning", "Fuel Dispenser", "DG Set", "Air Compressor", "Pump Controller"
                              "Electrical", "Civil Works", "C Store", "Miscellaneous"],
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(18.0),
                            ),
                            suffixIcon: Icon(Icons.arrow_drop_down_circle_outlined),
                            labelText: "Object Part",
                          ),
                          dropdownHeight: 220,
                        ),
                        SizedBox(height:18,),
                        TextDropdownFormField(
                          options: ["Canopy Fascia", "Monolith", "In/Out Sign", "Flat Sign", "Directory Sign", "Spreaders"],
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(18.0),
                            ),
                            suffixIcon: Icon(Icons.arrow_drop_down_circle_outlined),
                            labelText: "Damage Overview",
                          ),
                          dropdownHeight: 220,
                        ),
                        SizedBox(height:18,),
                        Row(
                          children: [
                            Expanded(
                              child: TextField(
                                decoration: InputDecoration(
                                  labelText: 'Damage',
                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(18.0),),

                                ),
                              ),
                            ),
                            SizedBox(width: 10), // Add some spacing between the two text fields
                            Expanded(
                              child: TextField(
                                decoration: InputDecoration(
                                  labelText: 'Text',
                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(18.0),),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height:18,),
                        TextField(
                          decoration: InputDecoration(
                            labelText: 'Cause Text',
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(18.0),),

                          ),
                        ),
                        SizedBox(height:18,),
                        Container(
                          child:Row(
                            children: [
                              Expanded(
                                child: ElevatedButton(
                                  child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Text(
                                      'Placed Complaint',
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
    var res = await http.get(Uri.parse(
        "http://151.106.17.246:8080/hascol/api/dealer_depot.php?accesskey=12345&user_id=3"));
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
