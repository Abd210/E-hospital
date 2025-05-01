import 'package:flutter/material.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  Future<void> _ensureUserDoc(User user) async {
    final doc = FirebaseFirestore.instance.collection('users').doc(user.uid);
    await doc.set({'role': 'patient'}, SetOptions(merge: true)); // default
  }

  @override
  Widget build(BuildContext context) {
    return SignInScreen(
      providers: [EmailAuthProvider()],
      actions: [
        AuthStateChangeAction<SignedIn>((ctx, state) async {
          await _ensureUserDoc(state.user);
          Navigator.of(ctx).pushReplacementNamed('/');
        }),
      ],
    );
  }
}
