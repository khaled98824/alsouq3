import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sooq1alzour/Auth/NewLogin.dart';
import 'package:sooq1alzour/models/PageRoute.dart';
import 'Home.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState(){
    super.initState();
    Timer(Duration(seconds: 3),(){
      goPage();
    });

  }

int loginOrHome;
  goPage()async{
    SharedPreferences sharedPref = await SharedPreferences.getInstance();
    if(sharedPref.getInt('navigatorSelect')==null){
      //sharedPref.setInt('navigatorSelect', 0);
     Navigator.pushReplacement(context, BouncyPageRoute(widget: Home()));
    }else if(sharedPref.getInt('navigatorSelect')==1){
      Navigator.pushReplacement(context, BouncyPageRoute(widget: NewLogin()));
    }else if (sharedPref.getInt('navigatorSelect')==2){

    }
    setState(() {
      loginOrHome =sharedPref.getInt('navigatorSelect');
    });

    print('k${sharedPref.getBool('autoLogin')}');
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body:Image.asset('assets/images/alsouq-poster.jpg',
          fit: BoxFit.fill,
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height)
    );
  }}