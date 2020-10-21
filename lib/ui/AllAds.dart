import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sooq1alzour/Auth/NewLogin.dart';
import 'package:sooq1alzour/models/PageRoute.dart';
import 'package:sooq1alzour/ui/Home.dart';
import 'package:sooq1alzour/ui/ShowAds.dart';

import 'SerchData.dart';
bool doLike = false;
class Ads extends StatelessWidget {
  String department;
  String category;
  Ads({this.department,this.category});
  static const String id = "Ads";
  @override
  Widget build(BuildContext context) {
    return AdsFul(department: department,category: category,);
  }
}
String likeAdId ;
bool like =false;
class AdsFul extends StatefulWidget {
  String department;
  String category;
  AdsFul({this.department,this.category});
  @override
  _AdsFulState createState() => _AdsFulState(department: department);
}
QuerySnapshot qusLikes ;
class _AdsFulState extends State<AdsFul> {
  String department;
  String category;
  _AdsFulState({this.department,this.category});
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  getDocuments()async{
    var firestore = Firestore.instance;
    qusLikes = await firestore
        .collection('Views')
        .getDocuments();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: StreamBuilder(
        stream: Firestore.instance
            .collection('Ads')
            .where('department', isEqualTo: department,).where('category', isEqualTo:category )
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData)
            return Text(
              'Loading...',
              style: TextStyle(fontSize: 60),
            );
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return new Text('Loading...');
            default:
              return Stack(
                children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top: 106),
                child: GridView.count(
                crossAxisCount: 2,
                    crossAxisSpacing: 5,
                    mainAxisSpacing: 5,
                    childAspectRatio:screenSizeHieght2 <895?0.6: 0.7,
                    children:
                    List.generate(snapshot.data.documents.length, (index) {
                      return InkWell(
                        onTap: () {
                          saveView(snapshot.data.documents[index].documentID.toString(),
                              snapshot.data.documents[index]['name']);
                          print(department);
                          Navigator.push(context, BouncyPageRoute(widget: ShowAd(
                            documentId: snapshot.data.documents[index].documentID)));
                        },
                        child: Card(
                          elevation: 6,
                          child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.white70,
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  ClipRRect(
                                    child: Image.network(
                                      snapshot.data.documents[index]['imagesUrl'][0],
                                      height: 212,
                                      width: 190,
                                      fit: BoxFit.fill,
                                    ),
                                    borderRadius: BorderRadius.circular(10),
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
                    })),
              ),

                  Padding(
                    padding: EdgeInsets.only(top: 80),
                    child: InkWell(
                      onTap: () {
                        showSearch(
                            context: context,
                            delegate: SerchData(category: category));
                      },
                      child: Padding(
                        padding: EdgeInsets.only(right: 44,left: 30),
                        child: Container(
                          height: 37,
                          width: 340,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(40),
                              color: Colors.grey[350]),
                          child: Stack(
                            alignment: Alignment(-0.2, 0),
                            children: <Widget>[
                              Text('!... إبحث  في قسم $department',
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
                                    size: 31,
                                  ))
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Align(
                      alignment: Alignment(1, -0.9),
                      child: Padding(
                          padding: EdgeInsets.symmetric(vertical:screenSizeHieght2 <890? 48:41,horizontal: 1),
                          child: InkWell(
                              onTap: (){
                                Navigator.of(context).pop();
                              },
                              child: Icon(Icons.arrow_forward_ios,size: 38,color: Colors.blue,)))),
                  Align(
                    alignment: Alignment(0, -0.9),
                    child: Text(department,style: TextStyle(
                      fontSize: 20,
                      fontFamily: 'AmiriQuran',
                      height: 1,
                      ),
                      ),)
                ],
              );

          }
        },
      ),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  saveLike(Ad_id, Ad_name, likeCount) async {

    if (likeAdId == Ad_id) {

    }else{
      Firestore.instance.collection('Ads').document(Ad_id).updateData({
        "likes": likeCount + 1,
      });

      Firestore.instance.collection('likes').document().setData({
        'Ad_id': Ad_id,
        'Ad_name': Ad_name,
        'who_like': currentUserId,
        'like': true,
        'time': DateFormat('yyyy-MM-dd-HH:mm').format(DateTime.now()),
      });
      doLike = true;
      likeAdId = Ad_id;
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
