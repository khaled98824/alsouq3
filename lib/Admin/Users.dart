import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sooq1alzour/Admin/SerchDataAdminUser.dart';

class UsersAdmin extends StatefulWidget {
  @override
  _UsersAdminState createState() => _UsersAdminState();
}

bool deleteThisAd = false;

class _UsersAdminState extends State<UsersAdmin> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Users Info'),
        ),
        body: StreamBuilder(
          stream: Firestore.instance.collection('users').snapshots(),
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
                return Stack(
                  children: <Widget>[
                    Align(
                      alignment: Alignment(-0.8, -1),
                      child: Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: 14, horizontal: 12),
                        child: Card(
                          color: Colors.grey[200],
                          elevation: 6,
                          child: Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              child: Text(
                                  "العدد ${snapshot.data.documents.length.toString()}")),
                        ),
                      ),
                    ),
                    Padding(
                        padding: EdgeInsets.only(top: 60),
                        child: ListView.builder(
                            itemCount: snapshot.data.documents.length,
                            itemBuilder: (BuildContext context, index) {
                              return Card(
                                elevation: 5,
                                child: SizedBox(
                                  height: 65,
                                  child: ListTile(
                                      title: Text(
                                        snapshot.data.documents[index]['name'],
                                        textAlign: TextAlign.start,
                                        style: TextStyle(
                                          fontSize: 15,
                                        ),
                                      ),
                                      trailing: Text(
                                        snapshot.data.documents[index]
                                            ['user_uid'],
                                        style: TextStyle(fontSize: 11),
                                      ),
                                      subtitle: Text(
                                        snapshot.data.documents[index]['time'],
                                        style: TextStyle(
                                          fontSize: 11,
                                        ),
                                      ),
                                      leading: IconButton(
                                        icon: Icon(
                                          Icons.delete_forever,
                                          color: Colors.red,
                                        ),
                                        onPressed: () async {
                                          await Alert(
                                              context,
                                              snapshot.data.documents[index]
                                                  ['name'],
                                              snapshot.data.documents[index]
                                                  .documentID);
                                          deleteThisAd
                                              ? Firestore.instance
                                                  .collection('users')
                                                  .document(snapshot
                                                      .data
                                                      .documents[index]
                                                      .documentID)
                                                  .delete()
                                                  .then((value) {
                                                  print('delete done');
                                                })
                                              : print('Do not');
                                        },
                                      )),
                                ),
                              );
                            })),
                    Positioned(
                      right: 10,
                      top: 10,
                      child: InkWell(
                        onTap: () {
                          showSearch(
                              context: context,
                              delegate: SerchDataAdmin(collection: 'users'));
                        },
                        child: Padding(
                          padding: EdgeInsets.only(bottom: 1),
                          child: Container(
                            height: 35,
                            width: 220,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(40),
                                color: Colors.grey[350]),
                            child: Stack(
                              textDirection: TextDirection.rtl,
                              alignment: Alignment(0, 0),
                              children: <Widget>[
                                Text('!... إبحث في قائمة المستخدمين',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 14,
                                      fontFamily: 'AmiriQuran',
                                      height: 1,
                                    )),
                                Align(
                                    alignment: Alignment(0.9, 0),
                                    child: Icon(
                                      Icons.search,
                                      size: 24,
                                    ))
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                );
            }
          },
        ));
  }

  Future<Null> Alert(BuildContext context, name, id) {
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
                    'هل انت متاكد ؟',
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
                width: 10,
              ),

              SizedBox(
                width: 10,
              ),
              FlatButton(
                onPressed: () {
                  setState(() {
                    deleteThisAd = true;
                  });
                  Navigator.of(context).pop();
                },
                child: Text(
                  'نعم تابع',
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
}
