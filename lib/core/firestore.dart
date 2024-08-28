import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future<void> checkAndCreateUserPostsPath() async {
  final user = FirebaseAuth.instance.currentUser;

  if (user == null) {
    throw Exception('No user signed in');
  }

  final userPostsRef = FirebaseFirestore.instance
      .collection('users')
      .doc(user.uid)
      .collection('posts');

  // Check if the path exists by querying for any document
  final snapshot = await userPostsRef.limit(1).get();

  if (snapshot.docs.isEmpty) {
    // If no documents exist, create a placeholder document
    await userPostsRef.add({
      'title': 'Welcome!',
      'description': 'This is your first post.',
      'timestamp': FieldValue.serverTimestamp(),
    });
  }
}
