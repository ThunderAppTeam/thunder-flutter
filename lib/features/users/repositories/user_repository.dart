import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thunder/features/users/models/user_profile.dart';

class UserRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> createUserProfile(UserProfile profile) async {
    await _firestore.collection('users').doc(profile.uid).set(profile.toJson());
  }
}

final userRepoProvider = Provider<UserRepository>((ref) {
  return UserRepository();
});
