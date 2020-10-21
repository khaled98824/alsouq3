import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sign_button/sign_button.dart';
import 'package:sooq1alzour/Service/PushNotificationService.dart';
import 'package:sooq1alzour/models/StaticVirables.dart';
import 'package:sooq1alzour/ui/Home.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'apple_sign_in_available.dart';
import 'auth_service.dart';
import 'NewReg2.dart';
import 'package:fluttertoast/fluttertoast.dart';

GoogleSignIn _googleSignIn = GoogleSignIn(
  scopes: <String>[
    'email',
    'https://www.googleapis.com/auth/contacts.readonly',
  ],
);

class NewLogin extends StatefulWidget {
  static const String id = "LoginScreen";
  bool autoLogin;
  NewLogin({this.autoLogin});
  @override
  _NewLoginState createState() => _NewLoginState(autoLogin: autoLogin);
}

double screenSizeWidth2;
double screenSizeHieght2;
bool loginStatus = false;
bool checkboxVal = false;
bool logout;
bool checkLogin = false;
bool equalName;
List<String> _namesList = [];
FirebaseUser user;
String userUid;
String userName;
String currentUserId;
bool isSignIn = false;
FirebaseAuth _auth = FirebaseAuth.instance;


class _NewLoginState extends State<NewLogin> {
  Future<void> _signInWithApple(BuildContext context) async {
    try {
      final authService = Provider.of<AuthService>(context, listen: false);
      final user = await authService.signInWithApple();
      print('uid: ${user.uid}');
      userName = user.email;
      userUid = user.uid;
      currentUserId = user.uid;
      doSaveName();
      SharedPreferences sharedPref = await SharedPreferences.getInstance();
      sharedPref.setBool('appleSignIn', true);
      setState(() {
        loginStatus = true;
        userUid = user.uid;
      });
    } catch (e) {
      // TODO: Show alert here
      print(e);
    }
  }

  bool autoLogin;
  _NewLoginState({this.autoLogin});

  void initState() {
    super.initState();
    isSignIn =false;
    getUsersNames();
    if (autoLogin == false) {
      checkboxVal = false;
    } else {
      checkAutoLogin();
    }
  }

  getUsersNames() async {
    var firestore = Firestore.instance;
    QuerySnapshot qus = await firestore.collection('users').getDocuments();
    if (qus != null) {
      for (int i = 0; qus.documents.length > _namesList.length; i++) {
        setState(() {
          _namesList.add(qus.documents[i]['uid']);
        });
      }
    }
    print(_namesList);
  }

  checkAutoLogin() async {
    SharedPreferences sharedPref = await SharedPreferences.getInstance();
    if (sharedPref.getBool('autoLogin') == true) {
      setState(() {
        checkboxVal = sharedPref.getBool('autoLogin');
        if (checkboxVal) {
          autoLoginF();
        }
      });
    }

    print(checkboxVal);
  }

  autoLoginF() async {
    SharedPreferences sharedPref = await SharedPreferences.getInstance();
    setState(() {
      _passwordcontroller =
          TextEditingController(text: sharedPref.getString('password'));
      _namecontroller =
          TextEditingController(text: sharedPref.getString('name'));
    });

    Timer(Duration(milliseconds: 100), () {
      login();
    });
  }

  saveLoginAutoStatus() async {
    SharedPreferences sharedPref = await SharedPreferences.getInstance();
    sharedPref.setBool('autoLogin', autoLogin);
  }

  saveShared() async {
    SharedPreferences sharedPref = await SharedPreferences.getInstance();
    sharedPref.setString('password', _passwordcontroller.text);
    sharedPref.setInt('navigatorSelect', 1);
    sharedPref.setString('name', _namecontroller.text);
  }

  login() async {
    FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
    currentUserId = _namecontroller.text;
    if (_formkey.currentState.validate()) {
      var firestore = Firestore.instance;
      QuerySnapshot qus = await firestore
          .collection('users')
          .where('name', isEqualTo: _namecontroller.text)
          .getDocuments();
      saveShared();
      print(qus.documents[0]['password']);
      _firebaseMessaging.getToken().then((token) async {
        print("token: " + token);
        Firestore.instance
            .collection('users')
            .document(_namecontroller.text)
            .updateData({
          "token": token,
        });
      });
//eee

      if (qus.documents[0]['password'] == _passwordcontroller.text) {
        setState(() {
          currentUserId = _namecontroller.text;
          loginStatus = true;
        });
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => Home()),
        );
      } else {
        showMessage('خطأ في البيانات المدخله');
      }
    }
  }

  final _formkey = GlobalKey<FormState>();

  TextEditingController _namecontroller = TextEditingController();
  TextEditingController _passwordcontroller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final appleSignInAvailable =
        Provider.of<AppleSignInAvailable>(context, listen: false);
    // TODO: implement build
    screenSizeWidth2 = MediaQuery.of(context).size.width;
    screenSizeHieght2 = MediaQuery.of(context).size.height;
    Virables.screenSizeWidth = screenSizeWidth2;
    Virables.screenSizeHeight = screenSizeHieght2;
    Virables.login = loginStatus;
    Virables.autoLogin = logout;
    Virables.currentUserId = currentUserId;
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(5),
        child: Form(
            key: _formkey,
            child: ListView(
              children: <Widget>[
                Padding(padding: EdgeInsets.only(top: 3)),
                Center(
                  child: Text(
                    'تسجيل الدخول',
                    style: TextStyle(
                      fontSize: 20,
                      fontFamily: 'AmiriQuran',
                      height: 1,
                    ),
                  ),
                ),
                Padding(padding: EdgeInsets.only(top: 10)),
                ClipRRect(
                  child: Image.asset('assets/images/souq1624wpng.png'),
                ),
                Padding(padding: EdgeInsets.only(top: 30)),
                TextFormField(
                  controller: _namecontroller,
                  keyboardType: TextInputType.emailAddress,
                  textAlign: TextAlign.right,
                  decoration: InputDecoration(
                    hintText: 'إسم المستخدم',
                  ),
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please Fill Email Input';
                    }
                  },
                ),
                SizedBox(
                  height: 20,
                ),
                TextFormField(
                  controller: _passwordcontroller,
                  textAlign: TextAlign.right,
                  keyboardType: TextInputType.visiblePassword,
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
                  height: 5,
                ),
                RaisedButton(
                  color: Colors.blue,
                  child: Text(
                    'تسجيل الدخول',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontFamily: 'AmiriQuran',
                        height: 1),
                  ),
                  onPressed: () async {
                    login();
                  },
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'تسجيل دخول تلقائي',
                      style: TextStyle(
                          color: Colors.green[900],
                          fontSize: 18,
                          fontFamily: 'AmiriQuran',
                          height: 1),
                    ),
                    Checkbox(
                      value: checkboxVal,
                      onChanged: (bool val) {
                        autoLogin = val;
                        setState(() {
                          checkboxVal = val;
                        });
                        saveLoginAutoStatus();
                      },
                    ),
                  ],
                ),

                RaisedButton(
                  color: Colors.blue,
                  child: Text(
                    'تسجيل مستخدم جديد ',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontFamily: 'AmiriQuran',
                        height: 1),
                  ),
                  onPressed: () async {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => NewReg()));
                  },
                ),
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 5,horizontal: 5),
                  child: Container(
                    height: 1,
                    decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: Colors.grey
                  ),),
                ),
                if (appleSignInAvailable.isAvailable)
                  SignInButton(
                      buttonType: ButtonType.apple,
                      btnColor: Colors.black,
                      btnTextColor: Colors.white,
                      onPressed: () {
                        _signInWithApple(context);
                        print('click');
                      }),

                SizedBox(
                  height: 10,
                ),
                RaisedButton(
                  color: Colors.blue,
                  child: Text(
                    'Google تسجيل دخول بحساب ',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontFamily: 'AmiriQuran',
                        height: 1),
                  ),
                  onPressed: () async {
                    _handleSignIn(context);
                    //handleSignInGoogle();
                  },
                ),
                SizedBox(height: 10,),
                InkWell(
                  onTap: () {
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => Home()));
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Color(0xffF26726),
                    ),
                    width: 324,
                    height: 59,
                    child: Center(
                        child: Text(
                      'تصفح في السوق كزائر',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontFamily: 'AmiriQuran',
                          height: 1),
                    )),
                  ),
                ),
              ],
            )),
      ),
    );
  }

  doSaveName() async {
    equalName = false;
    for (int i = 0; i < _namesList.length; i++) {
      if (userUid == _namesList[i]) {
        equalName = true;
        showMessage('إسم المستخدم موجود مسبقاً رجاءاٌ اختر غيره');
      }
    }
    print(equalName);
    if (equalName == false) {
      print('done');
      //saveName();
      Firestore.instance.collection('users').document(userUid).setData({
        'name': 'ios',
        'user_uid': userUid,
        'area': 'ios',
        "time": DateFormat('yyyy-MM-dd-HH:mm').format(DateTime.now()),
        'token': 'nn'
      });
      FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
      _firebaseMessaging.getToken().then((token) async {
        print("token: " + token);
        Firestore.instance.collection('users').document(userUid).updateData({
          "token": token,
        });
      });
      SharedPreferences sharedPref = await SharedPreferences.getInstance();
      sharedPref.setString('name', userUid).then((value) {
        setState(() {
          loginStatus = true;
        });
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => Home()));
      });
    } else {
      print('notDone');
    }
  }

  Future<void> gooleSignout() async {
    await _auth.signOut().then((onValue) {
      _googleSignIn.signOut();
      setState(() {
        isSignIn = true;
      });
    });
  }
  Future<void> _handleSignIn(context) async {
    try {
      await _googleSignIn.signIn();
      setState(() {
        currentUserId = _googleSignIn.currentUser.id;
      });
      Firestore.instance.collection('users').document(_googleSignIn.currentUser.id).setData({
        'name': _googleSignIn.currentUser.displayName,
        'user_uid':_googleSignIn.currentUser.id,
        'area': 'google',
        "time": DateFormat('yyyy-MM-dd-HH:mm').format(DateTime.now()),
        'token': 'nn'
      });
      FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
      _firebaseMessaging.getToken().then((token) async {
        print("token: " + token);
        Firestore.instance.collection('users').document(_googleSignIn.currentUser.id).updateData({
          "token": token,
        });
      });
      SharedPreferences sharedPref = await SharedPreferences.getInstance();
      sharedPref.setString('name',_googleSignIn.currentUser.id ).then((value) {
        loginStatus = true;
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => Home()));
      });

    } catch (error) {
      showMessage('خطأ في عملية تسجيل الدخول');
      print(error);
    }
  }
  showMessage(String msg) {
    Fluttertoast.showToast(
        msg: msg,
        gravity: ToastGravity.CENTER,
        toastLength: Toast.LENGTH_LONG,
        backgroundColor: Colors.blue,
        fontSize: 15,
        textColor: Colors.white);
  }

  
}
// var firestore = Firestore.instance;
// QuerySnapshot qus = await firestore
//     .collection('users')
//     .where('name', isEqualTo:user.displayName)
//     .getDocuments();
