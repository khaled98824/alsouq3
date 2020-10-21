import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sooq1alzour/Auth/NewLogin.dart';
import 'package:sooq1alzour/models/PageRoute.dart';
import 'chating2.dart';

class MyChats extends StatefulWidget {
  static const String id = "MyChats";
  @override
  _MyChatsState createState() => _MyChatsState();
}

class _MyChatsState extends State<MyChats> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('محادثاتي',style: TextStyle(
          fontSize: 20,
          fontFamily: 'AmiriQuran',
          height: 1,
          color: Colors.white,
        )),
      ),
      body: Material(
        color: Colors.grey,
          child: StreamBuilder(
              stream: Firestore.instance
                  .collection('chats').where('name',isEqualTo: currentUserId)
                  .snapshots(),
              builder:
                  (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData)
                  return Text(
                    'Loading...',
                    style: TextStyle(fontSize: 50),
                  );
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                    return new Text('Loading...');
                  default:
                    return Padding(
                      padding: EdgeInsets.only(top: 10),
                      child: Container(

                        child: new GridView.count(
                          crossAxisCount: 1,
                          crossAxisSpacing: 0.3,
                          mainAxisSpacing: 0.4,
                          childAspectRatio: screenSizeHieght2 > 800 ? 4 : 5,
                          children: List.generate(
                              snapshot.data.documents.length ,
                                  (index) {
                                return InkWell(
                                  onTap: () {
                                    print(snapshot.data.documents[index]['idChat'],);
                                    Navigator.push(
                                        context,
                                        BouncyPageRoute(
                                            widget: Chating2(documentId:snapshot.data.documents[index]['Ad_id'],
                                              idChat: snapshot.data.documents[index]['idChat'],)));
                                  },
                                  child: Card(
                                    elevation: 3,
                                    child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(10),
                                          color: Colors.black87,
                                        ),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: <Widget>[
                                            Icon(Icons.arrow_back_ios_outlined,color: Colors.white,),
                                            Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              children: [
                                                SizedBox(height: 6,width: 4,),
                                                Row(
                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                  mainAxisAlignment: MainAxisAlignment.end,
                                                  children: [
                                                  Text(snapshot.data.documents[index]['Ad_name'],textDirection: TextDirection.rtl,
                                                    style: TextStyle(
                                                        fontSize: 12,
                                                        fontFamily: 'AmiriQuran',
                                                        height: 1,
                                                        color: Colors.white
                                                    ),),

                                                  Text(' : إعلان',style: TextStyle(
                                                      fontSize: 14,
                                                      fontFamily: 'AmiriQuran',
                                                      height: 1,
                                                      color: Colors.white
                                                  ),),
                                                  SizedBox(width: 12,height: 6,),
                                                ],),
                                                SizedBox(width: 4,height: 12,),
                                                Text(' : الرسالة',textAlign: TextAlign.right,
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    fontFamily: 'AmiriQuran',
                                                    height: 1,
                                                    color: Colors.white
                                                ),),
                                                SizedBox(height: 9,),
                                                Column(children: [
                                                  Text(snapshot.data.documents[index]['text'],textDirection: TextDirection.rtl,
                                                    style: TextStyle(
                                                        fontSize: 12,
                                                        fontFamily: 'AmiriQuran',
                                                        height: 0,
                                                        color: Colors.white
                                                    ),),

                                                  SizedBox(width: 2,),
                                                ],),
                                              ],
                                            ),
                                            SizedBox(
                                              height: 5,

                                            ),
                                            Container(
                                              width:2,
                                              decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(2),
                                              color: Colors.grey[300]
                                            ),),
                                            SizedBox(width: 2,),
                                            Container(
                                              child: Column(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  Row(children: [
                                                    Text('${snapshot.data.documents[index]['from']}  ',textDirection: TextDirection.rtl,
                                                      style: TextStyle(
                                                          fontSize: 13,
                                                          fontFamily: 'AmiriQuran',
                                                          height: 1,
                                                          color: Colors.white
                                                      ),),
                                                    Text(' : ارسل',style: TextStyle(
                                                        fontSize: 13,
                                                        fontFamily: 'AmiriQuran',
                                                        height: 1,
                                                        color: Colors.white
                                                    ),),
                                                    SizedBox(width: 3,),
                                                  ],),
                                                  SizedBox(
                                                    height: 14,
                                                  ),

                                                  SizedBox(width: 2,),
                                                  Text(snapshot.data.documents[index]['date'],style: TextStyle(
                                                      color: Colors.white,
                                                    fontSize: 12
                                                  ),),
                                                  SizedBox(
                                                    height: 4,
                                                  ),

                                                ],
                                              ),
                                            ),
                                            SizedBox(width: 2,),
                                            Icon(Icons.account_circle_outlined,size: 44,color: Colors.blue[800],),
                                            SizedBox(width: 2,),

                                          ],
                                        )),
                                  ),
                                );
                              }),
                        ),
                      ),
                    );
                }
              })),
    );
  }
}
