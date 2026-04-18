class PredictionResponse {
  PredictionResponse({required this.prediction, required this.probability, this.message = ''});

  final String prediction;
  final double probability;
  final String message;

  factory PredictionResponse.fromJson(Map<String, dynamic> json) {
    print('PredictionResponse.fromJson keys: ${json.keys.toList()}');
    print('PredictionResponse.fromJson data: $json');

    // ── Skin Cancer image API ─────────────────────────────────────────────────
    // { predicted_class, confidence, all_probabilities: {NV, MEL, BCC} }
    if (json.containsKey('predicted_class') && json.containsKey('all_probabilities')) {
      final predicted = json['predicted_class']?.toString().trim().toUpperCase() ?? '';
      final confidence = (json['confidence'] as num?)?.toDouble() ?? 0.0;
      final isMalignant = predicted == 'MEL' || predicted == 'BCC';
      final probability = isMalignant ? confidence : 1.0 - confidence;
      print('→ SkinCancer Image: predicted=$predicted confidence=$confidence isMalignant=$isMalignant probability=$probability');
      return PredictionResponse(
        prediction: predicted,
        probability: probability,
        message: isMalignant
            ? '$predicted detected (${(confidence * 100).toStringAsFixed(1)}% confidence) — please consult a dermatologist'
            : 'Likely benign ($predicted, ${(confidence * 100).toStringAsFixed(1)}% confidence)',
      );
    }

    // ── Skin Cancer survey API ────────────────────────────────────────────────
    // { risk_level, probabilities: {Low Risk, Moderate Risk, High Risk} }
    if (json.containsKey('risk_level') && json.containsKey('probabilities')) {
      final probs = json['probabilities'] as Map<String, dynamic>;
      final highRisk = (probs['High Risk'] as num?)?.toDouble() ?? 0.0;
      final modRisk = (probs['Moderate Risk'] as num?)?.toDouble() ?? 0.0;
      final riskScore = (highRisk + modRisk * 0.5) / 100.0;
      final riskLevel = json['risk_level'] as String? ?? '';
      final msg = riskLevel == 'High Risk'
          ? 'Multiple risk factors detected — please consult a doctor soon'
          : riskLevel == 'Moderate Risk'
              ? 'Some risk factors are present — consider seeing a dermatologist'
              : 'Your responses suggest a low likelihood of skin cancer risk';
      print('→ SkinCancer Survey: riskLevel=$riskLevel riskScore=$riskScore');
      return PredictionResponse(
        prediction: riskLevel,
        probability: riskScore.clamp(0.0, 1.0),
        message: msg,
      );
    }

    // ── Diabetes image API ────────────────────────────────────────────────────
    // { prediction, confidence_percentage }
    if (json.containsKey('confidence_percentage')) {
      final confidence = (json['confidence_percentage'] as num).toDouble() / 100.0;
      final isNonDiabetic = (json['prediction'] ?? '').toString().toLowerCase().contains('non');
      final probability = isNonDiabetic ? 1.0 - confidence : confidence;
      print('→ Diabetes Image: prediction=${json['prediction']} confidence_percentage=${json['confidence_percentage']} isNonDiabetic=$isNonDiabetic probability=$probability');
      return PredictionResponse(
        prediction: json['prediction'] ?? '',
        probability: probability,
      );
    }

    // ── Diabetes survey API ───────────────────────────────────────────────────
    // { prediction, probability_non_diabetes }
    if (json.containsKey('probability_non_diabetes')) {
      final probNonDiabetes = (json['probability_non_diabetes'] as num).toDouble();
      final probability = 1.0 - probNonDiabetes;
      print('→ Diabetes Survey: prediction=${json['prediction']} probability_non_diabetes=$probNonDiabetes probability=$probability');
      return PredictionResponse(
        prediction: json['prediction'] ?? '',
        probability: probability,
      );
    }

    // ── Anemia image API ──────────────────────────────────────────────────────
    // { anemia_status, hb_value }
    if (json.containsKey('anemia_status')) {
      final hb = (json['hb_value'] as num?)?.toDouble() ?? 12.0;
      final riskProb = ((17.0 - hb.clamp(5.0, 17.0)) / 12.0).clamp(0.0, 1.0);
      final isAnemic = (json['anemia_status'] ?? '').toString().toLowerCase().contains('anemi');
      print('→ Anemia Image: anemia_status=${json['anemia_status']} hb=$hb riskProb=$riskProb');
      return PredictionResponse(
        prediction: isAnemic ? '1' : '0',
        probability: riskProb,
      );
    }

    // ── Anemia survey API ─────────────────────────────────────────────────────
    // { anemia_probability }
    if (json.containsKey('anemia_probability')) {
      final prob = (json['anemia_probability'] as num).toDouble();
      print('→ Anemia Survey: anemia_probability=$prob');
      return PredictionResponse(
        prediction: prob >= 0.5 ? '1' : '0',
        probability: prob,
        message: prob >= 0.5
            ? 'Likely to have anemia (${(prob * 100).toStringAsFixed(1)}%)'
            : 'Not likely to have anemia (${((1 - prob) * 100).toStringAsFixed(1)}%)',
      );
    }

    // ── Fallback ──────────────────────────────────────────────────────────────
    print('→ Fallback: prediction=${json['prediction']} probability=${json['probability']}');
    return PredictionResponse(
      prediction: json['prediction']?.toString() ?? '',
      probability: (json['probability'] ?? 0.0).toDouble(),
      message: json['message'] ?? '',
    );
  }
}
