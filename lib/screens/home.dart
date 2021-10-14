import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:fitness_firestore/components/active_workouts.dart';
import 'package:fitness_firestore/components/workout_list.dart';
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

  @override
  Widget build(BuildContext context) {
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
                AuthService.logOut();
              },
              icon: Icon(Icons.supervised_user_circle, color: Colors.white),
              label: SizedBox.shrink(),
            )
          ],
        ),
        body: sectionIndex == 0 ? ActiveWorkouts() : WorkoutsList(),
        bottomNavigationBar: myCurvedNavigationBar,
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
