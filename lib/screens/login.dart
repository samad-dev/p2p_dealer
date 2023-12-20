import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import '../utils/constants.dart';
import 'home.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../models/user.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  user? _user;

  Future<void> _login(BuildContext context) async {
    final email = _emailController.text;
    final password = _passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      Fluttertoast.showToast(
          msg: "Please Fill Credentials",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.SNACKBAR,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0
      );
      return;
    }

    final url = Uri.parse(
        'http://151.106.17.246:8080/OMCS-CMS-APIS/get/dealer_login.php?key=03201232927&username=$email&password=$password');

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final jsons = json.decode(response.body);

      if (jsons.isNotEmpty) {
        final prefs = await SharedPreferences.getInstance();
        prefs.setBool('isLoggedIn', true);
        print(jsons[0]['name']);
        prefs.setString("Id", jsons[0]["id"]);
        prefs.setString("name", jsons[0]["name"].toString());
        prefs.setString("contact", jsons[0]["contact"].toString());
        prefs.setString("email", jsons[0]["email"].toString());
        prefs.setString("location", jsons[0]["location"].toString());
        prefs.setString("co_ordinates", jsons[0]["co_ordinates"].toString());
        prefs.setString("housekeeping", jsons[0]["housekeeping"].toString());
        prefs.setString("no_lorries", jsons[0]["no_lorries"].toString());
        prefs.setString("type", jsons[0]["type"].toString());
        prefs.setString("banner", jsons[0]["banner"].toString());
        prefs.setString("logo", jsons[0]["logo"].toString());
        prefs.setString("indent_price", jsons[0]["indent_price"].toString());
        prefs.setString("Nozel_price", jsons[0]["Nozel_price"].toString());
        prefs.setString("sap_no", jsons[0]["sap_no"].toString());
        Navigator.pushReplacement<void, void>(context,MaterialPageRoute<void>(builder: (BuildContext context) => Home(),),);
      } else {
        // Incorrect credentials
        Fluttertoast.showToast(
            msg: "Incorrect Credentials. Please Try Again",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.SNACKBAR,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0
        );
      }
    } else {
      // Handle the HTTP error
      Fluttertoast.showToast(
          msg: "HTTP Request Failed",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.SNACKBAR,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0
      );
    }
  }

  void initState() {
    super.initState();
    // getValue();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff000000),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.only(top: 150),
            child: Column(
              children: [
                Container(
                  alignment: Alignment.topLeft,
                  padding: EdgeInsets.only(left: 8.0),
                  child: Image.asset('assets/images/P2P Track Logo.png', width: 300,), // Replace with your image asset
                ),
                SizedBox(height: 60,),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    /*
                    Container(
                      child: Text(
                        'Login Here',
                        style: GoogleFonts.poppins(
                          textStyle: Theme
                              .of(context)
                              .textTheme
                              .displayLarge,
                          fontSize: 22,
                          color: Color(0xff1F41BB),
                          fontWeight: FontWeight.w700,
                          fontStyle: FontStyle.normal,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      child: Text(
                        'Welcome Back You`ve',
                        style: GoogleFonts.poppins(
                          textStyle: Theme
                              .of(context)
                              .textTheme
                              .displayLarge,
                          fontSize: 14,
                          color: Color(0xff000000),
                          fontWeight: FontWeight.w700,
                          fontStyle: FontStyle.normal,
                        ),
                      ),
                    ),
                    Container(
                      child: Text(
                        'been missed!',
                        style: GoogleFonts.poppins(
                          textStyle: Theme
                              .of(context)
                              .textTheme
                              .displayLarge,
                          fontSize: 14,
                          color: Color(0xff000000),
                          fontWeight: FontWeight.w700,
                          fontStyle: FontStyle.normal,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),

                     */
                    Container(
                      padding: EdgeInsets.only(left: 38, right: 38),
                      child: TextField(
                        controller: _emailController,
                        style: GoogleFonts.raleway(
                          color: Color(0xffffffff),
                          fontWeight: FontWeight.w300,
                          fontSize: 16,
                          fontStyle: FontStyle.normal,
                        ),
                        keyboardType: TextInputType.phone, // Set the input type to phone.
                        decoration: InputDecoration(
                          filled: false,
                          hintText: 'Enter Phone Number',
                          hintStyle: GoogleFonts.raleway(
                            color: Color(0xffa8a8a8),
                            fontWeight: FontWeight.w300,
                            fontSize: 16,
                            fontStyle: FontStyle.normal,
                          ),
                          labelStyle: GoogleFonts.raleway(
                            color: Color(0xffffffff),
                            fontWeight: FontWeight.w300,
                            fontSize: 16,
                            fontStyle: FontStyle.normal,
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(width: 2, color: Constants.primary_color),
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(width: 2, color: Colors.grey),
                          ),
                          labelText: 'Phone Number',
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      padding: EdgeInsets.only(left: 38, right: 38),
                      child: TextField(
                        controller: _passwordController,
                        style: GoogleFonts.raleway(
                          color: Color(0xffffffff),
                          fontWeight: FontWeight.w300,
                          fontSize: 16,
                          fontStyle: FontStyle.normal,
                        ),
                        obscureText: true,
                        decoration: InputDecoration(
                          hintText: 'Enter Password',
                          hintStyle:GoogleFonts.raleway(
                            color: Color(0xff9d9d9d),
                            fontSize: 16,
                          ),
                          filled: false,
                          labelText: 'Password',
                          labelStyle: GoogleFonts.raleway(
                            color: Color(0xffffffff),
                            fontSize: 16,
                          ),
                          contentPadding: EdgeInsets.symmetric(vertical: 15), // Adjust padding as needed
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(width:2,color: Color(0xff9d9d9d)),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(width:2,color: Constants.primary_color), // Color of the border
                          ),
                        ),
                      ),
                    ),



                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      alignment: Alignment.centerLeft,
                      padding: EdgeInsets.only(left: 40),
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: Colors.white, // Color of the underline
                              width: 1.0, // Width of the underline
                            ),
                          ),
                        ),
                        child: Text(
                          'Forget Password?',
                          style: GoogleFonts.poppins(
                            textStyle: Theme.of(context).textTheme.displayLarge,
                            fontSize: 14,
                            color: Color(0xFFFFFFFF),
                            fontWeight: FontWeight.w600,
                            fontStyle: FontStyle.normal,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      padding: EdgeInsets.only(left: 38, right: 38),
                      child:Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Text(
                                  'Login',
                                  style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.w700,
                                    fontStyle: FontStyle.normal,
                                    fontSize: 16,
                                    color: Colors.white
                                  ),
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor:Constants.primary_color,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
                              ),
                              onPressed: () {
                               _login(context);
                               //Navigator.pushReplacement<void, void>(context,MaterialPageRoute<void>(builder: (BuildContext context) => Home(),),);
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height:30),
                Container(
                  alignment: Alignment.center,
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: Colors.white, // Color of the underline
                          width: 1.0, // Width of the underline
                        ),
                      ),
                    ),
                    child: Text(
                      'New to P2P Dealership? Register here ',
                      style: GoogleFonts.poppins(
                        textStyle: Theme.of(context).textTheme.displayLarge,
                        fontSize: 14,
                        color: Color(0xFFFFFFFF),
                        fontWeight: FontWeight.w600,
                        fontStyle: FontStyle.normal,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}