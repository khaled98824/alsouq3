import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sooq1alzour/Auth/NewLogin.dart';
import 'package:sooq1alzour/ui/myAccount.dart';

class EditExchange extends StatefulWidget {
  @override
  _EditExchangeState createState() => _EditExchangeState();
}
bool equalName ;

class _EditExchangeState extends State<EditExchange> {
  void initState() {
    super.initState();
  }

  getCurrentUserInfo()async{

  }
  getUsersNames()async{


  }
  final _formkey = GlobalKey<FormState>();

  TextEditingController _idlibcontroller = TextEditingController();

  TextEditingController _damascuscontroller = TextEditingController();

  TextEditingController _alipocontroller = TextEditingController();


  @override
  void dispose() {
    _idlibcontroller.dispose();

    _damascuscontroller.dispose();

    _alipocontroller.dispose();

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
                          child: Text('Exchange',textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 17, fontFamily: 'AmiriQuran', height: 1)),
                        ),
                      ),
                    ),
                    SizedBox(height:60,),

                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        SizedBox(
                          width: 150,
                          child: TextFormField(
                            controller: _idlibcontroller,
                            textAlign: TextAlign.right,
                            keyboardType: TextInputType.numberWithOptions(
                                decimal: true),
                            decoration: InputDecoration(
                              hintText: 'Idlib',
                            ),
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Please Fill name Input';
                              }
                              // return 'Valid Name';
                            },
                          ),
                        ),
                        SizedBox(width: 55,),
                        Text("Idleb")
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        SizedBox(
                          width: 150,
                          child: TextFormField(
                            controller: _damascuscontroller,
                            textAlign: TextAlign.right,
                            keyboardType: TextInputType.numberWithOptions(
                                decimal: true),
                            decoration: InputDecoration(
                              hintText: 'Damascus',
                            ),
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Please Fill name Input';
                              }
                              // return 'Valid Name';
                            },
                          ),
                        ),
                        SizedBox(width: 20,),
                        Text("Damascus")
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        SizedBox(
                          width: 150,
                          child: TextFormField(
                            controller: _alipocontroller,
                            textAlign: TextAlign.right,
                            keyboardType: TextInputType.numberWithOptions(
                                decimal: true),
                            decoration: InputDecoration(
                              hintText: 'Alipo',
                            ),
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Please Fill name Input';
                              }
                              // return 'Valid Name';
                            },
                          ),
                        ),
                        SizedBox(width: 55,),
                        Text("Alipo")
                      ],
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
    Firestore.instance.collection('exchange').document('nKgOzaI384OHov7vdZry')
        .updateData({
      'dEx': int.parse(_idlibcontroller.text),
      'adEx': int.parse(_alipocontroller.text),
      'shEx': int.parse(_damascuscontroller.text),
      "lastUpdate": DateFormat('yyyy-MM-dd-HH:mm')
          .format(DateTime.now()),
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
