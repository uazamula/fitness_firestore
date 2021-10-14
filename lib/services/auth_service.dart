import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitness_firestore/domain/my_user.dart';
import 'package:provider/provider.dart';

class AuthService {
  static final  FirebaseAuth _fAuth = FirebaseAuth.instance;

  Future<MyUser?> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential result = await _fAuth.signInWithEmailAndPassword(
          email: email,
          password: password); // UserCredential is former AuthResult
      User? user = result.user; // User is former FirebaseUser
      return MyUser.fromFirebase(user!);
    } catch (e) {
      print(e);
      print('помилка з іменем або паролем');
      return null;
    }
  }

  Future<MyUser?> registerInWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential result = await _fAuth.createUserWithEmailAndPassword(
          email: email,
          password: password); // UserCredential is former AuthResult
      User? user = result.user; // User is former FirebaseUser
      return MyUser.fromFirebase(user!);
    } catch (e) {
      print(e);
      print('помилка при реєстрації');

      return null;
    }
  }

  static Future logOut() async {
    await _fAuth.signOut();
  }
  static Stream<MyUser?> get currentUser{
    return _fAuth.authStateChanges().map((User? user) =>  user != null ? MyUser.fromFirebase(user):null); // authStateChanges() is former onAuthStateChanged
  }
}
