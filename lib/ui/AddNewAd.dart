import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_info/device_info.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sooq1alzour/Auth/NewLogin.dart';
import 'package:sooq1alzour/models/PageRoute.dart';
import 'package:sooq1alzour/ui/Home.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'MyChats.dart';
import 'myAccount.dart';
import 'package:path/path.dart';
import 'package:image_cropper/image_cropper.dart';

class AddNewAd extends StatefulWidget {
  static const String id = "AddNewAd";
  @override
  _AddNewAdState createState() => _AddNewAdState();
}

bool loadingImage = false;
var time = DateFormat('yyyy-MM-dd-HH:mm').format(DateTime.now());
String priceText;
double price = 0;
File imageG;
File image;
File image2;
File image3;
File image4;
File image5;
File image6;
File image7;
String imageUrl;
String imageUrl2;
String imageUrl3;
String imageUrl4;
String imageUrl5;
String imageUrl6;
String imageUrl7;
int phone;

class _AddNewAdState extends State<AddNewAd> {
  bool choseCategory = true;
  bool choseCategory2 = true;
  bool statusShow = true;
  bool showAreaTextField = false;
  var dropItemsGames = [
    'إختر القسم الفرعي',
    'ألعاب موبايل',
    'ألعاب كمبيوتر',
    "ألعاب وتسالي الأطفال",
    "أخرى"
  ];
  var dropItemsOccupationsAndServices = [
    'إختر القسم الفرعي',
    'البناء',
    'صيانة المنزل',
    "خدمات التنظيف",
    "خدمات مناسبات",
    "خدمات توصيل",
    "أخرى"
  ];
  var dropItemsFood = [
    'إختر القسم الفرعي',
    'أجبان ألبان - مونة',
    'حلويات',
    "أطعمة شعبية",
    "أخرى"
  ];
  var dropItemsLivestocks = [
    'إختر القسم الفرعي',
    'أغنام',
    'أبقار',
    "طيور",
    "أعلاف"
  ];
  var dropItemsFarming = [
    'إختر القسم الفرعي',
    'معدات زراعية',
    'مواد زراعية وبذور',
    "ورش الأعمال الزراعية",
    "مشاتل - أغراس"
  ];
  var dropItemsClothes = [
    'إختر القسم الفرعي',
    'ألبسة رجالية',
    'ألبسة نسائية',
    "ألبسة ولادي-بناتي",
    "ألبسة أطفال",
    "أقمشة"
  ];
  var dropItemsHome = [
    'إختر القسم الفرعي',
    'أجهزة كهربائية',
    'أثاث',
    "منسوجات - سجاد",
    "أدوات المطبخ",
    "أبواب - شبابيك - ألمنيوم",
    "أخرى"
  ];
  var dropItemsDevicesAndElectronics = [
    'إختر القسم الفرعي',
    'لابتوب - كمبيوتر',
    'تلفزيون شاشات',
    "كاميرات - تصوير",
    "طابعات",
    "راوترات - أجهزة إنترنت",
    "أخرى"
  ];
  var dropItemsCars = [
    'إختر القسم الفرعي',
    'سيارات للبيع',
    'سيارات للإيجار',
    "قطع غيار",
    "دراجات نارية للبيع"
  ];
  var dropItemsMobile = [
    'إختر القسم الفرعي',
    'أبل',
    'هواوي',
    'سامسونج',
    'صيانة الموبايل',
    'إكسسوارات'
  ];
  var dropItemsCategory2 = [
    'إختر القسم الفرعي',
  ];
  var dropSelectItemCategory2 = 'إختر القسم الفرعي';
  String category2 = '';

  var dropItemsCategory = [
    'إختر القسم الرئيسي',
    'السيارات - الدراجات',
    'الموبايل',
    'أجهزة - إلكترونيات',
    'وظائف وأعمال',
    'مهن وخدمات',
    'المنزل',
    'المعدات والشاحنات',
    'المواشي',
    'الزراعة',
    'ألعاب',
    'ألبسة',
    'أطعمة'
  ];
  var dropSelectItemCategory = 'إختر القسم الرئيسي';
  String category = '';
  List<String> dropItemsArea = [
    'إختر المحافظة',];

  var dropSelectItemArea = 'إختر المحافظة';
  String area = '';
  bool chacked = false;
  bool chacked2 = false;
  TextEditingController nameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController areaController = TextEditingController();

  final _formkey = GlobalKey<FormState>();

  var status = 'مستعمل';
  var urlImages = List<String>();
  Future uploadImage(BuildContext context) async {
    String fileName = basename(image.path);
    StorageReference firebaseStorageRef =
        FirebaseStorage.instance.ref().child(fileName);
    StorageUploadTask uploadTask = firebaseStorageRef.putFile(image);
    (await uploadTask.onComplete).ref.getDownloadURL().then((url) {
      setState(() {
        imageUrl = url;
        urlImages.add(imageUrl);
      });
    });
    setState(() {
      print("Picture uploaded");
      imageUrl = imageUrl;
      loadingImage = false;
    });
  }

  Future uploadImage2(BuildContext context) async {
    String fileName = basename(image2.path);
    StorageReference firebaseStorageRef =
        FirebaseStorage.instance.ref().child(fileName);
    StorageUploadTask uploadTask = firebaseStorageRef.putFile(image2);
    (await uploadTask.onComplete).ref.getDownloadURL().then((url) {
      setState(() {
        imageUrl2 = url;
        urlImages.add(imageUrl2);
      });
    });
    setState(() {
      print("Picture uploaded");
      imageUrl2 = imageUrl;
      loadingImage = false;
    });
  }

  Future uploadImage3(BuildContext context) async {
    String fileName = basename(image3.path);
    StorageReference firebaseStorageRef =
        FirebaseStorage.instance.ref().child(fileName);
    StorageUploadTask uploadTask = firebaseStorageRef.putFile(image3);
    (await uploadTask.onComplete).ref.getDownloadURL().then((url) {
      setState(() {
        imageUrl3 = url;
        urlImages.add(imageUrl3);
      });
    });
    setState(() {
      print("Picture uploaded");
      imageUrl3 = imageUrl;
      loadingImage = false;
    });
  }

  Future uploadImage4(BuildContext context) async {
    String fileName = basename(image4.path);
    StorageReference firebaseStorageRef =
        FirebaseStorage.instance.ref().child(fileName);
    StorageUploadTask uploadTask = firebaseStorageRef.putFile(image4);
    (await uploadTask.onComplete).ref.getDownloadURL().then((url) {
      setState(() {
        imageUrl4 = url;
        urlImages.add(imageUrl4);
      });
    });
    setState(() {
      print("Picture uploaded");
      imageUrl4 = imageUrl;
      loadingImage = false;
    });
  }

  Future uploadImage5(BuildContext context) async {
    String fileName = basename(image5.path);
    StorageReference firebaseStorageRef =
        FirebaseStorage.instance.ref().child(fileName);
    StorageUploadTask uploadTask = firebaseStorageRef.putFile(image5);
    (await uploadTask.onComplete).ref.getDownloadURL().then((url) {
      setState(() {
        imageUrl5 = url;
        urlImages.add(imageUrl5);
      });
    });
    setState(() {
      print("Picture uploaded");
      imageUrl5 = imageUrl;
      loadingImage = false;
    });
  }

  Future uploadImage6(BuildContext context) async {
    String fileName = basename(image6.path);
    StorageReference firebaseStorageRef =
        FirebaseStorage.instance.ref().child(fileName);
    StorageUploadTask uploadTask = firebaseStorageRef.putFile(image6);
    (await uploadTask.onComplete).ref.getDownloadURL().then((url) {
      setState(() {
        imageUrl6 = url;
        urlImages.add(imageUrl6);
      });
    });
    setState(() {
      print("Picture uploaded");
      imageUrl6 = imageUrl;
      loadingImage = false;
    });
  }

  Future uploadImage7(BuildContext context) async {
    String fileName = basename(image7.path);
    StorageReference firebaseStorageRef =
        FirebaseStorage.instance.ref().child(fileName);
    StorageUploadTask uploadTask = firebaseStorageRef.putFile(image7);
    (await uploadTask.onComplete).ref.getDownloadURL().then((url) {
      setState(() {
        imageUrl7 = url;
        urlImages.add(imageUrl7);
      });
    });
    setState(() {
      print("Picture uploaded");
      imageUrl7 = imageUrl;
      loadingImage = false;
    });
  }

  File _image;
  Future getImage(context) async {
    imageG = await ImagePicker.pickImage(source: ImageSource.gallery);

    File croppedFile = await ImageCropper.cropImage(
      sourcePath: imageG.path,
      maxWidth: 1200,
      maxHeight: 1400,
    );
    // var result = await FlutterImageCompress.compressAndGetFile(
    //   croppedFile.path,
    //   imageG.path,
    //
    //   quality: 80,
    // );

    setState(() {
      _image = croppedFile;
      print('compres:${_image.lengthSync()}');
    });

    setState(() {
      if (image == null) {
        image = _image;
        loadingImage = true;
        uploadImage(context);
      } else if (image2 == null) {
        image2 = _image;
        loadingImage = true;
        uploadImage2(context);
      } else if (image3 == null) {
        image3 = _image;
        loadingImage = true;
        uploadImage3(context);
      } else if (image4 == null) {
        image4 = _image;
        loadingImage = true;
        uploadImage4(context);
      } else if (image5 == null) {
        image5 = _image;
        loadingImage = true;
        uploadImage5(context);
      } else if (image6 == null) {
        image6 = _image;
        loadingImage = true;
        uploadImage6(context);
      } else if (image7 == null) {
        image7 = _image;
        loadingImage = true;
        uploadImage7(context);
      }
    });
  }

  getInfoDevice() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    var infoData = androidInfo.androidId;
    setState(() {
      deviceNo = infoData;
      print(deviceNo);
    });
  }

  getIosInfo() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
    setState(() {
      deviceNo = iosInfo.identifierForVendor;
      print(deviceNo);
    });
  }

  String deviceNo = '';

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
    if (Platform.isAndroid) {
      getInfoDevice();
    } else {
      getIosInfo();
    }
    addNewZ();
  }

  QuerySnapshot documentsAds;
  List<String> newZList = [];
  DocumentSnapshot usersList;

  addNewZ() async {
    var firestore = Firestore.instance;

    QuerySnapshot qusListUsers =
        await firestore.collection('NewZios').getDocuments();
    if (qusListUsers != null) {
      for (int i = 0; qusListUsers.documents.length > newZList.length; i++) {
        setState(() {
          newZList.add(qusListUsers.documents[i]['Z']);
        });
      }
      if (newZList.length > 1) {
        setState(() {
          dropItemsArea = newZList;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Material(
      color: Colors.white60,
      child: Stack(
        overflow: Overflow.visible,
        children: <Widget>[
          Scaffold(
            body: Form(
              key: _formkey,
              child: Container(
                child: ListView(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        SizedBox(
                          width: 1,
                        ),
                        Text(
                          'أضف إعلانك',
                          style: TextStyle(
                              fontSize: 22,
                              fontFamily: 'AmiriQuran',
                              height: 1.5),
                        ),
                        InkWell(
                            onTap: () {
                              Navigator.pushReplacement(
                                  context, BouncyPageRoute(widget: Home()));
                              loadingImage = false;
                            },
                            child: Icon(
                              Icons.arrow_forward_ios,
                              size: 33,
                            )),
                      ],
                    ),
                    Padding(padding: EdgeInsets.only(top: 5)),
                    Container(
                      color: Colors.grey[300],
                      child: Wrap(
                        alignment: WrapAlignment.end,
                        crossAxisAlignment: WrapCrossAlignment.start,
                        children: <Widget>[
                          Padding(padding: EdgeInsets.only(right: 4)),
                          Padding(
                              padding:
                                  EdgeInsets.only(bottom: 5, top: 3, right: 5),
                              child: Stack(
                                alignment: Alignment(1, -2),
                                children: <Widget>[
                                  InkWell(
                                    onTap: () {
                                      getImage(context);
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          color: Colors.blue),
                                      height: 60,
                                      width: 85,
                                      child: Column(
                                        children: <Widget>[
                                          Icon(
                                            Icons.add_a_photo,
                                            size: 36,
                                            color: Colors.white,
                                          ),
                                          Text(
                                            'أضف صورة',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.white),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                  Align(
                                    alignment: Alignment(-1, 0),
                                    child: IconButton(
                                        icon: Icon(
                                          Icons.delete_forever,
                                          size: 30,
                                          color: Colors.red,
                                        ),
                                        onPressed: deleteImage),
                                  ),
                                  loadingImage
                                      ? Opacity(
                                          opacity: 0.6,
                                          child: Container(
                                            color: Colors.white,
                                            height: 60,
                                            width: 85,
                                            child: Padding(
                                              padding:
                                                  EdgeInsets.only(bottom: 18),
                                              child: Center(
                                                child: SpinKitFadingCircle(
                                                  color: Colors.red,
                                                  size: 70,
                                                  duration:
                                                      Duration(seconds: 2),
                                                ),
                                              ),
                                            ),
                                          ),
                                        )
                                      : Center(),
                                ],
                              )),
                          Wrap(
                            crossAxisAlignment: WrapCrossAlignment.end,
                            alignment: WrapAlignment.end,
                            children: <Widget>[
                              image7 != null
                                  ? Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      width: 50,
                                      height: 50,
                                      child: image7 != null
                                          ? Image.file(
                                              image7,
                                              fit: BoxFit.fill,
                                            )
                                          : Container(),
                                    )
                                  : Container(),
                              Padding(padding: EdgeInsets.only(right: 4)),
                              image6 != null
                                  ? Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      width: 50,
                                      height: 50,
                                      child: image6 != null
                                          ? Image.file(
                                              image6,
                                              fit: BoxFit.fill,
                                            )
                                          : Container(),
                                    )
                                  : Container(),
                              Padding(padding: EdgeInsets.only(right: 4)),
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                width: 50,
                                height: 50,
                                child: image5 != null
                                    ? Image.file(
                                        image5,
                                        fit: BoxFit.fill,
                                      )
                                    : Container(),
                              ),
                              Padding(padding: EdgeInsets.only(right: 4)),
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                width: 50,
                                height: 50,
                                child: image4 != null
                                    ? Image.file(
                                        image4,
                                        fit: BoxFit.fill,
                                      )
                                    : Container(),
                              ),
                              Padding(padding: EdgeInsets.only(right: 4)),
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                width: 50,
                                height: 50,
                                child: image3 != null
                                    ? Image.file(
                                        image3,
                                        fit: BoxFit.fill,
                                      )
                                    : Container(),
                              ),
                              Padding(padding: EdgeInsets.only(right: 4)),
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                width: 50,
                                height: 50,
                                child: image2 != null
                                    ? Image.file(
                                        image2,
                                        fit: BoxFit.fill,
                                      )
                                    : Container(),
                              ),
                              Padding(padding: EdgeInsets.only(right: 4)),
                              Padding(
                                padding: EdgeInsets.only(right: 4),
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  width: 50,
                                  height: 50,
                                  child: image != null
                                      ? Image.file(
                                          image,
                                          fit: BoxFit.fill,
                                        )
                                      : Container(),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Padding(padding: EdgeInsets.only(top: 3)),
                    Container(
                      width: MediaQuery.of(context).size.width - 5,
                      height: 4,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(1),
                        color: Colors.grey[300],
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        // ignore: deprecated_member_use
                        setState(() {
                          choseCategory = true;
                        });
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Icon(
                            Icons.arrow_back_ios,
                            size: 26,
                            color: Colors.grey[600],
                          ),
                          Padding(
                              padding: EdgeInsets.only(right: 1),
                              child: Text(
                                'ما الذي تريد بيعه أو الإعلان عنه ؟',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 20,
                                    fontFamily: 'AmiriQuran',
                                    height: 1.5),
                              )),
                        ],
                      ),
                    ),
                    choseCategory
                        ? Padding(
                            padding: EdgeInsets.only(right: 10),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: <Widget>[
                                Wrap(
                                  crossAxisAlignment: WrapCrossAlignment.center,
                                  alignment: WrapAlignment.end,
                                  children: <Widget>[
                                    DropdownButton<String>(
                                      iconSize: 30,
                                      style:
                                          TextStyle(color: Colors.green[800]),
                                      items: dropItemsCategory
                                          .map((String selectItem) {
                                        return DropdownMenuItem(
                                            value: selectItem,
                                            child: Text(selectItem));
                                      }).toList(),
                                      isExpanded: false,
                                      dropdownColor: Colors.grey[200],
                                      iconDisabledColor: Colors.green[800],
                                      iconEnabledColor: Colors.green[800],
                                      icon: Padding(
                                          padding: EdgeInsets.only(
                                              left: 10, right: 5),
                                          child: Icon(
                                            Icons.menu,
                                            size: 28,
                                          )),
                                      onChanged: (String theDate) {
                                        setState(() {
                                          dropItemsCategory2 = null;
                                          dropSelectItemCategory = null;
                                          dropSelectItemCategory2 = null;
                                          dropSelectItemCategory = theDate;
                                          category = dropSelectItemCategory;
                                          if (dropSelectItemCategory ==
                                              dropItemsCategory[2]) {
                                            dropItemsCategory2 =
                                                dropItemsMobile;
                                            choseCategory2 = true;
                                            statusShow = true;
                                            dropSelectItemCategory2 =
                                                dropSelectItemCategory2;
                                            category2 = dropItemsMobile[1];
                                          } else if (dropSelectItemCategory ==
                                              dropItemsCategory[1]) {
                                            choseCategory2 = true;
                                            statusShow = true;
                                            dropItemsCategory2 = dropItemsCars;
                                            dropSelectItemCategory2 =
                                                dropSelectItemCategory2;
                                            category2 = dropItemsCars[1];
                                          } else if (dropSelectItemCategory ==
                                              dropItemsCategory[3]) {
                                            choseCategory2 = true;
                                            statusShow = true;
                                            dropItemsCategory2 =
                                                dropItemsDevicesAndElectronics;
                                            dropSelectItemCategory2 =
                                                dropSelectItemCategory2;
                                            category2 =
                                                dropItemsDevicesAndElectronics[
                                                    1];
                                          } else if (dropSelectItemCategory ==
                                              dropItemsCategory[4]) {
                                            choseCategory2 = false;
                                            statusShow = false;
                                            category2 = dropSelectItemCategory;
                                          } else if (dropSelectItemCategory ==
                                              dropItemsCategory[5]) {
                                            choseCategory2 = true;
                                            statusShow = false;
                                            dropItemsCategory2 =
                                                dropItemsOccupationsAndServices;
                                            dropSelectItemCategory2 =
                                                dropSelectItemCategory2;
                                            category2 =
                                                dropItemsOccupationsAndServices[
                                                    1];
                                          } else if (dropSelectItemCategory ==
                                              dropItemsCategory[6]) {
                                            choseCategory2 = true;
                                            statusShow = true;
                                            dropItemsCategory2 = dropItemsHome;
                                            dropSelectItemCategory2 =
                                                dropSelectItemCategory2;
                                            category2 = dropItemsHome[1];
                                          } else if (dropSelectItemCategory ==
                                              dropItemsCategory[7]) {
                                            choseCategory2 = false;
                                            statusShow = true;
                                            category2 = dropSelectItemCategory;
                                            category = dropSelectItemCategory;
                                          } else if (dropSelectItemCategory ==
                                              dropItemsCategory[8]) {
                                            choseCategory2 = true;
                                            statusShow = false;
                                            dropItemsCategory2 =
                                                dropItemsLivestocks;
                                            dropSelectItemCategory2 =
                                                dropSelectItemCategory2;
                                            category2 = dropItemsLivestocks[1];
                                          } else if (dropSelectItemCategory ==
                                              dropItemsCategory[9]) {
                                            choseCategory2 = true;
                                            statusShow = true;
                                            dropItemsCategory2 =
                                                dropItemsFarming;
                                            dropSelectItemCategory2 =
                                                dropSelectItemCategory2;
                                            category2 = dropItemsFarming[1];
                                          } else if (dropSelectItemCategory ==
                                              dropItemsCategory[10]) {
                                            choseCategory2 = true;
                                            statusShow = true;
                                            dropItemsCategory2 = dropItemsGames;
                                            dropSelectItemCategory2 =
                                                dropSelectItemCategory2;
                                            category2 = dropItemsGames[1];
                                          } else if (dropSelectItemCategory ==
                                              dropItemsCategory[11]) {
                                            choseCategory2 = true;
                                            statusShow = true;
                                            dropItemsCategory2 =
                                                dropItemsClothes;
                                            dropSelectItemCategory2 =
                                                dropSelectItemCategory2;
                                            category2 = dropItemsClothes[1];
                                          } else if (dropSelectItemCategory ==
                                              dropItemsCategory[12]) {
                                            choseCategory2 = true;
                                            statusShow = true;
                                            dropItemsCategory2 = dropItemsFood;
                                            dropSelectItemCategory2 =
                                                dropSelectItemCategory2;
                                            category2 = dropItemsFood[1];
                                          }
                                        });
                                        print(category);
                                        print(category2);
                                      },
                                      value: dropSelectItemCategory,
                                      elevation: 7,
                                    ),
                                    Text(
                                      ': إختر القسم الرئيسي ',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontFamily: 'AmiriQuran',
                                          height: 0.5),
                                    ),
                                  ],
                                ),
                                choseCategory2
                                    ? Wrap(
                                        crossAxisAlignment:
                                            WrapCrossAlignment.center,
                                        alignment: WrapAlignment.end,
                                        children: <Widget>[
                                          DropdownButton<String>(
                                            iconSize: 30,
                                            style: TextStyle(
                                                color: Colors.green[800]),
                                            items: dropItemsCategory2
                                                .map((String selectItem) {
                                              return DropdownMenuItem(
                                                  value: selectItem,
                                                  child: Text(selectItem));
                                            }).toList(),
                                            isExpanded: false,
                                            dropdownColor: Colors.grey[200],
                                            iconDisabledColor:
                                                Colors.green[800],
                                            iconEnabledColor: Colors.green[800],
                                            icon: Padding(
                                                padding: EdgeInsets.only(
                                                    left: 8, right: 5),
                                                child: Icon(
                                                  Icons.menu,
                                                  size: 27,
                                                )),
                                            onChanged: (String theDate) {
                                              setState(() {
                                                dropSelectItemCategory2 =
                                                    theDate;
                                                category2 =
                                                    dropSelectItemCategory2;
                                              });
                                              print(category);
                                              print(category2);
                                            },
                                            value: dropSelectItemCategory2,
                                            elevation: 7,
                                          ),
                                          Text(
                                            ': إختر القسم الفرعي ',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontFamily: 'AmiriQuran',
                                                height: 0.5),
                                          ),
                                        ],
                                      )
                                    : Container(),
                              ],
                            ),
                          )
                        : Container(),
                    Padding(
                      padding: EdgeInsets.only(top: 2),
                      child: Container(
                        width: MediaQuery.of(context).size.width - 5,
                        height: 4,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(1),
                          color: Colors.grey[300],
                        ),
                      ),
                    ),
                    Wrap(
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(
                              right: 10, left: 10, bottom: 2, top: 2),
                          child: SizedBox(
                            height: 54,
                            width: 240,
                            child: TextFormField(
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'أدخل إسم لإعلانك';
                                }
                              },
                              maxLines: 1,
                              maxLength: 32,
                              controller: nameController,
                              textAlign: TextAlign.right,
                              decoration: InputDecoration(
                                hintText: '"مثال : "آيفون ٧ للبيع',
                                hintStyle: TextStyle(
                                    fontSize: 14,
                                    height: 1
                                ),
                              ),
                            ),
                          ),
                        ),
                        Text(
                          'ضع إسم للإعلان',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 16,
                              fontFamily: 'AmiriQuran',
                              height: 1),
                        ),
                      ],
                      alignment: WrapAlignment.center,
                      crossAxisAlignment: WrapCrossAlignment.center,
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 2),
                      child: Container(
                        width: MediaQuery.of(context).size.width - 5,
                        height: 4,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(1),
                          color: Colors.grey[300],
                        ),
                      ),
                    ),
                    Wrap(
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(
                              right: 10, left: 5, bottom: 2, top: 4),
                          child: SizedBox(
                            height: 80,
                            width: 230,
                            child: TextFormField(
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'أدخل تفاصيل اكثر لإعلانك';
                                }
                                // return 'Valid Name';
                              },
                              maxLines: 10,
                              controller: descriptionController,
                              textAlign: TextAlign.right,
                              decoration: InputDecoration(
                                enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.blue),
                                    borderRadius: BorderRadius.circular(10)),
                                hintText: 'ضع تفاصيل أكثر لإعلانك ',
                                fillColor: Colors.grey,
                                hoverColor: Colors.grey,
                              ),
                              cursorRadius: Radius.circular(5),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(right: 12),
                          child: Text(
                            'ضع وصف للإعلان',
                            textAlign: TextAlign.start,
                            style: TextStyle(
                                fontSize: 16,
                                fontFamily: 'AmiriQuran',
                                height: 1.8),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 4),
                          child: Container(
                            width: MediaQuery.of(context).size.width - 5,
                            height: 4,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(1),
                              color: Colors.grey[300],
                            ),
                          ),
                        ),
                      ],
                      alignment: WrapAlignment.center,
                      crossAxisAlignment: WrapCrossAlignment.start,
                    ),
                    statusShow
                        ? Wrap(
                            crossAxisAlignment: WrapCrossAlignment.center,
                            alignment: WrapAlignment.end,
                            children: <Widget>[
                              Text(
                                ': إختر الحالة جديد أم مستعمل ',
                                textAlign: TextAlign.justify,
                                style: TextStyle(
                                    fontSize: 18,
                                    fontFamily: 'AmiriQuran',
                                    height: 1.8),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Column(
                                children: <Widget>[
                                  CheckboxListTile(
                                    title: Text(
                                      'جديد',
                                      textAlign: TextAlign.right,
                                      style: TextStyle(
                                          fontSize: 19,
                                          fontFamily: 'AmiriQuran',
                                          height: 0.5),
                                    ),
                                    controlAffinity:
                                        ListTileControlAffinity.trailing,
                                    value: chacked,
                                    onChanged: (value) {
                                      setState(() {
                                        chacked = value;
                                        chacked2 = false;
                                        status = 'جديد';
                                      });
                                    },
                                  ),
                                  CheckboxListTile(
                                    title: Text(
                                      'مستعمل',
                                      textAlign: TextAlign.right,
                                      style: TextStyle(
                                          fontSize: 19,
                                          fontFamily: 'AmiriQuran',
                                          height: 0.5),
                                    ),
                                    controlAffinity:
                                        ListTileControlAffinity.trailing,
                                    value: chacked2,
                                    onChanged: (value) {
                                      setState(() {
                                        chacked2 = value;
                                        chacked = false;
                                        status = 'مستعمل';
                                      });
                                    },
                                  )
                                ],
                              )
                            ],
                          )
                        : Container(),
                    Padding(
                      padding: EdgeInsets.only(top: 0),
                      child: Container(
                        width: MediaQuery.of(context).size.width - 5,
                        height: 4,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(1),
                          color: Colors.grey[300],
                        ),
                      ),
                    ),
                    Container(
                      child: Padding(
                        padding: EdgeInsets.only(right: 10),
                        child: Wrap(
                          crossAxisAlignment: WrapCrossAlignment.center,
                          alignment: WrapAlignment.end,
                          children: <Widget>[
                            DropdownButton<String>(
                              iconSize: 22,
                              style: TextStyle(color: Colors.green[800]),
                              items: dropItemsArea.map((String selectItem) {
                                return DropdownMenuItem(
                                    value: selectItem, child: Text(selectItem));
                              }).toList(),
                              isExpanded: false,
                              dropdownColor: Colors.grey[200],
                              iconDisabledColor: Colors.green[800],
                              iconEnabledColor: Colors.green[800],
                              icon: Padding(
                                  padding: EdgeInsets.only(left: 6),
                                  child: Icon(
                                    Icons.menu,
                                    size: 26,
                                  )),
                              onChanged: (String theDate) {
                                setState(() {
                                  dropSelectItemArea = theDate;
                                  area = theDate;
                                  showAreaTextField = true;
                                });
                              },
                              value: dropSelectItemArea,
                              elevation: 7,
                            ),
                            Text(
                              'إختر المحافظة ثم أدخل منطقتك',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 16,
                                  fontFamily: 'AmiriQuran',
                                  height: 1),
                            ),
                            showAreaTextField
                                ? SizedBox(
                                    height: 52,
                                    width: 200,
                                    child: TextFormField(
                                      controller: areaController,
                                      validator: (value) {
                                        if (value.isEmpty) {
                                          return 'أدخل منطقتك ...';
                                        }
                                      },
                                      maxLength: 20,
                                      textAlign: TextAlign.right,
                                      decoration: InputDecoration(
                                        hintText: '... أدخل منطقتك هنا',
                                        hintStyle:
                                            TextStyle(fontSize: 15, height: 1),
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.blueAccent),
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide:
                                              BorderSide(color: Colors.green),
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                      ),
                                    ),
                                  )
                                : Container(),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 6),
                      child: Container(
                        width: MediaQuery.of(context).size.width - 5,
                        height: 4,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(1),
                          color: Colors.grey[300],
                        ),
                      ),
                    ),
                    Container(
                      child: Wrap(
                        alignment: WrapAlignment.end,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: <Widget>[
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.blueAccent,
                            ),
                            height: 30,
                            width: 1,
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                                top: 5, bottom: 3, left: 3, right: 1),
                            child: SizedBox(
                              width: 230,
                              height: 43,
                              child: TextFormField(
                                controller: priceController,
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return 'ضع سعر لإعلانك';
                                  }
                                  // return 'Valid Name';
                                },
                                keyboardType: TextInputType.numberWithOptions(
                                    decimal: true),
                                textAlign: TextAlign.right,
                                decoration: InputDecoration(
                                  enabledBorder: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.blueAccent),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.green),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  hintText:
                                      '!... أدخل السعر المطلوب ,ارقام انجليزية',
                                  hintStyle: TextStyle(
                                    fontSize: 14,
                                    height: 1
                                  ),
                                  fillColor: Colors.white,
                                  hoverColor: Colors.white,
                                ),
                                cursorRadius: Radius.circular(10),
                                onChanged: (val) {
                                  priceText = val;
                                },
                              ),
                            ),
                          ),
                          Padding(
                              padding: EdgeInsets.only(right: 2, top: 1),
                              child: Icon(
                                Icons.attach_money,
                                size: 40,
                                color: Colors.blueAccent,
                              )),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 1),
                      child: Container(
                        width: MediaQuery.of(context).size.width - 5,
                        height: 4,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(1),
                          color: Colors.grey[300],
                        ),
                      ),
                    ),
                    Container(
                      child: Wrap(
                        alignment: WrapAlignment.end,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.only(
                                top: 6, bottom: 3, left: 3, right: 1),
                            child: SizedBox(
                              width: 230,
                              height: 43,
                              child: TextFormField(
                                controller: phoneController,
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return '!... أدخل رقم جوالك';
                                  }
                                  // return 'Valid Name';
                                },
                                textAlign: TextAlign.right,
                                keyboardType: TextInputType.numberWithOptions(
                                    decimal: true),
                                decoration: InputDecoration(
                                  enabledBorder: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.blueAccent),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.green),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  hintText:
                                      '!... أدخل رقم جوالك, ارقام انجليزية',
                                  hintStyle: TextStyle(
                                      fontSize: 14,
                                      height: 1
                                  ),
                                  fillColor: Colors.white,
                                  hoverColor: Colors.white,
                                ),
                                cursorRadius: Radius.circular(10),
                                onChanged: (val) {},
                              ),
                            ),
                          ),
                          Padding(
                              padding: EdgeInsets.only(right: 2, top: 1),
                              child: Icon(
                                Icons.phone_iphone,
                                size: 40,
                                color: Colors.blueAccent,
                              )),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 1),
                      child: Container(
                        width: MediaQuery.of(context).size.width - 5,
                        height: 4,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(1),
                          color: Colors.grey[300],
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 3, bottom: 10),
                      child: Wrap(
                        alignment: WrapAlignment.center,
                        children: <Widget>[
                          SizedBox(
                            width: 140,
                            height: 54,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(30),
                              child: InkWell(
                                onTap: () {
                                  price = double.parse(priceText);
                                  if (priceController.text != null) {
                                    addAdFireStore(
                                        category,
                                        category2,
                                        nameController.text,
                                        time.toString(),
                                        status,
                                        descriptionController.text,
                                        area,
                                        price,
                                        deviceNo,
                                        imageUrl,
                                        imageUrl2,
                                        imageUrl3,
                                        imageUrl4,
                                        imageUrl5,
                                        imageUrl6,
                                        imageUrl7,
                                        phoneController.text,
                                        context);
                                  }
                                },
                                child: Card(
                                  color: Colors.blue[900],
                                  child: Center(
                                    child: Text('أنشر إعلانك',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontSize: 21,
                                            fontFamily: 'AmiriQuran',
                                            height: 1,
                                            color: Colors.white)),
                                  ),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 80,
                    )
                  ],
                ),
              ),
            ),
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
                bottom: size.height / 15,
                child: InkWell(
                  onTap: () {
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
                  },
                  child: Container(
                    width: 58,
                    height: 58,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: Color(0xffF26726)),
                    child: IconButton(
                      icon: Padding(
                          padding:
                              EdgeInsets.only(left: 3, right: 22, bottom: 5),
                          child: Icon(
                            Icons.add_a_photo,
                            size: 35,
                            color: Colors.white,
                          )),
                      onPressed: () {
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
                      },
                    ),
                  ),
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
                          Text(
                            'حسابي',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              height: 0.1,
                              fontFamily: 'AmiriQuran',
                            ),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          IconButton(
                              icon: Icon(
                                Icons.info,
                                color: currentIndex == 1
                                    ? Color(0xffF26726)
                                    : Colors.grey.shade600,
                              ),
                              onPressed: () {
                                setBottomBarIndex(1);
                                Navigator.push(context,
                                    BouncyPageRoute(widget: AboutUs()));
                              }),
                          Text(
                            'حول التطبيق',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              height: 0.1,
                              fontFamily: 'AmiriQuran',
                            ),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          Container(
                            width: size.width * 0.20,
                          ),
                          Text(
                            'أضف إعلان',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                height: 5,
                                fontFamily: 'AmiriQuran',
                                fontSize: 14,
                                color: Color(0xffF26726)),
                          ),
                        ],
                      ),
                      Column(
                        children: [
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
                          Text(
                            'محادثاتي',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              height: 0.1,
                              fontFamily: 'AmiriQuran',
                            ),
                          )
                        ],
                      ),
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
                          Text(
                            'الرئيسية',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              height: 0.1,
                              fontFamily: 'AmiriQuran',
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    newZList.clear();
  }

  deleteImage() {
    setState(() {
      image = null;
      image2 = null;
      image3 = null;
      image4 = null;
      image5 = null;
      image6 = null;
      image7 = null;
      imageUrl = null;
      imageUrl2 = null;
      imageUrl3 = null;
      imageUrl4 = null;
      imageUrl5 = null;
      imageUrl6 = null;
      imageUrl7 = null;
      urlImages.clear();
    });
  }

  addAdFireStore(
      _category,
      _department,
      _name,
      _time,
      _status,
      _description,
      _area,
      _price,
      _deviceNo,
      _image1,
      _image2,
      _image3,
      _image4,
      _image5,
      _image6,
      _image7,
      _phone,
      context) async {
    if (_image1 != null &&
        category != null &&
        category2 != null &&
        _image1 != null) {
      if (_formkey.currentState.validate()) {
        SharedPreferences sharedPref = await SharedPreferences.getInstance();
        Firestore.instance.collection('Ads').document().setData({
          'category': _category,
          'department': _department,
          'name': _name,
          'time': DateFormat('yyyy-MM-dd-HH:mm').format(DateTime.now()),
          'status': _status,
          'description': _description,
          'area': _area + ' = ' + areaController.text,
          'price': _price,
          'deviceNo': _deviceNo,
          'imagesUrl': urlImages,
          'phone': _phone,
          'uid': sharedPref.getString('name'),
          'likes': 0,
          'views': 0,
          'isRequest': false,
        });
        nameController.clear();
        descriptionController.clear();
        priceController.clear();
        phoneController.clear();
        imageUrl = null;
        imageUrl2 = null;
        imageUrl3 = null;
        imageUrl4 = null;
        imageUrl5 = null;
        imageUrl6 = null;
        imageUrl7 = null;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => Home()),
        );
        loadingImage = false;
      } else {
        print('please try later');
      }
    } else {
      showMessage('رجائاً تأكد من إضافة صورة واختيار اقسام إعلانك');
    }
  }

  showMessage(String msg) {
    Fluttertoast.showToast(
        msg: msg,
        gravity: ToastGravity.CENTER,
        toastLength: Toast.LENGTH_LONG,
        backgroundColor: Colors.blue,
        fontSize: 17,
        textColor: Colors.white);
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
