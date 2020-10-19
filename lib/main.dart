//mdsdsd
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:sooq1alzour/Service/PushNotificationService.dart';
import 'package:sooq1alzour/ui/AddNewAd.dart';
import 'package:sooq1alzour/ui/AllAds.dart';
import 'package:sooq1alzour/ui/Home.dart';
import 'package:sooq1alzour/ui/MyChats.dart';
import 'package:sooq1alzour/ui/SearchUi.dart';
import 'package:sooq1alzour/ui/SplashScreen.dart';
import 'package:provider/provider.dart';
import 'package:sooq1alzour/ui/categories/Cars&MotorCycles.dart';
import 'package:sooq1alzour/ui/categories/Clothes.dart';
import 'package:sooq1alzour/ui/categories/DevicesAndElectronics.dart';
import 'package:sooq1alzour/ui/categories/Farming.dart';
import 'package:sooq1alzour/ui/categories/Food.dart';
import 'package:sooq1alzour/ui/categories/Games.dart';
import 'package:sooq1alzour/ui/categories/Homes.dart';
import 'package:sooq1alzour/ui/categories/Livestocks.dart';
import 'package:sooq1alzour/ui/categories/Mobile.dart';
import 'package:sooq1alzour/ui/categories/OccupationsAndServices.dart';
import 'package:sooq1alzour/ui/myAccount.dart';

import 'Auth/apple_sign_in_available.dart';
import 'Auth/auth_service.dart';


void setupLocator() {
  GetIt.I.registerLazySingleton(() => PushNotificationService());
}

void main() async {
  setupLocator();
   //Fix for : Unhandled Exception: ServicesBinding.defaultBinaryMessenger was accessed before the binding was initialized.
   WidgetsFlutterBinding.ensureInitialized();
   //final appleSignInAvailable = await AppleSignInAvailable.check();
  runApp(
     //   Provider<AppleSignInAvailable>.value(
     // value: appleSignInAvailable,
     // child:
    MyApp(),
  //)
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return
      // Provider<AuthService>(
      // create: (_) => AuthService(),
      // child:
      MaterialApp(
        title: 'Souq Alfurat',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.indigo,
        ),
        routes: {
          MyChats.id : (context) => MyChats(),
          SearchUi.id : (context) => SearchUi(),
          Ads.id : (context) => Ads(),
          Home.id : (context) => Home(),
          MyAccount.id : (context) => MyAccount(),
          AddNewAd.id : (context) => AddNewAd(),
          Food.id : (context) => Food(),
          Clothes.id : (context) => Clothes(),
          Games.id : (context) => Games(),
          Farming1.id : (context) => Farming1(),
          Livestock.id : (context) => Livestock(),
          Homes.id : (context) => Homes(),
          OccupationsAndServices.id : (context) => OccupationsAndServices(),
          Mobile.id : (context) => Mobile(),
          DevicesAndElectronics.id : (context) => DevicesAndElectronics(),
          CarsAndMotorCycles.id : (context) => CarsAndMotorCycles(),
        },
        home: SplashScreen(),
      //),
   // )
    );
  }
}
