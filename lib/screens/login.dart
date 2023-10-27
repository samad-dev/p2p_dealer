import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
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
    if (_passwordController.text.toString() != '' &&
        _passwordController.text.toString() != '') {
      print('here');
      var request = http.Request('GET', Uri.parse(
          'http://151.106.17.246:8000/api/login/${email}/${password}'));
      http.StreamedResponse response = await request.send();
      final json = await response.stream.bytesToString();

      Map<String, dynamic> jsons = jsonDecode(json);
      print("Samad" + jsons.length.toString());
      if (jsons.length > 0) {
        if (jsons["role"] == 'Inspector') {
          final prefs = await SharedPreferences.getInstance();
          prefs.setBool('isLoggedIn', true);
          print(jsons['id']);
          prefs.setString("userId", jsons["id"].toString());
          prefs.setString("username", jsons["name"].toString());
          prefs.setString("email", jsons["email"].toString());
          prefs.setString("role", jsons["role"].toString());
          Navigator.pushReplacement<void, void>(
            context,
            MaterialPageRoute<void>(
              builder: (BuildContext context) => Home(),
            ),
          );
          // Navigator.pushNamed(context, 'Dashboard');
        }
        else {
          Fluttertoast.showToast(
              msg: "You are not Allowed to Login here",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.SNACKBAR,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 16.0
          );
        }
      } else {
        Fluttertoast.showToast(
            msg: "Incorrect Credentials Please Try Again",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.SNACKBAR,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0
        );
      }
    }
    else {
      Fluttertoast.showToast(
          msg: "Please Fill Credentials",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.SNACKBAR,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0
      );
    }
  }

  /*
  void initState() {
    super.initState();
    // getValue();
  }*/

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
                  child: SvgPicture.asset('assets/images/puma_logo2.svg'), // Replace with your image asset
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
                        decoration: InputDecoration(
                          filled: false,
                          hintText: 'Enter Email',
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
                            borderSide: BorderSide(width: 2,color: Colors.green.shade700),
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(width: 2, color: Colors.grey),
                          ),
                          labelText: 'Email',
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
                            borderSide: BorderSide(width:2,color: Colors.grey),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(width:2,color: Colors.green.shade700), // Color of the border
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
                                  ),
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                primary: Color(0xffe81329),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
                              ),
                              onPressed: () {
                               // _login(context);//
                                Navigator.pushReplacement<void, void>(
                                context,
                                MaterialPageRoute<void>(
                                builder: (BuildContext context) => Home(),
                                ),
                                );
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
                      'New to Puma Dealership? Register here ',
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
/*void getValue() async {
    var prefs = await SharedPreferences.getInstance();
    var getName = (prefs.getString("userId") ?? "");
    // nameValue = getName != null ? getName : "No Value Saved ";
    if (getName == "") {
      Timer(Duration(seconds: 3), () {

        Navigator.pushReplacement<void, void>(
          context,
          MaterialPageRoute<void>(
            builder: (BuildContext context) =>
                Home(),
          ),
        );
      });
    } else {
      Timer(Duration(seconds: 3), () {

        Navigator.pushReplacement<void, void>(
          context,
          MaterialPageRoute<void>(
            builder: (BuildContext context) =>
                MyHomePage(),
          ),
        );
      });

    }
    setState(() {

    });
  }*/
}