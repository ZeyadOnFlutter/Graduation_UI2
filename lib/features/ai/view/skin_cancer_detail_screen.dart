import 'package:flutter/material.dart';
import '../data/model/text_prediction_response.dart';
import 'upload_screen.dart';

class SkinCancerDetailScreen extends StatelessWidget {
  final DiseaseDetail detail;

  const SkinCancerDetailScreen({Key? key, required this.detail}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Skin Cancer Details'),
        backgroundColor: Colors.brown,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Colors.brown, Color(0xFF5D4037)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                const Icon(Icons.healing, size: 60, color: Colors.white),
                const SizedBox(height: 12),
                const Text(
                  'SKIN CANCER',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                const SizedBox(height: 8),
                Text(
                  'Match: ${detail.percentage.toStringAsFixed(1)}%',
                  style: const TextStyle(fontSize: 18, color: Colors.white70),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          _buildSection(
            'Matched Symptoms',
            detail.matchedSymptoms.map((s) => '• $s').join('\n'),
            Icons.check_circle,
            Colors.brown,
          ),
          const SizedBox(height: 16),
          _buildSection(
            'What is Skin Cancer?',
            'Skin cancer is the abnormal growth of skin cells, most often developing on skin exposed to the sun. It can also occur on areas not ordinarily exposed to sunlight.',
            Icons.info,
            Colors.brown,
          ),
          const SizedBox(height: 16),
          _buildSection(
            'Common Symptoms',
            '• New spot or growth on skin\n• Change in existing mole\n• Dark or unusual colored patch\n• Sore that doesn\'t heal\n• Itchy or bleeding lesion',
            Icons.list,
            Colors.brown,
          ),
          const SizedBox(height: 16),
          _buildSection(
            'Recommendation',
            'Consult a dermatologist immediately for a proper skin examination. Early detection significantly improves treatment outcomes.',
            Icons.medical_services,
            Colors.brown,
          ),
          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const UploadScreen(
                      category: 'Skin Cancer',
                      icon: '🔬',
                      color: Colors.brown,
                      sampleImagePath: 'assets/images/skincancer.jpeg',
                    ),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.brown,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text(
                'Continue to Upload Image',
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildSection(String title, String content, IconData icon, Color color) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: color, size: 24),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: color),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(content, style: const TextStyle(fontSize: 14, height: 1.5)),
          ],
        ),
      ),
    );
  }
}
