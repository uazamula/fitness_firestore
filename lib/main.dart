//import 'dart:html';

import 'package:cloud_firestore/cloud_firestore.dart';
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


/*import 'package:flutter/material.dart';

void main() {
  runApp(Example());
}

class Example extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ExampleState();
}

class _ExampleState extends State<Example> {

  String dropdownValue = 'One';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child:  DropdownButton<String>(
          value: dropdownValue,
          icon: const Icon(Icons.arrow_downward),
          iconSize: 24,
          elevation: 16,
          style: const TextStyle(
              color: Colors.deepPurple
          ),
          underline: Container(
            height: 2,
            color: Colors.deepPurpleAccent,
          ),
          onChanged: (String? newValue) {
            setState(() {
              dropdownValue = newValue!;
            });
          },
          items: <String>['One', 'Two', 'Free', 'Four']
              .map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          })
              .toList(),
        ),
        ),
      ),
    );
  }
}*/



void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MaxFitApp());

 /* var collection = FirebaseFirestore.instance.collection('collection');
  var snapshots = await collection.get();
  for (var doc in snapshots.docs) {
    await doc.reference.delete();
  }*/
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


