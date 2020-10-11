import 'dart:async';

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
      body: Container(
        child: ListView(

          children: <Widget>[
            Opacity(
                opacity: 1,
                child: Image.asset('assets/images/souq1624wpng.png')
            ),

            Shimmer.fromColors(
              period: Duration(milliseconds: 1800),
              baseColor: Color(0xffF26726),
              highlightColor: Color(0xffF26799),
              child: Container(
                padding: EdgeInsets.only(top: 100),
                child: Center(
                  child: Text(
                    "سوق الفرات سوق الجميع",
                      style: TextStyle(
                          fontSize: 35,
                          fontFamily: 'AmiriQuran',
                          fontWeight: FontWeight.w500,
                          //height: 1,
                        shadows: <Shadow>[
                          Shadow(
                              blurRadius: 55.0,
                              color: Colors.black87,
                              offset: Offset.fromDirection(120, 12)
                          )
                        ]
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }}