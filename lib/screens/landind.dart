import 'package:fitness_firestore/domain/my_user.dart';
import 'package:fitness_firestore/screens/auth.dart';
import 'package:fitness_firestore/screens/home.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final MyUser? user = Provider.of<MyUser?>(context);
    final bool isLoggedIn = user != null; //false;
    return isLoggedIn ? HomePage() : AuthorizationPage();
  }
}
