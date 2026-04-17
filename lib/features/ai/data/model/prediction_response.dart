class PredictionResponse {
  PredictionResponse({required this.prediction, required this.probability, this.message = ''});

  final String prediction;
  final double probability;
  final String message;

  factory PredictionResponse.fromJson(Map<String, dynamic> json) {
    // Skin cancer survey API: {risk_level, probabilities: {Low Risk, Moderate Risk, High Risk}}
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
      return PredictionResponse(
        prediction: riskLevel,
        probability: riskScore.clamp(0.0, 1.0),
        message: msg,
      );
    }
    // Diabetes image API: {prediction, confidence_percentage}
    if (json.containsKey('confidence_percentage')) {
      final confidence = (json['confidence_percentage'] as num).toDouble() / 100.0;
      final isNonDiabetic = (json['prediction'] ?? '').toString().toLowerCase().contains('non');
      // probability = non-diabetic probability (used as 1-x for risk score)
      return PredictionResponse(
        prediction: json['prediction'] ?? '',
        probability: isNonDiabetic ? confidence : 1.0 - confidence,
      );
    } else if (json.containsKey('probability_non_diabetes')) {
      return PredictionResponse(
        prediction: json['prediction'] ?? '',
        probability: (json['probability_non_diabetes'] as num).toDouble(),
      );
    } else if (json.containsKey('anemia_status')) {
      // hb_value is hemoglobin in g/dL. Normal >= 12 (women) / 13 (men).
      // Convert to anemia risk: lower hb = higher risk.
      // Clamp hb between 5 and 17, then invert to 0-1 risk probability.
      final hb = (json['hb_value'] as num?)?.toDouble() ?? 12.0;
      final riskProb = ((17.0 - hb.clamp(5.0, 17.0)) / 12.0).clamp(0.0, 1.0);
      final isAnemic = (json['anemia_status'] ?? '').toString().toLowerCase().contains('anemi');
      return PredictionResponse(
        prediction: isAnemic ? '1' : '0',
        probability: riskProb,
      );
    } else if (json.containsKey('anemia_probability')) {
      final prob = (json['anemia_probability'] as num).toDouble();
      return PredictionResponse(
        prediction: prob >= 0.5 ? '1' : '0',
        probability: prob,
        message: prob >= 0.5
            ? 'Likely to have anemia (${(prob * 100).toStringAsFixed(1)}%)'
            : 'Not likely to have anemia (${((1 - prob) * 100).toStringAsFixed(1)}%)',
      );
    } else {
      return PredictionResponse(
        prediction: json['prediction']?.toString() ?? '',
        probability: (json['probability'] ?? 0.0).toDouble(),
        message: json['message'] ?? '',
      );
    }
  }
}
