import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitness_firestore/domain/my_user.dart';
import 'package:fitness_firestore/screens/home.dart';
import 'package:fitness_firestore/screens/restart.dart';
import 'package:fitness_firestore/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

class AuthorizationPage extends StatefulWidget {
  const AuthorizationPage({Key? key}) : super(key: key);

  @override
  _AuthorizationPageState createState() => _AuthorizationPageState();
}

class _AuthorizationPageState extends State<AuthorizationPage> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  String? _email;
  String? _password;
  bool showLogin = true;
  bool emailVerified = false;

  AuthService _authService = AuthService();



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).textTheme.headline6!.color,
      body: Column(
        children: [
          _logo(),
          (showLogin
              ? Column(
                  children: [
                    _form('Login', _loginButtonAction),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 5),
                      child: GestureDetector(
                        child: Text('Not registered yet? Register!'),
                        onTap: () {
                          setState(() {
                            showLogin = false;
                          });
                        },
                      ),
                    ),
                  ],
                )
              : Column(
                  children: [
                    _form('Register', _registerButtonAction),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 5),
                      child: GestureDetector(
                        child: Text('You already registered. Login!'),
                        onTap: () {
                          setState(() {
                            showLogin = true;
                          });
                        },
                      ),
                    ),
                  ],
                ))
        ],
      ),
    );
  }

  void _loginButtonAction() async {
    _email = _emailController.text;
    _password = _passwordController.text;

    if (_email!.isEmpty || _password!.isEmpty) return;
    User? user = await _authService.signInWithEmailAndPassword(
        _email!.trim(), _password!);
    emailVerified = user!.emailVerified;
    print('юзер пройшов верифікацію: $emailVerified');
    if (user != null) if (user.emailVerified)
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => HomePage(),
        ),
      );

    if (user == null) {
      Fluttertoast.showToast(
          msg: "Can't sign in you! Please check your email/password!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    } else {
      emailVerified = user.emailVerified;
      print('\n оце і є мій юзер : $user\n');

      _emailController.clear();
      _passwordController.clear();
    }
  }

  void _registerButtonAction() async {
    _email = _emailController.text;
    _password = _passwordController.text;

    if (_email!.isEmpty || _password!.isEmpty) return;
    Future<User?> user = _authService
        .registerInWithEmailAndPassword(_email!.trim(), _password!)
        .then((user) async {
      if (user != null && !user.emailVerified) {
        await FirebaseAuth.instance.currentUser!.sendEmailVerification();

        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Restart(),
            ));

        Fluttertoast.showToast(
            msg:
                'An email has just been sent to you, Click the link provided to complete registration',
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 5,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);

        //SystemNavigator.pop();//Only for Android
      }
     // if (user != null && user.emailVerified) Phoenix.rebirth(context);
    });

    if (user == null) {
      Fluttertoast.showToast(
          msg: "Can't register you! Please check your email/password!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    } else {
      _emailController.clear();
      _passwordController.clear();
    }
  }

  //TODO move it to build method?
  Widget _logo() {
    return Padding(
      padding: EdgeInsets.only(top: 100),
      child: Container(
        child: Align(
          child: Text(
            'MaxFit',
            style: TextStyle(
                fontSize: 45, fontWeight: FontWeight.bold, color: Colors.blue),
          ),
        ),
      ),
    );
  }

  Widget _form(String label, void func()) {
    return Container(
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(bottom: 20, top: 10),
            child: _input(
                icon: Icon(Icons.email),
                hint: 'email',
                controller: _emailController,
                obscure: false), //Text('email'),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 20),
            child: _input(
                icon: Icon(Icons.lock),
                hint: 'password',
                controller: _passwordController,
                obscure: true), //Text('password'),
          ),
          SizedBox(
            height: 20,
          ),
          Padding(
            padding: EdgeInsets.only(left: 20, right: 20),
            child: Container(
              height: 50,
              width: MediaQuery.of(context).size.width,
              child: _button(label, func), //Text(label),
            ),
          ),
        ],
      ),
    );
  }

  Widget _input(
      {required Icon icon,
      required String hint,
      required TextEditingController controller,
      required bool obscure}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: TextField(
        controller: controller,
        obscureText: obscure,
        style: TextStyle(fontSize: 20, color: Colors.amber),
        decoration: InputDecoration(
          hintStyle: TextStyle(
              fontWeight: FontWeight.bold, fontSize: 20, color: Colors.black45),
          hintText: hint,
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.lightGreen, width: 3),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.blueAccent, width: 1),
          ),
          prefixIcon: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: IconTheme(
              data: IconThemeData(
                color: Colors.pinkAccent,
              ),
              child: icon,
            ),
          ),
        ),
      ),
    );
  }

  Widget _button(String text, void func()) {
    return RaisedButton(
      splashColor: Theme.of(context).primaryColor,
      highlightColor: Colors.deepPurple,
      color: Colors.tealAccent,
      child: Text(text,
          style: TextStyle(
              fontWeight: FontWeight.bold, color: Colors.grey, fontSize: 20)),
      onPressed: func
      //BEGIN///
      /*if (!showLogin) {
          // final User? user = Provider.of<User?>(context, listen: false);
          final user = FirebaseAuth.instance.currentUser;

          print('\n оце і є мій юзер : $user\n');

          //if(user!.emailVerified) user.updateDisplayName('Льоха');

          if (user != null && !user.emailVerified) {
            user.sendEmailVerification();
          }
        }*/
      //END/////////
      ,
    );
  }
}
