import 'package:flutter/material.dart';
import '../data/model/text_prediction_response.dart';
import 'anemia_detail_screen.dart';
import 'diabetes_detail_screen.dart';

class DiseaseDetailScreen extends StatelessWidget {
  final TextPredictionResponse response;

  const DiseaseDetailScreen({super.key, required this.response});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Analysis Results'), backgroundColor: Colors.teal),
      body: response.results.isEmpty
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.info_outline, size: 80, color: Colors.grey[400]),
                    const SizedBox(height: 16),
                    const Text(
                      'No matching conditions found',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Your symptoms don\'t match our database',
                      style: TextStyle(color: Colors.grey[600]),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            )
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.teal[50],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Your Input:',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      const SizedBox(height: 8),
                      Text(response.text, style: const TextStyle(fontSize: 14)),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Possible Conditions:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                ...response.results.map((result) => _buildDiseaseCard(context, result)),
              ],
            ),
    );
  }

  Widget _buildDiseaseCard(BuildContext context, DiseaseResult result) {
    final color = result.disease.toLowerCase() == 'anemia' ? Colors.red : Colors.blue;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () {
          final detail = response.resultsMap[result.disease];
          if (detail != null) {
            if (result.disease.toLowerCase() == 'anemia') {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AnemiaDetailScreen(detail: detail)),
              );
            } else if (result.disease.toLowerCase() == 'diabetes') {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => DiabetesDetailScreen(detail: detail)),
              );
            }
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(
                    '${result.percentage.toStringAsFixed(1)}%',
                    style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      result.disease.toUpperCase(),
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: color),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Matched: ${result.matchedSymptoms.join(", ")}',
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
              ),
              Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey[400]),
            ],
          ),
        ),
      ),
    );
  }
}
