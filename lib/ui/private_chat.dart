import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sooq1alzour/Auth/NewLogin.dart';
import 'package:sooq1alzour/models/PageRoute.dart';
import 'package:sooq1alzour/ui/ShowAds.dart';


class PrivateChat extends StatefulWidget {
  String documentId;
  String recipient;
  PrivateChat({this.documentId, this.recipient});
  @override
  _PrivateChatState createState() =>
      _PrivateChatState(documentId: documentId, recipient: recipient);
}

List<DocumentSnapshot> docs;
QuerySnapshot qusViews;
DocumentSnapshot documentsUser;
DocumentSnapshot documentsAds;
DocumentSnapshot documentMessages;
List<Widget> messages;
bool showMessages = false;
String currentUserName;
TextEditingController messageController = TextEditingController();
ScrollController scrollController = ScrollController();
int imageUrl4Show;
String Messgetext;
bool showBodyPrivate = false;
String idChat;

class _PrivateChatState extends State<PrivateChat> {
  String documentId;
  String recipient;
  _PrivateChatState({this.documentId, this.recipient});

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getDocumentValue();
    Timer(Duration(microseconds: 300), () {
      setState(() {
        showMessages = true;
      });
    });
  }
  bool firstSend =false;
  getDocumentValue() async {
    SharedPreferences sharedPref = await SharedPreferences.getInstance();
    currentUserName = sharedPref.getString('name');
    DocumentReference documentRef =
        Firestore.instance.collection('Ads').document(documentId);
    documentsAds = await documentRef.get();

    DocumentReference documentRefUser =
        Firestore.instance.collection('users').document(currentUserId);
    documentsUser = await documentRefUser.get();
    setState(() {
      showBodyPrivate = true;
    });
    idChat = currentUserId + documentId + documentsAds.data['uid'];
  }

  makePostRequest(token1, AdsN) async {
    if(firstSend){

    }else{
      DocumentReference documentRefUser =
      Firestore.instance.collection('users').document(currentUserId);
      documentsUser = await documentRefUser.get();
      print("enter");
      final key1 =
          'AAAA3axJ_PM:APA91bF-QTmmVGRzpPvqvaE3xioEvuaBkGmj8JT2aG-puw3_83aSBnEdC5n8RGj78a1n_996CbwbVpk8OxYumCPP8vBAA7ykx7BrXXETkSU-EiySB2hD96Gx8JHsRnbXgyXp2-H9Qk29';
      final uri = 'https://fcm.googleapis.com/fcm/send';
      final headers = {
        'Content-Type': 'application/json',
        HttpHeaders.authorizationHeader: "key=" + key1
      };
      Map<String, dynamic> title = {
        'title': "${documentsUser.data['name']} علق على  ${AdsN}",
        "Mess": "${Messgetext}"
      };
      Map<String, dynamic> body = {'data': title, "to": token1};
      String jsonBody = json.encode(body);
      final encoding = Encoding.getByName('utf-8');

      Response response = await post(
        uri,
        headers: headers,
        body: jsonBody,
        encoding: encoding,
      );

      int statusCode = response.statusCode;
      String responseBody = response.body;
      print(statusCode);
      print(responseBody);
      firstSend = true;
    }
  }

  final Firestore _firestore = Firestore.instance;
  Future<void> callBack() async {
    DocumentReference documentRef;

    if (messageController.text.length > 0) {
      Messgetext = messageController.text;
      await _firestore
          .collection("private_messages")
          .document('pChat')
          .collection(idChat)
          .add({
        'text': Messgetext,
        'from': currentUserId,
        'date': DateFormat('yyyy-MM-dd-HH:mm').format(DateTime.now()),
        'name': documentsUser['name'],
        'Ad_id': documentsAds.documentID,
        'message_id': currentUserId + documentId + documentsAds.data['uid'],
        'Ad_user': documentsAds.data['uid'],
        'realTime':DateTime.now(),

      });
      documentRef = Firestore.instance.collection('Ads').document(documentId);
      documentsAds = await documentRef.get();
      documentRef = Firestore.instance
          .collection('users')
          .document(documentsAds.data['uid']);
      documentsUser = await documentRef.get();

      print("token" + documentsUser.data['token']);
      print(documentsAds.data['uid']);
      print(documentsUser.documentID);

      if (documentsAds.data['uid'] != currentUserId) {
        makePostRequest(documentsUser.data['token'], documentsAds.data['name']);
      }

      setState(() {});
      messageController.clear();
      scrollController.animateTo(scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'دردش',
          style: TextStyle(
            fontSize: 20,
            fontFamily: 'AmiriQuran',
            height: 1,
            color: Colors.white,
          ),
        ),
        leading: InkWell(
            onTap: () {
             Navigator.of(context).pop();
            },
            child: Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
              size: 25,
            )),
      ),
      body: showBodyPrivate
          ? ListView(
        reverse: false,
              controller: scrollController,
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 10, right: 10, left: 10),
                  child: StreamBuilder<QuerySnapshot>(
                    stream: _firestore
                        .collection("private_messages")
                        .document('pChat')
                        .collection(idChat)
                        .orderBy('realTime')
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return Center(
                            child: Column(
                          children: <Widget>[
                            // CircularProgressIndicator(strokeWidth: 1,),
                            SizedBox(
                              height: 8,
                            ),
                            Text(
                              '!...لا توجد تعليقات ',
                              style: TextStyle(
                                fontSize: 16,
                                fontFamily: 'AmiriQuran',
                                height: 1,
                                color: Colors.grey[500],
                              ),
                            )
                          ],
                        ));
                      }
                      docs = snapshot.data.documents;
                      List<Widget> messages = docs
                          .map((doc) => Message(
                              from: doc.data["from"],
                              text: doc.data["text"],
                              time: doc.data['date'],
                              me: documentsUser['name'] == doc.data["name"]))
                          .toList();

                      return Column(
                        children: <Widget>[
                          ...messages,
                        ],
                      );
                    },
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                SizedBox(
                  height: 60,
                  child: loginStatus
                      ? Padding(
                    padding: EdgeInsets.only(top: 0),
                        child: Container(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: <Widget>[
                                Expanded(
                                  child: Padding(
                                    padding: EdgeInsets.only(right: 10, left: 10,top: 0),
                                    child: TextField(
                                      controller: messageController,
                                      textAlign: TextAlign.right,
                                      maxLines: 1,
                                      maxLength: 47,
                                      decoration: InputDecoration(
                                        hintText: "!... اكتب تعليقك هنا",
                                        hintStyle: TextStyle(
                                            fontSize: 16,
                                            height: 1
                                        ),
                                      ),
                                      onSubmitted: (value) => callBack(),
                                    ),
                                  ),
                                ),
                                loginStatus
                                    ? SendButton(
                                        text: 'ارسل',
                                        callback: () {
                                          saveChatId();
                                          callBack();
                                          print(documentsUser.data['token']);
                                        },
                                      )
                                    : Center(
                                        child: SpinKitFadingCircle(
                                          color: Colors.red,
                                          size: 55,
                                          duration: Duration(seconds: 2),
                                        ),
                                      ),
                              ],
                            ),
                          ),
                      )
                      : Center(
                          child: SpinKitFadingCircle(
                            color: Colors.red,
                            size: 44,
                            duration: Duration(seconds: 2),
                          ),
                        ),
                )
              ],
            )
          : Center(
              child: SpinKitFadingCircle(
                color: Colors.red,
                size: 70,
                duration: Duration(seconds: 2),
              ),
            ),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    showBodyPrivate = false;
    //docs.clear();
  }

  saveChatId() async {
    if (currentUserId != documentsAds.data['uid']) {
      Firestore.instance
          .collection('chats')
          .document(
            currentUserId + documentId,
          )
          .setData({
        'from': currentUserId,
        'date': DateFormat('yyyy-MM-dd-HH:mm').format(DateTime.now()),
        'Ad_id': documentsAds.documentID,
        'Ad_name': documentsAds.data['name'],
        'name': documentsAds.data['uid'],
        'text': messageController.text,
        'idChat': idChat,
        'realTime':DateTime.now(),
      });
    }
  }
}

class SendButton extends StatelessWidget {
  final String text;
  final VoidCallback callback;

  const SendButton({Key key, this.text, this.callback}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return FlatButton(
      color: Colors.orange,
      onPressed: callback,
      child: Text(text),
    );
  }
}

class Message extends StatelessWidget {
  final String from;
  final String text;
  final String time;

  final bool me;

  const Message({Key key, this.from, this.text, this.me, this.time})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: me ? Alignment(1, 0) : Alignment(-1, 0),
      child: Padding(
        padding: EdgeInsets.only(top: 12),
        child: Container(
          child: Column(
            crossAxisAlignment:
                me ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                from,
                style: TextStyle(fontSize: 12, color: Colors.blue[800]),
              ),
              SizedBox(
                height: 2,
              ),
              Material(
                color: me ? Colors.teal[100] : Colors.white70,
                borderRadius: BorderRadius.circular(5),
                elevation: 5,
                child: Container(
                    padding: EdgeInsets.symmetric(vertical: 3, horizontal: 12),
                    child: Column(
                      crossAxisAlignment: me
                          ? CrossAxisAlignment.end
                          : CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          text,
                          style: TextStyle(fontSize: 15),
                        ),
                        SizedBox(
                          height: 4,
                        ),
                        Text(
                          time,
                          style:
                              TextStyle(fontSize: 11, color: Colors.deepOrange),
                        )
                      ],
                    )),
              )
            ],
          ),
        ),
      ),
    );
  }
}
