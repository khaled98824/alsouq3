import 'dart:async';
import 'dart:ui';
import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:sooq1alzour/Auth/NewLogin.dart';
import 'package:sooq1alzour/Service/PushNotificationService.dart';
import 'package:sooq1alzour/models/AdsModel.dart';
import 'package:sooq1alzour/models/PageRoute.dart';
import 'package:sooq1alzour/models/StaticVirables.dart';
import 'package:sooq1alzour/ui/AddNewAd.dart';
import 'package:sooq1alzour/ui/AllAds.dart';
import 'package:sooq1alzour/ui/SerchData.dart';
import 'package:sooq1alzour/ui/ShowAds.dart';
import 'package:sooq1alzour/ui/categories/Cars&MotorCycles.dart';
import 'package:sooq1alzour/ui/categories/Clothes.dart';
import 'package:sooq1alzour/ui/categories/DevicesAndElectronics.dart';
import 'package:sooq1alzour/ui/categories/Farming.dart';
import 'package:sooq1alzour/ui/categories/Food.dart';
import 'package:sooq1alzour/ui/categories/Games.dart';
import 'package:sooq1alzour/ui/categories/Homes.dart';
import 'package:sooq1alzour/ui/categories/Livestocks.dart';
import 'package:sooq1alzour/ui/categories/Mobile.dart';
import 'package:sooq1alzour/ui/categories/OccupationsAndServices.dart';
import 'myAccount.dart';

class Home extends StatefulWidget {
  static const String id = "Home";
  @override
  _HomeState createState() => _HomeState();
}

List<AdsModel> allList = List();
var icons1 = Icons.burst_mode;
var icons2 = Icons.home;
var adImagesUrlF = List<dynamic>();
bool showSliderAds = false;

final List<String> _listItem = [
  'assets/images/Elct2.jpg',
  'assets/images/cars.jpg',
  'assets/images/mobile3.jpg',
  'assets/images/jobs3.jpg',
  'assets/images/SERV3.jpg',
  'assets/images/home3.jpg',
  'assets/images/trucks3.jpg',
  'assets/images/farm7.jpg',
  'assets/images/farming3.jpg',
  'assets/images/game.jpg',
  'assets/images/clothes.jpg',
  'assets/images/food.jpg',
];

bool categoryOrAds = true;

class _HomeState extends State<Home> {
  final PushNotificationService _pushNotificationService =
      GetIt.I<PushNotificationService>();
  bool buttonPressed1 = false;
  bool buttonPressed2 = false;
  void _letsPress1() {
    setState(() {
      buttonPressed1 = true;
      buttonPressed2 = false;
      categoryOrAds = false;
    });
  }

  void _letsPress2() {
    setState(() {
      categoryOrAds = true;

      buttonPressed1 = false;
      buttonPressed2 = true;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUrlsForAds();
    Timer(Duration(microseconds: 500), () {
      getUserData();
    });
    _pushNotificationService.initialise();
  }

  getUserData() async {
    var firestore = Firestore.instance;
    QuerySnapshot qus = await firestore.collection('users').getDocuments();
    if (qus == null) {
      setState(() {
        checkLogin = false;
        loginStatus = false;
        print('object');
      });
    } else {
      setState(() {
        checkLogin = true;
      });
      print('checkLogincc${qus.documents[0]['name']}');
    }
  }

  getUrlsForAds() async {
    DocumentReference documentRef = Firestore.instance
        .collection('UrlsForAds')
        .document('gocqpQlhow2tfetqlGpP');
    documentsAds = await documentRef.get();
    adImagesUrlF = documentsAds.data['urls'];
    setState(() {
      showSliderAds = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    Virables.screenSizeWidth = screenSizeWidth2;
    Virables.screenSizeHeight = screenSizeHieght2;
    screenSizeWidth2 = MediaQuery.of(context).size.width;
    screenSizeHieght2 = MediaQuery.of(context).size.height;
    return Stack(
      children: <Widget>[
        Scaffold(
          backgroundColor: Colors.grey[200],
          body: SafeArea(
              child: Column(
            children: <Widget>[
              Padding(padding: EdgeInsets.only(top: 0)),
              Heade(),
              SizedBox(
                height: 3,
              ),
              SearchAreaDesign(),
              Padding(padding: EdgeInsets.only(top: 3)),
              Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                alignment: WrapAlignment.spaceAround,
                children: <Widget>[
                  SizedBox(
                    width: 170,
                    child: GestureDetector(
                        // FIRST BUTTON
                        onTap: _letsPress1,
                        child: buttonPressed1
                            ? ButtonTapped(
                                icon: icons1,
                                btnState: 1,
                              )
                            : MyButton(
                                icon: icons1,
                                btnState: 1,
                              )),
                  ),
                  SizedBox(
                    width: 170,
                    child: GestureDetector(
                        // FIRST BUTTON
                        onTap: _letsPress2,
                        child: buttonPressed2
                            ? ButtonTapped(
                                icon: icons2,
                                btnState: 0,
                              )
                            : MyButton(
                                icon: icons2,
                                btnState: 0,
                              )),
                  ),
                ],
              ),
              Padding(
                  padding: EdgeInsets.only(
                top: 7,
              )),
              showSliderAds ? areaForAd() : Container(),

              categoryOrAds
                  ? Expanded(
                      child: SingleChildScrollView(
                        child: Container(
                          child: Column(
                            children: <Widget>[
                              Wrap(
                                crossAxisAlignment: WrapCrossAlignment.center,
                                alignment: WrapAlignment.spaceAround,
                                children: <Widget>[
                                  GridViewItems(
                                      text: "أجهزة - إلكترونيات",
                                      imagePath: _listItem[0],
                                      callback: () {
                                        Navigator.of(context).pushNamed(
                                            DevicesAndElectronics.id);
                                      }),
                                  GridViewItems(
                                    text: "السيارات - الدراجات",
                                    imagePath: _listItem[1],
                                    callback: () {
                                      Navigator.of(context)
                                          .pushNamed(CarsAndMotorCycles.id);
                                    },
                                  )
                                ],
                              ),
                              Wrap(
                                crossAxisAlignment: WrapCrossAlignment.center,
                                alignment: WrapAlignment.spaceAround,
                                children: <Widget>[
                                  GridViewItems(
                                    text: "الموبايل",
                                    imagePath: _listItem[2],
                                    callback: () {
                                      Navigator.of(context)
                                          .pushNamed(Mobile.id);
                                    },
                                  ),
                                  GridViewItems(
                                    text: "وظائف وأعمال",
                                    imagePath: _listItem[3],
                                    callback: () {
                                      Navigator.push(
                                          context,
                                          BouncyPageRoute(
                                              widget: Ads(
                                                  department: 'وظائف وأعمال',
                                                  category: 'وظائف وأعمال')));
                                    },
                                  )
                                ],
                              ),
                              Wrap(
                                crossAxisAlignment: WrapCrossAlignment.center,
                                alignment: WrapAlignment.spaceAround,
                                children: <Widget>[
                                  GridViewItems(
                                    text: "مهن وخدمات",
                                    imagePath: _listItem[4],
                                    callback: () {
                                      Navigator.of(context)
                                          .pushNamed(OccupationsAndServices.id);
                                    },
                                  ),
                                  GridViewItems(
                                    text: "المنزل",
                                    imagePath: _listItem[5],
                                    callback: () {
                                      Navigator.of(context).pushNamed(Homes.id);
                                    },
                                  )
                                ],
                              ),
                              Wrap(
                                crossAxisAlignment: WrapCrossAlignment.center,
                                alignment: WrapAlignment.spaceAround,
                                children: <Widget>[
                                  GridViewItems(
                                    text: "المعدات والشاحنات",
                                    imagePath: _listItem[6],
                                    callback: () {
                                      Navigator.push(
                                          context,
                                          BouncyPageRoute(
                                              widget: Ads(
                                            department: "المعدات والشاحنات",
                                            category: "المعدات والشاحنات",
                                          )));
                                    },
                                  ),
                                  GridViewItems(
                                    text: "المواشي",
                                    imagePath: _listItem[7],
                                    callback: () {
                                      Navigator.of(context)
                                          .pushNamed(Livestock.id);
                                    },
                                  )
                                ],
                              ),
                              Wrap(
                                crossAxisAlignment: WrapCrossAlignment.center,
                                alignment: WrapAlignment.spaceAround,
                                children: <Widget>[
                                  GridViewItems(
                                    text: "الزراعة",
                                    imagePath: _listItem[8],
                                    callback: () {
                                      Navigator.of(context)
                                          .pushNamed(Farming1.id);
                                    },
                                  ),
                                  GridViewItems(
                                    text: "ألعاب",
                                    imagePath: _listItem[9],
                                    callback: () {
                                      Navigator.of(context).pushNamed(Games.id);
                                    },
                                  )
                                ],
                              ),
                              Wrap(
                                crossAxisAlignment: WrapCrossAlignment.center,
                                alignment: WrapAlignment.spaceAround,
                                children: <Widget>[
                                  GridViewItems(
                                    text: "ألبسة",
                                    imagePath: _listItem[10],
                                    callback: () {
                                      Navigator.of(context)
                                          .pushNamed(Clothes.id);
                                    },
                                  ),
                                  GridViewItems(
                                    text: "أطعمة",
                                    imagePath: _listItem[11],
                                    callback: () {
                                      Navigator.of(context).pushNamed(Food.id);
                                    },
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  : Expanded(
                      child: Container(
                          child: Padding(
                      padding: EdgeInsets.only(top: 12),
                      child: Stack(
                        children: <Widget>[
                          Align(
                            alignment: Alignment(1, -1.1),
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: 13, horizontal: 4),
                              child: Card(
                                child: Padding(
                                  padding: EdgeInsets.only(
                                      bottom: 6, top: 6, right: 30, left: 30),
                                  child: Text(
                                    'أحدث الإعلانات',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontFamily: 'AmiriQuran',
                                        height: 1),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                              padding: EdgeInsets.only(top: 30),
                              child: NewAds()),
                        ],
                      ),
                    ))),
            ],
          )),
          bottomNavigationBar: CurvedNavigationBar(
              color: Color(0xffF26726),
              backgroundColor: Colors.orange,
              buttonBackgroundColor: Colors.white,
              animationDuration: Duration(milliseconds: 300),
              height: 66,
              animationCurve: Curves.bounceInOut,
              index: 2,
              onTap: (index) {
                Timer(Duration(milliseconds: 300), () {
                  if (index == 0) {
                    if (loginStatus) {
                      Navigator.of(context).pushNamed(MyAccount.id);
                    } else {
                      print('no dd');
                      Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (context) {
                        return NewLogin(
                          autoLogin: false,
                        );
                      }));
                    }
                  } else if (index == 1) {
                    if (loginStatus) {
                      Navigator.of(context).pushNamed(AddNewAd.id);
                    } else {
                      loginStatus = false;
                      print('no');
                      Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (context) {
                        return NewLogin(
                          autoLogin: false,
                        );
                      }));
                    }
                  }
                });
              },
              items: <Widget>[
                Icon(
                  Icons.person,
                  color: Colors.blue[900],
                  size: 29,
                ),
                Icon(
                  Icons.add_photo_alternate,
                  color: Colors.blue[900],
                  size: 31,
                ),
                Icon(
                  Icons.home,
                  size: 32,
                  color: Colors.blue[900],
                ),
              ]),
        ),
        Align(
          alignment: Alignment(1, 1),
          child: Padding(
            padding: EdgeInsets.symmetric(
                vertical: 10, horizontal: screenSizeWidth2 < 400 ? 38 : 49),
            child: Text(
              'الرئيسية',
              style: TextStyle(
                  fontSize: 15,
                  color: Colors.white,
                  decoration: TextDecoration.none,
                  fontFamily: 'AmiriQuran',
                  height: 1),
            ),
          ),
        ),
        Align(
          alignment: Alignment(-1, 1),
          child: Padding(
            padding: EdgeInsets.symmetric(
                vertical: 10, horizontal: screenSizeWidth2 < 400 ? 40 : 51),
            child: Text(
              'حسابي',
              style: TextStyle(
                  fontSize: 15,
                  color: Colors.white,
                  decoration: TextDecoration.none,
                  fontFamily: 'AmiriQuran',
                  height: 1),
            ),
          ),
        ),
        Align(
          alignment: Alignment(-0.1, 1),
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 40),
            child: Text(
              'أضف إعلان',
              style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                  decoration: TextDecoration.none,
                  fontFamily: 'AmiriQuran',
                  height: 1),
            ),
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }
}

Widget Heade() {
  return Column(
    children: <Widget>[
      Container(
          child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          screenSizeWidth2 < 380
              ? SizedBox(
                  width: 5,
                )
              : SizedBox(
                  width: 8,
                ),
          Text(
            'بيع واشتري كل ما تريد بكل سهولة',
            style: TextStyle(
              color: Colors.black,
              fontSize: 18,
              fontFamily: 'AmiriQuran',
              height: 1,
            ),
          ),
          Padding(
              padding: EdgeInsets.only(
                  right: screenSizeWidth2 < 380 ? 11 : 28, left: 2),
              child: Image.asset(
                'assets/images/logo.png',
                height: 51,
                width: 102,
                fit: BoxFit.fill,
              ))
        ],
      )),
    ],
  );
}

class SearchAreaDesign extends StatefulWidget {
  @override
  _SearchAreaDesignState createState() => _SearchAreaDesignState();
}

class _SearchAreaDesignState extends State<SearchAreaDesign> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        showSearch(context: context, delegate: SerchData());
      },
      child: Padding(
        padding: EdgeInsets.only(right: 10, left: 10),
        child: Container(
          height: 37,
          width: 330,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(40), color: Colors.grey[400]),
          child: Stack(
            alignment: Alignment(0.3, 0),
            children: <Widget>[
              Text('!... إبحث في سوق الفرات',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
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
    );
  }
}

class ButtonTapped extends StatelessWidget {
  var icon;
  int btnState;

  ButtonTapped({Key key, this.icon, this.btnState}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(6),
      child: Container(
        padding: EdgeInsets.all(5),
        child: Container(
          width: 90,
          height: 46,
          //padding: EdgeInsets.all(16),
          child: Wrap(
            children: <Widget>[
              Align(
                alignment: Alignment(0.9, 0),
                child: Icon(
                  icon,
                  size: 30,
                  color: Color(0xffF26726),
                ),
              ),
              Align(
                alignment: Alignment(-0.2, 0),
                child: btnState == 1
                    ? Text(
                        'الإعلانات',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 24,
                          fontFamily: 'AmiriQuran',
                          height: 0,
                        ),
                      )
                    : Text(
                        'الأقسام',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 24,
                          fontFamily: 'AmiriQuran',
                          height: 0,
                        ),
                      ),
              )
            ],
          ),

          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.grey[300],
              boxShadow: [
                BoxShadow(
                    color: Colors.white,
                    offset: Offset(0.5, 0.5),
                    spreadRadius: 3.0),
                BoxShadow(
                  color: Colors.grey[600],
                  offset: Offset(-4.0, -4.0),
                  blurRadius: 1.0,
                  spreadRadius: 1.0,
                ),
              ],
              gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.grey[700],
                    Colors.grey[600],
                    Colors.grey[500],
                    Colors.grey[200],
                  ],
                  stops: [
                    0,
                    0.1,
                    0.3,
                    1
                  ])),
        ),
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.grey[300],
            boxShadow: [
              BoxShadow(
                  color: Colors.grey[200],
                  offset: Offset(-4.0, -4.0),
                  blurRadius: 10.0,
                  spreadRadius: 1.0),
            ],
            gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.grey[200],
                  Colors.grey[300],
                  Colors.grey[400],
                  Colors.grey[500],
                ],
                stops: [
                  0.1,
                  0.3,
                  0.8,
                  1
                ])),
      ),
    );
  }
}

class MyButton extends StatelessWidget {
  var icon;
  int btnState;

  MyButton({Key key, this.icon, this.btnState}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(6),
      child: Container(
        width: 65,
        height: 46,
        padding: EdgeInsets.all(1),
        child: Wrap(
          children: <Widget>[
            Align(
              alignment: Alignment(0.9, 0),
              child: Icon(
                icon,
                size: 30,
                color: Color(0xffF26726),
              ),
            ),
            Align(
              alignment: Alignment(-0.2, 0),
              child: btnState == 1
                  ? Padding(
                      padding: EdgeInsets.only(bottom: 3),
                      child: Text(
                        'الإعلانات',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 24,
                          fontFamily: 'AmiriQuran',
                          height: 0,
                        ),
                      ),
                    )
                  : Padding(
                      padding: EdgeInsets.only(bottom: 5),
                      child: Text(
                        'الأقسام',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 24,
                          fontFamily: 'AmiriQuran',
                          height: 0,
                        ),
                      ),
                    ),
            )
          ],
        ),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.grey[300],
            boxShadow: [
              BoxShadow(
                  color: Colors.grey[600],
                  offset: Offset(4.0, 4.0),
                  blurRadius: 10.0,
                  spreadRadius: 1.0),
              BoxShadow(
                  color: Colors.white,
                  offset: Offset(-4.0, -4.0),
                  blurRadius: 15.0,
                  spreadRadius: 1.0),
            ],
            gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.grey[200],
                  Colors.grey[300],
                  Colors.grey[400],
                  Colors.grey[500],
                ],
                stops: [
                  0.1,
                  0.3,
                  0.8,
                  1
                ])),
      ),
    );
  }
}

class GridViewItems extends StatelessWidget {
  final String text;
  final VoidCallback callback;
  final String imagePath;

  GridViewItems({
    Key key,
    this.text,
    this.callback,
    this.imagePath,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: callback,
      child: Card(
        elevation: 0,
        color: Colors.grey[200],
        child: SizedBox(
          width: screenSizeWidth2 > 395 ? 190 : 172,
          height: 170,
          child: Container(
            width: 100,
            //width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              image: DecorationImage(
                  image: AssetImage(imagePath), fit: BoxFit.fill),
              color: Colors.redAccent,
            ),
            child: Transform.translate(
                offset: Offset(22, -68),
                child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 27, vertical: 71),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Colors.grey[50]),
                    child: Center(
                      child: Text(
                        text,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 15,
                          fontFamily: 'AmiriQuran',
                          height:1,
                        ),
                      ),
                    ))),
          ),
        ),
      ),
    );
  }
}

Widget areaForAd() {
  return Container(
    child: CarouselSlider(
      items: adImagesUrlF.map((url) {
        return Builder(builder: (BuildContext context) {
          return InkWell(
            onTap: () {
              print('w$screenSizeWidth2');
              print('h$screenSizeHieght2');
            },
            child: Container(
              height: 120,
              // margin: EdgeInsets.only(right: 1, left: 1),
              padding: EdgeInsets.only(right:5, left: 1),
              child: Hero(
                  tag: Text('imageAd'),
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(3),
                      child: Image.network(url,fit:BoxFit.fill,height: 75,width: 370,))),
            ),
          );
        });
      }).toList(),
      options: CarouselOptions(
        initialPage: 0,
        autoPlay: true,
        pauseAutoPlayOnTouch: false,
        autoPlayAnimationDuration: Duration(seconds: 3),
        autoPlayInterval: Duration(seconds: 9),
        disableCenter: false,
        height: 84,
      ),
    ),
  );
}

class NewAds extends StatefulWidget {
  @override
  _NewAdsState createState() => _NewAdsState();
}

String department;
String category;

class _NewAdsState extends State<NewAds> {
  @override
  Widget build(BuildContext context) {
    return Material(
        child: StreamBuilder(
            stream: Firestore.instance
                .collection('Ads')
                .orderBy('time')
                .snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (!snapshot.hasData)
                return Text(
                  'Loading...',
                  style: TextStyle(fontSize: 60),
                );
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                  return new Text('Loading...');
                default:
                  return Container(
                    child: new GridView.count(
                      crossAxisCount: 2,
                      crossAxisSpacing: 0.1,
                      mainAxisSpacing: 0.2,
                      childAspectRatio: screenSizeHieght2 > 800 ? 0.7 : 0.6,
                      children: List.generate(
                          snapshot.data.documents.length < 80 ? 20 : 79,
                          (index) {
                        return InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                BouncyPageRoute(
                                    widget: ShowAd(
                                  documentId:
                                      snapshot.data.documents[index].documentID,
                                )));
                          },
                          child: Card(
                            elevation: 6,
                            child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.grey[200],
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    ClipRRect(
                                      child: Image.network(
                                        snapshot.data.documents[index]
                                            ['imagesUrl'][0],
                                        height:
                                            screenSizeHieght2 > 800 ? 182 : 208,
                                        width:
                                            screenSizeWidth2 < 750 ? 175 : 195,
                                        fit: BoxFit.fill,
                                      ),
                                      borderRadius: BorderRadius.circular(3),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Stack(
                                      children: [

                                        IconButton(
                                            icon: Icon(Icons.favorite_border,size: 30,color: Colors.red,),
                                            onPressed: (){
                                              saveLike(snapshot.data.documents[index].documentID.toString(),
                                                  snapshot.data.documents[index]['name'],
                                                  snapshot.data.documents[index]['likes']
                                              );
                                            }),
                                        Container(
                                          child: Column(
                                            children: [
                                              Row(
                                                crossAxisAlignment: CrossAxisAlignment.end,
                                                mainAxisAlignment: MainAxisAlignment.end,
                                                children: <Widget>[
                                                  Text(
                                                    snapshot.data.documents[index]['name'],
                                                    style: TextStyle(
                                                      fontSize: 15,
                                                      fontFamily: 'AmiriQuran',
                                                      height: 1.2,
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 5,
                                                  ),
                                                ],
                                              ),
                                              SizedBox(
                                                height: 4,
                                              ),
                                              Row(
                                                crossAxisAlignment: CrossAxisAlignment.end,
                                                mainAxisAlignment: MainAxisAlignment.end,
                                                children: <Widget>[
                                                  Text(
                                                    snapshot.data.documents[index]['price']
                                                        .toString(),
                                                    style: TextStyle(
                                                      fontSize: 14,
                                                      fontFamily: 'AmiriQuran',
                                                      height: 1.2,
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 3,
                                                  ),
                                                  Text(
                                                    ': السعر',
                                                    style: TextStyle(
                                                      fontSize: 14,
                                                      fontFamily: 'AmiriQuran',
                                                      height: 1.2,
                                                    ),
                                                  ),
                                                ],
                                              ),

                                              Row(
                                                crossAxisAlignment: CrossAxisAlignment.end,
                                                mainAxisAlignment: MainAxisAlignment.end,
                                                children: <Widget>[
                                                  Text(
                                                    snapshot.data.documents[index]['area'],
                                                    style: TextStyle(
                                                      fontSize: 14,
                                                      fontFamily: 'AmiriQuran',
                                                      height: 1.2,
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 3,
                                                  ),
                                                  Text(
                                                    ': المنطقة',
                                                    style: TextStyle(
                                                      fontSize: 14,
                                                      fontFamily: 'AmiriQuran',
                                                      height: 1.3,
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 9,
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                crossAxisAlignment: CrossAxisAlignment.end,
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                children: [
                                                  SizedBox(width: 4,),
                                                  snapshot.data.documents[index]['likes'].toString()!= null ?
                                                  Text(snapshot.data.documents[index]['likes'].toString(),style:
                                                  TextStyle(
                                                      height: 0,
                                                      fontSize: 12
                                                  ),):Container(),
                                                  Text(': لايك',style: TextStyle(
                                                    fontSize: 12,
                                                    fontFamily: 'AmiriQuran',
                                                    height: 0,
                                                  ),),
                                                  SizedBox(width: 10,),
                                                ],
                                              )
                                            ],
                                          ),
                                        )
                                      ],
                                    )
                                  ],
                                )),
                          ),
                        );
                      }),
                    ),
                  );
              }
            }));
  }
  saveLike(Ad_id,Ad_name,likeCount)async{
    if(doLike==false){
      Firestore.instance.collection('Ads').document(Ad_id).updateData({
        "likes": likeCount+1,
      });

      Firestore.instance.collection('likes').document().setData({
        'Ad_id': Ad_id,
        'Ad_name': Ad_name,
        'who_like': currentUserId,
        'like':true,
        'time': DateFormat('yyyy-MM-dd-HH:mm').format(DateTime.now()),
      });
      doLike = true;
    }
  }
  saveView(Ad_id,Ad_name)async{

    Firestore.instance.collection('Views').document().setData({
      'Ad_id': Ad_id,
      'Ad_name': Ad_name,
      'who_view': currentUserId,
      'view':true,
      'time': DateFormat('yyyy-MM-dd-HH:mm').format(DateTime.now()),
    });
  }
}
