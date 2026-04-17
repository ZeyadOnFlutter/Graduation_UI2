import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/error/exception.dart';
import '../../../../core/error/faliure.dart';
import '../../../auth/data/data_source/firebase_data_source/firebase_auth_data_source.dart';
import '../../../auth/data/models/user_model.dart';
import '../../../auth/data/models/user_model.dart';
import '../data_source/prediction_remote_data_source.dart';
import '../model/prediction_response.dart';
import '../model/health_data_model.dart';
import '../model/text_prediction_response.dart';

@lazySingleton
class PredictionRepository {
  final PredictionRemoteDataSource _dataSource;
  final FirebaseAuthDataSource _firebaseDataSource;
  final FirebaseAuth _auth;

  PredictionRepository(this._dataSource, this._firebaseDataSource, this._auth);

  Future<Either<Failure, PredictionResponse>> predictImage(File imageFile, String imageUrl) async {
    try {
      final response = await _dataSource.predictImage(imageFile);
      final userId = _auth.currentUser?.uid;
      if (userId != null) {
        final record = DiabetesRecord(
          imageUrl: imageUrl,
          prediction: response.prediction,
          probabilityNonDiabetes: response.probability,
          timestamp: DateTime.now(),
        );
        await _firebaseDataSource.addDiabetesRecord(userId, record);
      }
      return Right(response);
    } on RemoteException catch (e) {
      return Left(Failure(e.message));
    }
  }

  Future<Either<Failure, PredictionResponse>> predictHealthData(HealthDataModel healthData) async {
    try {
      final response = await _dataSource.predictHealthData(healthData);
      final userId = _auth.currentUser?.uid;
      if (userId != null) {
        final survey = DiabetesSurvey(
          diabetes: response.prediction,
          probability: response.probability,
          timestamp: DateTime.now(),
          surveyData: healthData.toJson(),
        );
        await _firebaseDataSource.addDiabetesSurvey(userId, survey);
      }
      return Right(response);
    } on RemoteException catch (e) {
      return Left(Failure(e.message));
    }
  }

  Future<Either<Failure, PredictionResponse>> predictAnemiaImage(
    File imageFile,
    String imageUrl,
  ) async {
    try {
      final response = await _dataSource.predictAnemiaImage(imageFile);
      final userId = _auth.currentUser?.uid;
      if (userId != null) {
        final record = AnemiaRecord(
          imageUrl: imageUrl,
          anemiaStatus: response.prediction,
          hbValue: response.probability,
          timestamp: DateTime.now(),
        );
        await _firebaseDataSource.addAnemiaRecord(userId, record);
      }
      return Right(response);
    } on RemoteException catch (e) {
      return Left(Failure(e.message));
    }
  }

  Future<Either<Failure, PredictionResponse>> predictAnemiaSurvey(
    Map<String, dynamic> surveyData,
  ) async {
    try {
      final response = await _dataSource.predictAnemiaSurvey(surveyData);
      final userId = _auth.currentUser?.uid;
      if (userId != null) {
        final survey = AnemiaSurvey(
          prediction: response.prediction,
          anemiaProbability: response.probability,
          timestamp: DateTime.now(),
          surveyData: surveyData,
        );
        await _firebaseDataSource.addAnemiaSurvey(userId, survey);
      }
      return Right(response);
    } on RemoteException catch (e) {
      return Left(Failure(e.message));
    }
  }

  Future<Either<Failure, PredictionResponse>> predictSkinCancerImage(
    File imageFile,
    String imageUrl,
  ) async {
    try {
      final response = await _dataSource.predictSkinCancerImage(imageFile);
      return Right(response);
    } on RemoteException catch (e) {
      return Left(Failure(e.message));
    }
  }

  Future<Either<Failure, PredictionResponse>> predictSkinCancerSurvey(
    Map<String, dynamic> surveyData,
  ) async {
    try {
      final response = await _dataSource.predictSkinCancerSurvey(surveyData);
      return Right(response);
    } on RemoteException catch (e) {
      return Left(Failure(e.message));
    }
  }

  Future<Either<Failure, TextPredictionResponse>> predictFromText(String text) async {
    try {
      final response = await _dataSource.predictFromText(text);
      return Right(response);
    } on RemoteException catch (e) {
      return Left(Failure(e.message));
    }
  }

  Future<void> saveCombinedResult({
    required String disease,
    required double finalScore,
    required double imgScore,
    required double surveyScore,
    required double nlpScore,
  }) async {
    final userId = _auth.currentUser?.uid;
    if (userId == null) return;
    await _firebaseDataSource.addCombinedResult(
      userId,
      CombinedAnalysisResult(
        disease: disease,
        finalScore: finalScore,
        imgScore: imgScore,
        surveyScore: surveyScore,
        nlpScore: nlpScore,
        timestamp: DateTime.now(),
      ),
    );
  }
}
