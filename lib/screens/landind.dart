import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitness_firestore/domain/my_user.dart';
import 'package:fitness_firestore/screens/auth.dart';
import 'package:fitness_firestore/screens/home.dart';
import 'package:fitness_firestore/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LandingPage extends StatelessWidget {
//  const LandingPage({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    User? user = Provider.of<User?>(context);
    final AuthorizationPage _authPage = AuthorizationPage();

    final bool isLoggedIn = user != null; //false;
   // if (user != null) if (user.emailVerified) user.reload();
print('==================================================================================');
    return isLoggedIn
            //BEGIN///
            /*&&
            FirebaseAuth.instance.currentUser!.emailVerified) ||
    _authPage.createState().emailVerified*/

        //END/////////
        ? HomePage()
        : AuthorizationPage();
  }
}
