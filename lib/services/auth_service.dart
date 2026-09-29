import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Stream auth state changes
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Get current user
  User? get currentUser => _auth.currentUser;

  // Sign up with email and password
  Future<UserCredential?> signUpWithEmailAndPassword(
      String name, String email, String password) async {
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );

      // Create a user document in Firestore
      if (userCredential.user != null) {
        await _firestore.collection('users').doc(userCredential.user!.uid).set({
          'uid': userCredential.user!.uid,
          'name': name.trim(),
          'email': email.trim(),
          'createdAt': FieldValue.serverTimestamp(),
          'avatarUrl': '', // Optional: Add default avatar
          'isOnline': true,
        });
        
        // Update display name
        await userCredential.user!.updateDisplayName(name.trim());
      }
      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw e.message ?? 'An unknown error occurred';
    } catch (e) {
      throw 'An error occurred during registration: $e';
    }
  }

  // Sign in with email and password
  Future<UserCredential?> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );
      
      // Update online status
      if (userCredential.user != null) {
        await _firestore.collection('users').doc(userCredential.user!.uid).update({
          'isOnline': true,
        });
      }
      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw e.message ?? 'Invalid email or password';
    } catch (e) {
      throw 'An error occurred during login: $e';
    }
  }

  // Sign out
  Future<void> signOut() async {
    if (currentUser != null) {
      await _firestore.collection('users').doc(currentUser!.uid).update({
        'isOnline': false,
      });
    }
    await _auth.signOut();
  }

  // Reset password
  Future<void> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email.trim());
    } on FirebaseAuthException catch (e) {
      throw e.message ?? 'Could not send reset email';
    } catch (e) {
      throw 'An error occurred: $e';
    }
  }
}
