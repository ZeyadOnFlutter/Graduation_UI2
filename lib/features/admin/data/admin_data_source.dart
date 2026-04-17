import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:injectable/injectable.dart';

import '../../auth/data/models/user_model.dart';

@lazySingleton
class AdminDataSource {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  const AdminDataSource(this._firestore, this._auth);

  CollectionReference<UserModel> _col(String name) => _firestore
      .collection(name)
      .withConverter(
        fromFirestore: (s, _) => UserModel.fromJson(s.data()!),
        toFirestore: (u, _) => u.toJson(),
      );

  Future<List<UserModel>> getAllUsers() async {
    final results = await Future.wait([
      _col('patients').get(),
      _col('doctors').get(),
      _col('admins').get(),
    ]);
    return results.expand((s) => s.docs.map((d) => d.data())).toList();
  }

  Future<void> createUser(UserModel user, String password) async {
    final cred = await _auth.createUserWithEmailAndPassword(
      email: user.email,
      password: password,
    );
    final newUser = UserModel(
      id: cred.user!.uid,
      name: user.name,
      email: user.email,
      phone: user.phone,
      role: user.role,
    );
    await _col(_collectionName(user.role)).doc(newUser.id).set(newUser);
  }

  Future<void> updateUser(UserModel user, String oldRole) async {
    if (oldRole != user.role) {
      await _col(_collectionName(oldRole)).doc(user.id).delete();
    }
    await _col(_collectionName(user.role)).doc(user.id).set(user);
  }

  Future<void> deleteUser(String userId, String role) async {
    await _col(_collectionName(role)).doc(userId).delete();
  }

  String _collectionName(String role) =>
      role == 'doctor' ? 'doctors' : role == 'admin' ? 'admins' : 'patients';
}
