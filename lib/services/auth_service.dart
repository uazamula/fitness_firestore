import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitness_firestore/domain/my_user.dart';
import 'package:provider/provider.dart';

class AuthService {
  final  FirebaseAuth _fAuth = FirebaseAuth.instance;

  Future<User?> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential result = await _fAuth.signInWithEmailAndPassword(
          email: email,
          password: password); // UserCredential is former AuthResult
      User? user = result.user; // User is former FirebaseUser
      return user;
    } catch (e) {
      print(e);
      print('помилка з іменем або паролем');
      return null;
    }
  }

  Future<User?> registerInWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential result = await _fAuth.createUserWithEmailAndPassword(
          email: email,
          password: password); // UserCredential is former AuthResult
      User? user = result.user; // User is former FirebaseUser
      return user;
    } catch (e) {
      print(e);
      print('помилка при реєстрації');

      return null;
    }
  }

   Future logOut() async {
    await _fAuth.signOut();
  }
  Stream<User?> get currentUser{
    return _fAuth.authStateChanges().map((User? user) =>  user != null ? user:null); // authStateChanges() is former onAuthStateChanged
  }
}
