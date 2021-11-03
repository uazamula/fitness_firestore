//import 'dart:html';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:fitness_firestore/domain/my_user.dart';
import 'package:fitness_firestore/screens/auth.dart';
import 'package:fitness_firestore/screens/landind.dart';
import 'package:fitness_firestore/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:fitness_firestore/screens/home.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:provider/provider.dart';
import 'domain/workout.dart';

// https://www.developerlibs.com/2019/06/flutter-ide-shortcuts-faster-efficient-development.html
// https://developer.android.com/studio/build/multidex
// https://stackoverflow.com/questions/63492211/no-firebase-app-default-has-been-created-call-firebase-initializeapp-in
// ПРОЕКТ Flutter+Firestore (RU): #3 - Firebase Auth сервис (часть 1)


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(Phoenix(child: MaxFitApp()));

 /* var collection = FirebaseFirestore.instance.collection('collection');
  var snapshots = await collection.get();
  for (var doc in snapshots.docs) {
    await doc.reference.delete();
  }*/
}

class MaxFitApp extends StatelessWidget {


  var authService = AuthService();
  //static var isLogged=false;
  @override
  build(BuildContext context) {
    //Add StreamProvider  ПРОЕКТ Flutter+Firestore (RU): #3 - Firebase Auth провайдер (часть 2)
    return StreamProvider<User?>.value(
      value:authService.currentUser,
      initialData: Provider.of<User?>(context),
      child: MaterialApp(
        title: "MaxFitness",
        theme: ThemeData(
            primaryColor: Color.fromRGBO(50, 65, 85, 1),
            textTheme: TextTheme(headline6: TextStyle(color: Colors.white))),
        home: LandingPage(),
      ),
    );
  }
}


