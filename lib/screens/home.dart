import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitness_firestore/components/active_workouts.dart';
import 'package:fitness_firestore/components/workout_list.dart';
import 'package:fitness_firestore/screens/add_workout.dart';
import 'package:fitness_firestore/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:fitness_firestore/domain/workout.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int sectionIndex = 0;

  resetPassword() async {
    try {
      String? email = FirebaseAuth.instance.currentUser!.email;
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email!=null?email:"" );
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.orangeAccent,
          content: Text(
            'Password Reset Email has been sent !',
            style: TextStyle(fontSize: 18.0),
          ),
        ),
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.orangeAccent,
            content: Text(
              'No user found for that email.',
              style: TextStyle(fontSize: 18.0),
            ),
          ),
        );
      }
    }
  }
  @override
  Widget build(BuildContext context) {
    var authService = AuthService();
    var myCurvedNavigationBar = CurvedNavigationBar(
      items: [
        Icon(Icons.fitness_center),
        Icon(Icons.search),
      ],
      index: 0,
      height: 55,
      color: Colors.white.withOpacity(0.5),
      buttonBackgroundColor: Colors.white,
      backgroundColor: Colors.white.withOpacity(0.5),
      animationCurve: Curves.bounceInOut,
      animationDuration: Duration(milliseconds: 500),
      onTap: (int index) {
        setState(() => sectionIndex = index);
      },
    );

    return Container(
      child: Scaffold(
        backgroundColor: Theme.of(context).primaryColor,
        appBar: AppBar(
          title: Text('MaxFit // ' +
              (sectionIndex == 0 ? 'Active Workouts' : 'Find Workouts')),
          leading: Icon(Icons.fitness_center),
          actions: [
            TextButton.icon(
              onPressed: () {


resetPassword();





              },
              icon: Icon(Icons.email, color: Colors.white),
              label: SizedBox.shrink(),
            ),
            TextButton.icon(
              onPressed: () {
                authService.logOut();
              },
              icon: Icon(Icons.supervised_user_circle, color: Colors.white),
              label: SizedBox.shrink(),
            )
          ],
        ),
        body: sectionIndex == 0 ? ActiveWorkouts() : WorkoutsList(),
        bottomNavigationBar: myCurvedNavigationBar,
        //TODO
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          backgroundColor: Colors.pinkAccent,
          foregroundColor: Theme.of(context).primaryColor,
          onPressed: () {Navigator.push(context, MaterialPageRoute(builder: (ctx)=>AddWorkout()));},
        ),
        /*   bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.fitness_center),
              label: 'My Workouts',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.search),
              label: 'Find Workouts',
            ),
          ],
          backgroundColor: Colors.tealAccent,
          currentIndex: sectionIndex,
          selectedItemColor: Colors.deepPurple,
          onTap: (int index) {
            setState(() => sectionIndex = index);
          },
        ),*/
      ),
    );
  }
}
