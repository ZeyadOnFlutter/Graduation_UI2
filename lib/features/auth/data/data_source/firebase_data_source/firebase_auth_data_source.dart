import 'package:cloud_firestore/cloud_firestore.dart';

import '../../models/user_model.dart';

abstract class FirebaseAuthDataSource {
  CollectionReference<UserModel> getUserCollection();
  Future<UserModel?> register(String name, String email, String password, String phone, String role);
  Future<UserModel?> login(String email, String password);
  Future<UserModel> getUserFromFireStore(UserModel user);
  Future<void> addUserToFireStore(UserModel user);
  Future<void> logout();
  Future<void> addDiabetesRecord(String userId, DiabetesRecord record);
  Future<void> addAnemiaRecord(String userId, AnemiaRecord record);
  Future<void> addDiabetesSurvey(String userId, DiabetesSurvey survey);
  Future<void> addAnemiaSurvey(String userId, AnemiaSurvey survey);
  Future<void> addSkinCancerRecord(String userId, SkinCancerRecord record);
  Future<void> addSkinCancerSurvey(String userId, SkinCancerSurvey survey);
  Future<void> addCombinedResult(String userId, CombinedAnalysisResult result);
  Future<void> saveDoctorFeedback(String patientId, String timestamp, String feedback);
  Future<UserModel?> getUserData(String userId);
}
