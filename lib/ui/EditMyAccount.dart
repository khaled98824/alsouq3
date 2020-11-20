import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sooq1alzour/Auth/NewLogin.dart';
import 'package:sooq1alzour/ui/myAccount.dart';

class EditAccount extends StatefulWidget {
  @override
  _EditAccountState createState() => _EditAccountState();
}
bool equalName ;

class _EditAccountState extends State<EditAccount> {
  void initState() {
    getUsersNames();
    super.initState();
    getCurrentUserInfo();
  }

  getCurrentUserInfo()async{
    SharedPreferences sharedPref = await SharedPreferences.getInstance();
    setState(() {
      _passwordcontroller =
          TextEditingController(text: sharedPref.getString('password'));
      _namecontroller =
          TextEditingController(text: sharedPref.getString('name'));
      _countrycontroller =
          TextEditingController(text: sharedPref.getString('myArea'));
      _uidController =
          TextEditingController(text: currentUserId);
    });
  }
  getUsersNames()async{


  }
  final _formkey = GlobalKey<FormState>();

  TextEditingController _namecontroller = TextEditingController();

  TextEditingController _passwordcontroller = TextEditingController();

  TextEditingController _countrycontroller = TextEditingController();
  TextEditingController _uidController = TextEditingController();


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
            'تعديل معلومات حسابي',
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
                    Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          color: Colors.grey[300]),
                      child: Center(
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 10,horizontal: 10),
                          child: Text('أول حقل هو إسم المستخدم للدخول ولايمكن تغييره',textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 17, fontFamily: 'AmiriQuran', height: 1)),
                        ),
                      ),
                    ),
                    SizedBox(height:60,),
                    TextFormField(
                      controller: _uidController,
                      readOnly: true,
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
                          'تعديل',
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
    // equalName=false;
    // for(int i=0;i<_namesList.length;i++){
    //   if(_namecontroller.text.toLowerCase().trimLeft()==_namesList[i]){
    //     equalName=true;
    //     showMessage('إسم المستخدم موجود مسبقاً رجاءاٌ اختر غيره');
    //   }
    // }
    // print(equalName);
    // if(equalName==false){
    //   print('done');
      Firestore.instance.collection('users').document(currentUserId)
          .updateData({
        'name': _namecontroller.text,
        'area': _countrycontroller.text,
        'password': _passwordcontroller.text,
        "lastUpdate": DateFormat('yyyy-MM-dd-HH:mm')
            .format(DateTime.now()),
      });
      SharedPreferences sharedPref =
      await SharedPreferences.getInstance();
      sharedPref
          .setString('password', _passwordcontroller.text);
      sharedPref
          .setString('myArea', _countrycontroller.text)
          .then((value) {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => MyAccount()));
      });
    // }else{
    //   print('notDone');
    // }
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
