//import 'dart:html';

import 'package:firebase_core/firebase_core.dart';
import 'package:fitness_firestore/domain/my_user.dart';
import 'package:fitness_firestore/screens/auth.dart';
import 'package:fitness_firestore/screens/landind.dart';
import 'package:fitness_firestore/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:fitness_firestore/screens/home.dart';
import 'package:provider/provider.dart';
import 'domain/workout.dart';

// https://www.developerlibs.com/2019/06/flutter-ide-shortcuts-faster-efficient-development.html
// https://developer.android.com/studio/build/multidex
// https://stackoverflow.com/questions/63492211/no-firebase-app-default-has-been-created-call-firebase-initializeapp-in

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MaxFitApp());
}

class MaxFitApp extends StatelessWidget {
  @override
  build(BuildContext context) {
    //Add StreamProvider  ПРОЕКТ Flutter+Firestore (RU): #3 - Firebase Auth провайдер (часть 2)
    return StreamProvider<MyUser?>.value(
      value:AuthService.currentUser,
      initialData: Provider.of<MyUser?>(context),
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

