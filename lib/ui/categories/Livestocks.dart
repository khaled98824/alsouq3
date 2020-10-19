import 'dart:async';

import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:sooq1alzour/Auth/NewLogin.dart';
import 'package:sooq1alzour/models/PageRoute.dart';

import '../AddNewAd.dart';
import '../AllAds.dart';
import '../Home.dart';
import '../SerchData.dart';
import '../myAccount.dart';

class Livestock extends StatefulWidget {
  static const String id = "Livestock";

  @override
  _LivestockState createState() => _LivestockState();
}
String categoryName='المواشي';
String department ;
class _LivestockState extends State<Livestock> {
  var dropItemsLivestocks = [
    'إختر القسم الفرعي',
    'أغنام',
    'أبقار',
    "طيور",
    "أعلاف"
  ];
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: Text('المواشي',textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 28,
                    fontFamily: 'AmiriQuran',
                    height: 1)),
          ),
          body:  Container(
            child: ListView(
              children: <Widget>[
                Padding(padding: EdgeInsets.only(top: 10)),
                Heade(),
                SizedBox(height: 20,),
                InkWell(
                  onTap: () {
                    showSearch(
                        context: context,
                        delegate: SerchData(category: 'المواشي'));
                  },
                  child: Padding(
                    padding: EdgeInsets.only(right: 50,left: 50),
                    child: Container(
                      height: 42,
                      width: 340,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(40),
                          color: Colors.grey[350]),
                      child: Stack(
                        alignment: Alignment(screenSizeWidth2<412?-0.1:0.1, 0),
                        children: <Widget>[
                          Text('!... إبحث في قسم المواشي',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontFamily: 'AmiriQuran',
                                height: 1,
                              )),
                          Align(
                              alignment: Alignment(0.9, 0),
                              child: Icon(
                                Icons.search,
                                size: 30,
                              ))
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(padding: EdgeInsets.only(top: 150)),
                Container(
                  height:1,
                  width: MediaQuery.of(context).size.width - 8,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: Colors.red[900]),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 12, bottom:12),
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        department = dropItemsLivestocks[1];
                      });
                      Navigator.push(context, BouncyPageRoute(widget: Ads(department:department,category:categoryName)));
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Icon(
                          Icons.arrow_back_ios,
                          size: 36,
                        ),
                        Padding(
                          padding: EdgeInsets.only(right: 26),
                          child: Text(
                            'أغنام',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 30,
                                fontFamily: 'AmiriQuran',
                                height: 0.6),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  height: 1,
                  width: MediaQuery.of(context).size.width - 8,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: Colors.red[900]),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 12, bottom: 12),
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        department = dropItemsLivestocks[2];
                      });
                      Navigator.push(context, BouncyPageRoute(widget: Ads(department:department,category:categoryName)));
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Icon(
                          Icons.arrow_back_ios,
                          size: 36,
                        ),
                        Padding(
                          padding: EdgeInsets.only(right: 22),
                          child: Text(
                            'أبقار',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 30,
                                fontFamily: 'AmiriQuran',
                                height: 1),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  height:1,
                  width: MediaQuery.of(context).size.width - 8,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: Colors.red[900]),
                ),
                Padding(
                  padding: EdgeInsets.only(top:12, bottom:12),
                  child: InkWell(
                    onTap: () {
                      department = dropItemsLivestocks[3];
                      Navigator.push(context, BouncyPageRoute(widget: Ads(department:department,category:categoryName)));
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Icon(
                          Icons.arrow_back_ios,
                          size: 36,
                        ),
                        Padding(
                          padding: EdgeInsets.only(right: 16),
                          child: Text(
                            'طيور',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 30,
                                fontFamily: 'AmiriQuran',
                                height: 1),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  height:1,
                  width: MediaQuery.of(context).size.width - 8,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: Colors.red[900]),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 12, bottom:12),
                  child: InkWell(
                    onTap: () {
                      department = dropItemsLivestocks[4];
                      Navigator.push(context, BouncyPageRoute(widget: Ads(department:department,category:categoryName)));
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Icon(
                          Icons.arrow_back_ios,
                          size: 36,
                        ),
                        Padding(
                          padding: EdgeInsets.only(right: 30),
                          child: Text(
                            'أعلاف',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 30,
                                fontFamily: 'AmiriQuran',
                                height: 0.6),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  height:1,
                  width: MediaQuery.of(context).size.width - 8,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: Colors.red[900]),
                ),

              ],
            ),
          ),

        ),
      ],
    );
  }
}
