class DiabetesRecord {
  final String imageUrl;
  final String prediction;
  final double probabilityNonDiabetes;
  final DateTime timestamp;

  const DiabetesRecord({
    required this.imageUrl,
    required this.prediction,
    required this.probabilityNonDiabetes,
    required this.timestamp,
  });

  factory DiabetesRecord.fromJson(Map<String, dynamic> json) {
    return DiabetesRecord(
      imageUrl: json['imageUrl'] ?? '',
      prediction: json['prediction'] ?? '',
      probabilityNonDiabetes: (json['probabilityNonDiabetes'] ?? 0.0).toDouble(),
      timestamp: DateTime.parse(json['timestamp']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'imageUrl': imageUrl,
      'prediction': prediction,
      'probabilityNonDiabetes': probabilityNonDiabetes,
      'timestamp': timestamp.toIso8601String(),
    };
  }
}

class AnemiaRecord {
  final String imageUrl;
  final String anemiaStatus;
  final double hbValue;
  final DateTime timestamp;

  const AnemiaRecord({
    required this.imageUrl,
    required this.anemiaStatus,
    required this.hbValue,
    required this.timestamp,
  });

  factory AnemiaRecord.fromJson(Map<String, dynamic> json) {
    return AnemiaRecord(
      imageUrl: json['imageUrl'] ?? '',
      anemiaStatus: json['anemiaStatus'] ?? '',
      hbValue: (json['hbValue'] ?? 0.0).toDouble(),
      timestamp: DateTime.parse(json['timestamp']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'imageUrl': imageUrl,
      'anemiaStatus': anemiaStatus,
      'hbValue': hbValue,
      'timestamp': timestamp.toIso8601String(),
    };
  }
}

class DiabetesSurvey {
  final String diabetes;
  final double probability;
  final DateTime timestamp;
  final Map<String, dynamic> surveyData;

  const DiabetesSurvey({
    required this.diabetes,
    required this.probability,
    required this.timestamp,
    required this.surveyData,
  });

  factory DiabetesSurvey.fromJson(Map<String, dynamic> json) {
    return DiabetesSurvey(
      diabetes: json['diabetes'] ?? '',
      probability: (json['probability'] ?? 0.0).toDouble(),
      timestamp: DateTime.parse(json['timestamp']),
      surveyData: Map<String, dynamic>.from(json['surveyData'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'diabetes': diabetes,
      'probability': probability,
      'timestamp': timestamp.toIso8601String(),
      'surveyData': surveyData,
    };
  }
}

class AnemiaSurvey {
  final String prediction;
  final double anemiaProbability;
  final DateTime timestamp;
  final Map<String, dynamic> surveyData;

  const AnemiaSurvey({
    required this.prediction,
    required this.anemiaProbability,
    required this.timestamp,
    required this.surveyData,
  });

  factory AnemiaSurvey.fromJson(Map<String, dynamic> json) {
    return AnemiaSurvey(
      prediction: json['prediction'] ?? '',
      anemiaProbability: (json['anemiaProbability'] ?? 0.0).toDouble(),
      timestamp: DateTime.parse(json['timestamp']),
      surveyData: Map<String, dynamic>.from(json['surveyData'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'prediction': prediction,
      'anemiaProbability': anemiaProbability,
      'timestamp': timestamp.toIso8601String(),
      'surveyData': surveyData,
    };
  }
}

class SkinCancerRecord {
  final String imageUrl;
  final String predictedClass;
  final double confidence;
  final DateTime timestamp;

  const SkinCancerRecord({
    required this.imageUrl,
    required this.predictedClass,
    required this.confidence,
    required this.timestamp,
  });

  factory SkinCancerRecord.fromJson(Map<String, dynamic> json) => SkinCancerRecord(
        imageUrl: json['imageUrl'] ?? '',
        predictedClass: json['predictedClass'] ?? '',
        confidence: (json['confidence'] ?? 0.0).toDouble(),
        timestamp: DateTime.parse(json['timestamp']),
      );

  Map<String, dynamic> toJson() => {
        'imageUrl': imageUrl,
        'predictedClass': predictedClass,
        'confidence': confidence,
        'timestamp': timestamp.toIso8601String(),
      };
}

class SkinCancerSurvey {
  final String riskLevel;
  final double riskScore;
  final DateTime timestamp;
  final Map<String, dynamic> surveyData;

  const SkinCancerSurvey({
    required this.riskLevel,
    required this.riskScore,
    required this.timestamp,
    required this.surveyData,
  });

  factory SkinCancerSurvey.fromJson(Map<String, dynamic> json) => SkinCancerSurvey(
        riskLevel: json['riskLevel'] ?? '',
        riskScore: (json['riskScore'] ?? 0.0).toDouble(),
        timestamp: DateTime.parse(json['timestamp']),
        surveyData: Map<String, dynamic>.from(json['surveyData'] ?? {}),
      );

  Map<String, dynamic> toJson() => {
        'riskLevel': riskLevel,
        'riskScore': riskScore,
        'timestamp': timestamp.toIso8601String(),
        'surveyData': surveyData,
      };
}

class CombinedAnalysisResult {
  final String disease;
  final String textDescription;
  final Map<String, dynamic> imageRecord;
  final Map<String, dynamic> surveyRecord;
  final Map<String, dynamic> nlpRecord;
  final double finalScore;
  final double imgScore;
  final double surveyScore;
  final double nlpScore;
  final String doctorFeedback;
  final DateTime timestamp;

  const CombinedAnalysisResult({
    required this.disease,
    required this.textDescription,
    required this.imageRecord,
    required this.surveyRecord,
    required this.nlpRecord,
    required this.finalScore,
    required this.imgScore,
    required this.surveyScore,
    required this.nlpScore,
    this.doctorFeedback = '',
    required this.timestamp,
  });

  factory CombinedAnalysisResult.fromJson(Map<String, dynamic> json) {
    return CombinedAnalysisResult(
      disease: json['disease'] ?? '',
      textDescription: json['textDescription'] ?? '',
      imageRecord: Map<String, dynamic>.from(json['imageRecord'] ?? {}),
      surveyRecord: Map<String, dynamic>.from(json['surveyRecord'] ?? {}),
      nlpRecord: Map<String, dynamic>.from(json['nlpRecord'] ?? {}),
      finalScore: (json['finalScore'] ?? 0.0).toDouble(),
      imgScore: (json['imgScore'] ?? 0.0).toDouble(),
      surveyScore: (json['surveyScore'] ?? 0.0).toDouble(),
      nlpScore: (json['nlpScore'] ?? 0.0).toDouble(),
      doctorFeedback: json['doctorFeedback'] ?? '',
      timestamp: DateTime.parse(json['timestamp']),
    );
  }

  Map<String, dynamic> toJson() => {
        'disease': disease,
        'textDescription': textDescription,
        'imageRecord': imageRecord,
        'surveyRecord': surveyRecord,
        'nlpRecord': nlpRecord,
        'finalScore': finalScore,
        'imgScore': imgScore,
        'surveyScore': surveyScore,
        'nlpScore': nlpScore,
        'doctorFeedback': doctorFeedback,
        'timestamp': timestamp.toIso8601String(),
      };
}

class UserModel {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String role;
  final List<DiabetesRecord> diabetesRecords;
  final List<AnemiaRecord> anemiaRecords;
  final List<DiabetesSurvey> diabetesSurveys;
  final List<AnemiaSurvey> anemiaSurveys;
  final List<SkinCancerRecord> skinCancerRecords;
  final List<SkinCancerSurvey> skinCancerSurveys;
  final List<CombinedAnalysisResult> combinedResults;

  const UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    this.role = 'patient',
    this.diabetesRecords = const [],
    this.anemiaRecords = const [],
    this.diabetesSurveys = const [],
    this.anemiaSurveys = const [],
    this.skinCancerRecords = const [],
    this.skinCancerSurveys = const [],
    this.combinedResults = const [],
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      phone: json['phone'] ?? '',
      role: json['role'] ?? 'patient',
      diabetesRecords: (json['diabetesRecords'] as List<dynamic>?)
          ?.map((e) => DiabetesRecord.fromJson(e)).toList() ?? [],
      anemiaRecords: (json['anemiaRecords'] as List<dynamic>?)
          ?.map((e) => AnemiaRecord.fromJson(e)).toList() ?? [],
      diabetesSurveys: (json['diabetesSurveys'] as List<dynamic>?)
          ?.map((e) => DiabetesSurvey.fromJson(e)).toList() ?? [],
      anemiaSurveys: (json['anemiaSurveys'] as List<dynamic>?)
          ?.map((e) => AnemiaSurvey.fromJson(e)).toList() ?? [],
      skinCancerRecords: (json['skinCancerRecords'] as List<dynamic>?)
          ?.map((e) => SkinCancerRecord.fromJson(e)).toList() ?? [],
      skinCancerSurveys: (json['skinCancerSurveys'] as List<dynamic>?)
          ?.map((e) => SkinCancerSurvey.fromJson(e)).toList() ?? [],
      combinedResults: (json['combinedResults'] as List<dynamic>?)
          ?.map((e) => CombinedAnalysisResult.fromJson(e)).toList() ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'role': role,
      'diabetesRecords': diabetesRecords.map((e) => e.toJson()).toList(),
      'anemiaRecords': anemiaRecords.map((e) => e.toJson()).toList(),
      'diabetesSurveys': diabetesSurveys.map((e) => e.toJson()).toList(),
      'anemiaSurveys': anemiaSurveys.map((e) => e.toJson()).toList(),
      'skinCancerRecords': skinCancerRecords.map((e) => e.toJson()).toList(),
      'skinCancerSurveys': skinCancerSurveys.map((e) => e.toJson()).toList(),
      'combinedResults': combinedResults.map((e) => e.toJson()).toList(),
    };
  }
}
