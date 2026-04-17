import 'dart:io';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/api/api_endpoints.dart';
import '../../../../core/error/api_error_handler.dart';
import '../model/prediction_response.dart';
import '../model/health_data_model.dart';
import '../model/text_prediction_response.dart';
import 'prediction_remote_data_source.dart';

@LazySingleton(as: PredictionRemoteDataSource)
class PredictionApiDataSource implements PredictionRemoteDataSource {
  final Dio _mainDio;
  final Dio _predictDio;
  final Dio _anemiaDio;
  final Dio _anemiaSurveyDio;
  final Dio _skinCancerDio;
  final Dio _skinCancerSurveyDio;
  final Dio _textPredictDio;

  PredictionApiDataSource(
    @Named('MainDio') this._mainDio,
    @Named('PredictDio') this._predictDio,
    @Named('AnemiaDio') this._anemiaDio,
    @Named('AnemiaSurveyDio') this._anemiaSurveyDio,
    @Named('SkinCancerDio') this._skinCancerDio,
    @Named('SkinCancerSurveyDio') this._skinCancerSurveyDio,
    @Named('TextPredictDio') this._textPredictDio,
  );

  @override
  Future<PredictionResponse> predictImage(File imageFile) async {
    try {
      final formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(imageFile.path, filename: 'image.jpg'),
      });

      final response = await _mainDio.post(ApiEndpoints.diabetesPredict, data: formData);
      print('Image Prediction API Response: ${response.data}');

      return PredictionResponse.fromJson(response.data);
    } on DioException catch (e) {
      throw ApiErrorHandler.handleDioError(e);
    }
  }

  @override
  Future<PredictionResponse> predictHealthData(HealthDataModel healthData) async {
    try {
      final body = healthData.toJson();
      print('Diabetes Survey Request: $body');
      final response = await _predictDio.post(ApiEndpoints.diabetesPredict, data: body);
      print('Diabetes Survey Response: ${response.data}');
      return PredictionResponse.fromJson(response.data);
    } on DioException catch (e) {
      print('Diabetes Survey Error: ${e.response?.statusCode} ${e.response?.data}');
      throw ApiErrorHandler.handleDioError(e);
    }
  }

  @override
  Future<PredictionResponse> predictAnemiaImage(File imageFile) async {
    try {
      final formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(imageFile.path, filename: 'image.jpg'),
      });

      final response = await _anemiaDio.post(ApiEndpoints.anemiaPredict, data: formData);
      print('Anemia API Response: ${response.data}');

      return PredictionResponse.fromJson(response.data);
    } on DioException catch (e) {
      throw ApiErrorHandler.handleDioError(e);
    }
  }

  @override
  Future<PredictionResponse> predictAnemiaSurvey(Map<String, dynamic> surveyData) async {
    try {
      final response = await _anemiaSurveyDio.post(
        ApiEndpoints.anemiaSurveyPredict,
        data: surveyData,
      );
      print('Anemia Survey Response: ${response.data}');
      return PredictionResponse.fromJson(response.data);
    } on DioException catch (e) {
      throw ApiErrorHandler.handleDioError(e);
    }
  }

  @override
  Future<PredictionResponse> predictSkinCancerImage(File imageFile) async {
    try {
      final formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(imageFile.path, filename: 'image.jpg'),
      });
      final response = await _skinCancerDio.post(ApiEndpoints.skinCancerPredict, data: formData);
      print('Skin Cancer Image Response: ${response.data}');
      return PredictionResponse.fromJson(response.data);
    } on DioException catch (e) {
      throw ApiErrorHandler.handleDioError(e);
    }
  }

  @override
  Future<PredictionResponse> predictSkinCancerSurvey(Map<String, dynamic> surveyData) async {
    try {
      final response = await _skinCancerSurveyDio.post(
        ApiEndpoints.skinCancerSurveyPredict,
        data: surveyData,
      );
      print('Skin Cancer Survey Response: ${response.data}');
      return PredictionResponse.fromJson(response.data);
    } on DioException catch (e) {
      throw ApiErrorHandler.handleDioError(e);
    }
  }

  @override
  Future<TextPredictionResponse> predictFromText(String text) async {
    try {
      final response = await _textPredictDio.post(ApiEndpoints.textPredict, data: {'text': text});
      return TextPredictionResponse.fromJson(response.data);
    } on DioException catch (e) {
      throw ApiErrorHandler.handleDioError(e);
    }
  }
}
