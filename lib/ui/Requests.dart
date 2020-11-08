import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sooq1alzour/Auth/NewLogin.dart';
import 'package:sooq1alzour/models/PageRoute.dart';
import 'package:sooq1alzour/ui/addNewRequest.dart';

import 'AddNewAd.dart';
import 'EditAd.dart';
import 'Home.dart';
import 'MyChats.dart';
import 'ShowAds.dart';
import 'myAccount.dart';

class MyRequests extends StatefulWidget {
  @override
  _MyRequestsState createState() => _MyRequestsState();
}
DocumentSnapshot documentsUser;
bool deleteThisAd = false;
bool showData = false;
bool showBody = false;
DocumentSnapshot documentAdmin;
class _MyRequestsState extends State<MyRequests> {
  String currentUserName;
  int currentIndex = 3;
  setBottomBarIndex(index) {
    setState(() {
      currentIndex = index;
    });
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCurrentUserInfo();
  }
  @override

  getCurrentUserInfo() async {
    SharedPreferences sharedPref = await SharedPreferences.getInstance();
    currentUserName = sharedPref.getString('name');
    print(sharedPref.getString('name'));
    DocumentReference documentRef = Firestore.instance
        .collection('users')
        .document(currentUserName);
    documentsUser = await documentRef.get();

    setState(() {
      showData = true;
      showBody = true;
      print(currentUserName);
    });
  }
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('طلباتي',
            textAlign: TextAlign.right,
            style: TextStyle(
                decoration: TextDecoration.none,
                fontSize: 18,
                fontFamily: 'AmiriQuran',
                height: 1,
                color: Colors.white)),
      ),
      body: showBody ?Material(
          child: StreamBuilder(
            stream: Firestore.instance
                .collection('Ads')
                .where('uid', isEqualTo: currentUserName,).where('isRequest',isEqualTo: true)
                .snapshots(),
            builder: (BuildContext context,
                AsyncSnapshot<QuerySnapshot> snapshot) {
              if (!snapshot.hasData)
                return Center(
                  child: SpinKitFadingCircle(
                    color: Colors.red,
                    size: 70,
                    duration: Duration(seconds: 2),
                  ),
                );
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                  return new Text('Loading...');
                default:
                  return Stack(
                    children: <Widget>[
                      ListView.builder(
                          itemCount: snapshot.data.documents.length,
                          itemBuilder:
                              (BuildContext context, index) {
                            return Card(
                              elevation: 2,
                              color: Colors.white70,
                              child: SizedBox(
                                height: 58,
                                child: ListTile(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        BouncyPageRoute(
                                            widget: ShowAd(
                                              documentId: snapshot
                                                  .data
                                                  .documents[index]
                                                  .documentID,
                                            )));
                                  },
                                  title: Text(
                                    snapshot.data.documents[index]
                                    ['name'],
                                    textAlign: TextAlign.right,
                                    style: TextStyle(
                                      fontSize: 16,
                                    ),
                                  ),
                                  trailing: InkWell(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            BouncyPageRoute(
                                                widget: EditAd(
                                                  documentId: snapshot
                                                      .data
                                                      .documents[index]
                                                      .documentID,
                                                )));
                                      },
                                      child: Icon(
                                        Icons.mode_edit,
                                        color: Colors.blue,
                                        size: 32,
                                      )),
                                  subtitle: Text(
                                    snapshot.data.documents[index]
                                    ['time'],
                                    style: TextStyle(
                                      fontSize: 13,
                                    ),
                                  ),
                                  leading: InkWell(
                                      onTap: () async {
                                        await Alert(context,snapshot.data.documents[index]['name'],snapshot.data.documents[index].documentID);
                                        deleteThisAd
                                            ? Firestore.instance
                                            .collection('Ads')
                                            .document(snapshot
                                            .data
                                            .documents[
                                        index]
                                            .documentID)
                                            .delete()
                                            .then((value) {
                                          print(
                                              'delete done');
                                        })
                                            : print('Do not');
                                      },
                                      child: Icon(
                                        Icons.delete_forever,
                                        color: Colors.red,
                                      )
                                  ),
                                ),
                              ),
                            );
                          }
                      ),
                      Stack(
                        children: [
                          Positioned(
                            left: 0,
                            bottom: 0,
                            child: CustomPaint(
                              size: Size(size.width, 80),
                              painter: BNBCustomPainter(),
                            ),
                          ),
                          Positioned(
                            left: size.width / 2.4,
                            bottom: 0,
                            child: Center(
                              heightFactor: 2.5,
                              widthFactor: 1.1,
                              child: FloatingActionButton(
                                  backgroundColor: Color(0xffF26726),
                                  child: Padding(
                                    padding: EdgeInsets.only(right: 2),
                                    child: Icon(
                                      Icons.add_a_photo,
                                      size: 30,
                                    ),
                                  ),
                                  elevation: 0.1,
                                  onPressed: () {
                                    if (loginStatus) {
                                      Navigator.of(context).pushNamed(AddNewRequest.id);
                                    } else {
                                      loginStatus = false;
                                      print('no');
                                      Navigator.pushReplacement(context,
                                          MaterialPageRoute(builder: (context) {
                                            return NewLogin(
                                              autoLogin: false,
                                            );
                                          })
                                      );
                                    }
                                  }),
                            ),
                          ),
                          Positioned(
                            bottom: -10,
                            child: Container(
                              width: size.width,
                              height: 80,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  Column(
                                    children: [
                                      IconButton(
                                        icon: Icon(
                                          Icons.account_circle_outlined,
                                          color: currentIndex == 0
                                              ? Color(0xffF26726)
                                              : Colors.grey.shade600,
                                        ),
                                        onPressed: () {
                                          setBottomBarIndex(0);
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
                                        },
                                        splashColor: Colors.white,
                                      ),
                                      Text('حسابي',textAlign: TextAlign.center,
                                        style: TextStyle(
                                          height: 0.1,
                                          fontFamily: 'AmiriQuran',
                                        ),),
                                    ],
                                  ),
                                  Column(children: [
                                    IconButton(
                                        icon: Icon(
                                          Icons.info,
                                          color: currentIndex == 1
                                              ? Color(0xffF26726)
                                              : Colors.grey.shade600,
                                        ),
                                        onPressed: () {
                                          setBottomBarIndex(1);
                                          Navigator.push(
                                              context, BouncyPageRoute(widget: AboutUs()));
                                        }),
                                    Text('حول التطبيق',textAlign: TextAlign.center,
                                      style: TextStyle(
                                        height: 0.1,
                                        fontFamily: 'AmiriQuran',
                                      ),),
                                  ],),
                                  Column(
                                    children: [
                                      Container(
                                        width: size.width * 0.20,
                                      ),
                                      Text('إنشاء طلب جديد',textAlign: TextAlign.center,
                                        style: TextStyle(
                                            height: 4.5,
                                            fontFamily: 'AmiriQuran',
                                            fontSize: 17,
                                            color: Color(0xffF26726)
                                        ),),
                                    ],
                                  ),
                                  Column(children: [
                                    IconButton(
                                        icon: Icon(
                                          Icons.chat_outlined,
                                          color: currentIndex == 2
                                              ? Color(0xffF26726)
                                              : Colors.grey.shade600,
                                        ),
                                        onPressed: () {
                                          setBottomBarIndex(2);
                                          if (loginStatus) {
                                            Navigator.of(context).pushNamed(MyChats.id);
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
                                        }),
                                    Text('محادثاتي',textAlign: TextAlign.center,
                                      style: TextStyle(
                                        height: 0.1,
                                        fontFamily: 'AmiriQuran',
                                      ),)
                                  ],),
                                  Column(
                                    children: [
                                      IconButton(
                                          icon: Icon(
                                            Icons.home,
                                            color: currentIndex == 3
                                                ? Color(0xffF26726)
                                                : Colors.grey.shade600,
                                          ),
                                          onPressed: () {
                                            setBottomBarIndex(0);
                                            Navigator.of(context).pushNamed(Home.id);
                                          }),
                                      Text('الرئيسية',textAlign: TextAlign.center,
                                        style: TextStyle(
                                          height: 0.1,
                                          fontFamily: 'AmiriQuran',
                                        ),)
                                    ],
                                  )
                                ],
                              ),
                            ),
                          )
                        ],
                      )
                    ],
                  );
              }
            },
          )):Center(
        child: SpinKitFadingCircle(
          color: Colors.red,
          size: 70,
          duration: Duration(seconds: 2),
        ),
      ),
    );
  }
  Future<Null> Alert(BuildContext context,name,id) {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              'حذف إعلان',
              textAlign: TextAlign.right,
              style: TextStyle(
                  fontSize: 19, fontFamily: 'AmiriQuran', height: 1.5),
            ),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text(
                    'هل تم بيع هذا الإعلان ؟',
                    style: TextStyle(
                        fontSize: 18, fontFamily: 'AmiriQuran', height: 1.4),
                  )
                ],
              ),
            ),
            actions: <Widget>[
              FlatButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  setState(() {
                    deleteThisAd = false;
                  });
                },
                child: Text(
                  'إلغاء',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 17,
                      fontFamily: 'AmiriQuran',
                      color: Colors.white,
                      height: 1.5),
                ),
                color: Colors.blueAccent,
              ),
              SizedBox(
                width:10,
              ),
              FlatButton(
                onPressed: () {
                  setState(() {
                    deleteThisAd = true;
                  });
                  Navigator.of(context).pop();
                },
                child: Text(
                  'لا',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 17,
                      fontFamily: 'AmiriQuran',
                      color: Colors.white,
                      height: 1.5),
                ),
                color: Colors.blueAccent,
              ),
              SizedBox(
                width: 10,
              ),
              FlatButton(
                onPressed: () {
                  setState(() {
                    deleteThisAd = true;
                  });
                  saveAdsSaled(name,id);
                  Navigator.of(context).pop();
                },
                child: Text(
                  'تم البيع',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 17,
                      fontFamily: 'AmiriQuran',
                      color: Colors.white,
                      height: 1),
                ),
                color: Colors.blueAccent,
              ),

              SizedBox(
                width: 10,
              ),

            ],
          );
        });
  }
  saveAdsSaled(name,id){
    Firestore.instance.collection('AdsSaled').document()
        .setData({
      'name':name,
      'Ad_id': id,
      "time": DateFormat('yyyy-MM-dd-HH:mm')
          .format(DateTime.now()),
    });
  }

}
class BNBCustomPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = new Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    Path path = Path();
    path.moveTo(0, 20); // Start
    path.quadraticBezierTo(size.width * 0.20, 0, size.width * 0.35, 0);
    path.quadraticBezierTo(size.width * 0.40, 0, size.width * 0.40, 20);
    path.arcToPoint(Offset(size.width * 0.60, 5),
        radius: Radius.circular(20.0), clockwise: false);
    path.quadraticBezierTo(size.width * 0.60, 0, size.width * 0.65, 0);
    path.quadraticBezierTo(size.width * 0.80, 0, size.width, 20);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.lineTo(0, 20);
    canvas.drawShadow(path, Colors.black, 5, true);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}