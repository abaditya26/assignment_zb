import 'package:firebase_auth/firebase_auth.dart';

class AuthService{
  final _auth = FirebaseAuth.instance;

  Future<String> generateUid() async {
    UserCredential userCredential = await _auth.signInAnonymously();
    return userCredential.user!.uid;
  }
}