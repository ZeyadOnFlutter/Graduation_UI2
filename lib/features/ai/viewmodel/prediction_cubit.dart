import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../data/repository/prediction_repository.dart';
import '../data/model/health_data_model.dart';
import '../data/model/anemia_survey_model.dart';
import 'prediction_state.dart';

@lazySingleton
class PredictionCubit extends Cubit<PredictionState> {
  final PredictionRepository _repository;

  PredictionCubit(this._repository) : super(PredictionInitial());

  Future<void> predictImage(File imageFile, String imageUrl) async {
    emit(PredictionLoading());
    final response = await _repository.predictImage(imageFile, imageUrl);
    response.fold(
      (failure) => emit(PredictionError(failure.message)),
      (predictionResponse) => emit(
        PredictionSuccess(
          predictionResponse.prediction,
          probability: predictionResponse.probability,
          message: predictionResponse.message,
        ),
      ),
    );
  }

  Future<void> predictHealthData(HealthDataModel healthData) async {
    emit(PredictionLoading());
    final response = await _repository.predictHealthData(healthData);
    response.fold(
      (failure) => emit(PredictionError(failure.message)),
      (predictionResponse) => emit(
        PredictionSuccess(
          predictionResponse.prediction,
          probability: predictionResponse.probability,
          message: predictionResponse.message,
        ),
      ),
    );
  }

  Future<void> predictAnemiaImage(File imageFile, String imageUrl) async {
    emit(PredictionLoading());
    final response = await _repository.predictAnemiaImage(imageFile, imageUrl);
    response.fold(
      (failure) => emit(PredictionError(failure.message)),
      (predictionResponse) => emit(
        PredictionSuccess(
          predictionResponse.prediction,
          probability: predictionResponse.probability,
          message: predictionResponse.message,
        ),
      ),
    );
  }

  Future<void> predictAnemiaSurvey(Map<String, dynamic> surveyData) async {
    emit(PredictionLoading());
    final response = await _repository.predictAnemiaSurvey(surveyData);
    response.fold(
      (failure) => emit(PredictionError(failure.message)),
      (predictionResponse) => emit(
        PredictionSuccess(
          predictionResponse.prediction,
          probability: predictionResponse.probability,
          message: predictionResponse.message,
        ),
      ),
    );
  }

  Future<void> predictSkinCancerSurvey(Map<String, dynamic> surveyData) async {
    emit(PredictionLoading());
    final response = await _repository.predictSkinCancerSurvey(surveyData);
    response.fold(
      (failure) => emit(PredictionError(failure.message)),
      (predictionResponse) => emit(
        PredictionSuccess(
          predictionResponse.prediction,
          probability: predictionResponse.probability,
          message: predictionResponse.message,
        ),
      ),
    );
  }

  Future<void> predictFromText(String text) async {
    emit(PredictionLoading());
    final response = await _repository.predictFromText(text);
    response.fold(
      (failure) => emit(PredictionError(failure.message)),
      (textResponse) => emit(TextPredictionSuccess(textResponse)),
    );
  }

  /// Calls all 3 APIs in parallel and computes weighted final score.
  /// Image 60% | Survey 30% | NLP 10%
  Future<void> runCombinedAnalysis({
    required String disease,
    required File imageFile,
    required Map<String, dynamic> surveyData,
    required String symptomText,
  }) async {
    emit(PredictionLoading());
    try {
      final imgFuture = disease == 'Anemia'
          ? _repository.predictAnemiaImage(imageFile, imageFile.path)
          : disease == 'Skin Cancer'
              ? _repository.predictSkinCancerImage(imageFile, imageFile.path)
              : _repository.predictImage(imageFile, imageFile.path);
      final surveyFuture = disease == 'Anemia'
          ? _repository.predictAnemiaSurvey(surveyData)
          : disease == 'Skin Cancer'
              ? _repository.predictSkinCancerSurvey(surveyData)
              : _repository.predictHealthData(HealthDataModel.fromJson(surveyData));
      final nlpFuture = _repository.predictFromText(symptomText);

      final imgResp = await imgFuture;
      final surveyResp = await surveyFuture;
      final nlpResp = await nlpFuture;

      double imgScore = 0;
      Map<String, dynamic> imageRecord = {};
      imgResp.fold((f) => throw Exception(f.message), (r) {
        imgScore = r.probability * 100;
        // Mirror exact fields saved separately per disease
        if (disease == 'Anemia') {
          imageRecord = {
            'imageUrl': imageFile.path,
            'anemiaStatus': r.prediction,
            'hbValue': r.probability,
            'timestamp': DateTime.now().toIso8601String(),
          };
        } else if (disease == 'Skin Cancer') {
          imageRecord = {
            'imageUrl': imageFile.path,
            'predictedClass': r.prediction,
            'confidence': r.probability,
            'timestamp': DateTime.now().toIso8601String(),
          };
        } else {
          // Diabetes
          imageRecord = {
            'imageUrl': imageFile.path,
            'prediction': r.prediction,
            'probabilityNonDiabetes': r.probability,
            'timestamp': DateTime.now().toIso8601String(),
          };
        }
      });

      double surveyScore = 0;
      Map<String, dynamic> surveyRecord = {};
      surveyResp.fold((f) => throw Exception(f.message), (r) {
        surveyScore = r.probability * 100;
        // Mirror exact fields saved separately per disease
        if (disease == 'Anemia') {
          surveyRecord = {
            'prediction': r.prediction,
            'anemiaProbability': r.probability,
            'surveyData': surveyData,
            'timestamp': DateTime.now().toIso8601String(),
          };
        } else if (disease == 'Skin Cancer') {
          surveyRecord = {
            'riskLevel': r.prediction,
            'riskScore': r.probability,
            'surveyData': surveyData,
            'timestamp': DateTime.now().toIso8601String(),
          };
        } else {
          // Diabetes
          surveyRecord = {
            'diabetes': r.prediction,
            'probability': r.probability,
            'surveyData': surveyData,
            'timestamp': DateTime.now().toIso8601String(),
          };
        }
      });

      double nlpScore = 0;
      Map<String, dynamic> nlpRecord = {};
      nlpResp.fold((f) => throw Exception(f.message), (r) {
        final normalized = disease.toLowerCase().replaceAll(' ', '');
        final key = r.resultsMap.keys.firstWhere(
          (k) => k.toLowerCase().replaceAll(' ', '') == normalized,
          orElse: () => '',
        );
        nlpScore = key.isNotEmpty ? (r.resultsMap[key]?.percentage ?? 0.0) : 0.0;
        nlpRecord = {
          'text': r.text,
          'matched_symptoms': key.isNotEmpty ? (r.resultsMap[key]?.matchedSymptoms ?? []) : [],
          'percentage': nlpScore,
        };
      });

      final finalScore = (imgScore * 0.60) + (surveyScore * 0.30) + (nlpScore * 0.10);

      await _repository.saveCombinedResult(
        disease: disease,
        textDescription: symptomText,
        imageRecord: imageRecord,
        surveyRecord: surveyRecord,
        nlpRecord: nlpRecord,
        finalScore: finalScore.clamp(0, 100),
        imgScore: imgScore.clamp(0, 100),
        surveyScore: surveyScore.clamp(0, 100),
        nlpScore: nlpScore.clamp(0, 100),
      );

      emit(
        CombinedAnalysisSuccess(
          finalScore: finalScore.clamp(0, 100),
          imgScore: imgScore.clamp(0, 100),
          surveyScore: surveyScore.clamp(0, 100),
          nlpScore: nlpScore.clamp(0, 100),
        ),
      );
    } catch (e) {
      emit(PredictionError(e.toString()));
    }
  }
}
