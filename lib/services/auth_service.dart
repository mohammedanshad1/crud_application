import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';

class AuthService {
final auth.FirebaseAuth _firebaseAuth = auth.FirebaseAuth.instance;  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Get current user stream
  Stream<User?> get authStateChanges {
    return _firebaseAuth.authStateChanges().asyncMap((firebaseUser) async {
      if (firebaseUser == null) return null;
      
      final docSnapshot = await _firestore
          .collection('users')
          .doc(firebaseUser.uid)
          .get();
      
      if (docSnapshot.exists) {
        return User.fromMap(docSnapshot.data() ?? {}, firebaseUser.uid);
      }
      
      return User(
        uid: firebaseUser.uid,
        email: firebaseUser.email ?? '',
      );
    });
  }

  // Get current user synchronously
  User? get currentUser {
    final firebaseUser = _firebaseAuth.currentUser;
    if (firebaseUser == null) return null;
    
    return User(
      uid: firebaseUser.uid,
      email: firebaseUser.email ?? '',
    );
  }

  // Sign up with email and password
  Future<User?> signUp({
    required String email,
    required String password,
  }) async {
    try {
      final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = User(
        uid: userCredential.user!.uid,
        email: email,
        createdAt: DateTime.now(),
      );

      // Save user to Firestore
      await _firestore
          .collection('users')
          .doc(user.uid)
          .set(user.toMap());

      return user;
} on auth.FirebaseAuthException catch (e) {
        throw _handleAuthException(e);
    }
  }

  // Login with email and password
  Future<User?> login({
    required String email,
    required String password,
  }) async {
    try {
      final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final docSnapshot = await _firestore
          .collection('users')
          .doc(userCredential.user!.uid)
          .get();

      return User.fromMap(
        docSnapshot.data() ?? {},
        userCredential.user!.uid,
      );
    } on auth.FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }

  // Sign out
  Future<void> signOut() async {
    try {
      await _firebaseAuth.signOut();
    } catch (e) {
      throw 'Failed to sign out: $e';
    }
  }

  // Check if user is logged in
  bool isLoggedIn() {
    return _firebaseAuth.currentUser != null;
  }

  // Handle Firebase auth exceptions
  String _handleAuthException(auth.FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return 'No user found with this email.';
      case 'wrong-password':
        return 'Wrong password provided for that user.';
      case 'email-already-in-use':
        return 'An account already exists with this email.';
      case 'weak-password':
        return 'The password provided is too weak.';
      case 'invalid-email':
        return 'The email address is not valid.';
      default:
        return 'An error occurred: ${e.message}';
    }
  }
}
