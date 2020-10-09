import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'NewLogin.dart';

class NewReg extends StatefulWidget {
  @override
  _NewRegState createState() => _NewRegState();
}
bool equalName ;
List<String> _namesList =[];

class _NewRegState extends State<NewReg> {
  void initState() {
    getUsersNames();
    super.initState();
  }
  getUsersNames()async{
    var firestore = Firestore.instance;
    QuerySnapshot qus = await firestore.collection('users').getDocuments();
    if(qus!=null){
      for (int i=0; qus.documents.length>_namesList.length;  i ++){
        setState(() {
          _namesList.add(qus.documents[i]['name']);

        });

      }
    }
    print(_namesList);

  }
  final _formkey = GlobalKey<FormState>();

  TextEditingController _namecontroller = TextEditingController();

  TextEditingController _passwordcontroller = TextEditingController();

  TextEditingController _countrycontroller = TextEditingController();

  @override
  void dispose() {
    _namecontroller.dispose();

    _passwordcontroller.dispose();

    _countrycontroller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'تسجيل مستخدم جديد',
            style: TextStyle(fontSize: 24, fontFamily: 'AmiriQuran', height: 1),
          ),
        ),
        body: ListView(
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(16),
              child: Form(
                key: _formkey,
                child: Column(
                  children: <Widget>[
                    TextFormField(
                      controller: _namecontroller,
                      textAlign: TextAlign.right,
                      decoration: InputDecoration(
                        hintText: 'الإسم',
                      ),
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please Fill name Input';
                        }
                        // return 'Valid Name';
                      },
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      controller: _passwordcontroller,
                      textAlign: TextAlign.right,
                      decoration: InputDecoration(
                        hintText: 'كلمة المرور',
                      ),
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please Fill Password Input';
                        }
                      },
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      controller: _countrycontroller,
                      textAlign: TextAlign.right,
                      decoration: InputDecoration(
                        hintText: 'المنطقة',
                      ),
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please Fill Country Input';
                        }
                      },
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    RaisedButton(
                      color: Colors.blue,
                      child: Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: 6, horizontal: 40),
                        child: Text(
                          'تسجيل',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 22,
                              fontFamily: 'AmiriQuran',
                              color: Colors.white,
                              height: 1),
                        ),
                      ),
                      onPressed: () async {
                        if (_formkey.currentState.validate()) {
                          doSaveName();

                        }
                      },
                    )
                  ],
                ),
              ),
            ),
          ],
        ));
  }
  doSaveName()async{
    equalName=false;
    for(int i=0;i<_namesList.length;i++){
      if(_namecontroller.text.toLowerCase().trimLeft()==_namesList[i]){
        equalName=true;
        showMessage('إسم المستخدم موجود مسبقاً رجاءاٌ اختر غيره');
      }
    }
    print(equalName);
    if(equalName==false){
      print('done');
      //saveName();
      Firestore.instance
          .collection('users')
          .document(
        _namecontroller.text,
      )
          .setData({
        'name': _namecontroller.text,
        'area': _countrycontroller.text,
        'password': _passwordcontroller.text,
        "time": DateFormat('yyyy-MM-dd-HH:mm')
            .format(DateTime.now()),
      });
      SharedPreferences sharedPref =
          await SharedPreferences.getInstance();
      sharedPref
          .setString('name', _namecontroller.text)
          .then((value) {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => NewLogin()));
      });
    }else{
      print('notDone');
    }
  }
  showMessage(String msg) {
    Fluttertoast.showToast(
        msg:msg,
        gravity: ToastGravity.CENTER,
        toastLength: Toast.LENGTH_LONG,
        backgroundColor: Colors.blue,
        fontSize: 15,
        textColor: Colors.white);
  }
}
