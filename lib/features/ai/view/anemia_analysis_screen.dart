import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import '../../../core/service/service_locator.dart';
import '../data/model/anemia_survey_model.dart';
import '../viewmodel/prediction_cubit.dart';
import '../viewmodel/prediction_state.dart';
import 'analysis_result_screen.dart';
import '../widgets/analysis_shared_widgets.dart';

import 'analysis_history_screen.dart';

class AnemiaAnalysisScreen extends StatefulWidget {
  const AnemiaAnalysisScreen({super.key});

  @override
  State<AnemiaAnalysisScreen> createState() => _AnemiaAnalysisScreenState();
}

class _AnemiaAnalysisScreenState extends State<AnemiaAnalysisScreen> {
  static const _color = Colors.redAccent;
  static const _disease = 'Anemia';

  File? _image;
  final _textController = TextEditingController();
  late final PredictionCubit _cubit;

  int _age = 25;
  int _gender = 2;
  int _ethnicity = 3;
  int _diabetes = 2;
  int _hypertension = 2;
  int _heartCondition = 2;
  int _asthma = 2;

  @override
  void initState() {
    super.initState();
    _cubit = getIt<PredictionCubit>();
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  Future<void> _pickImage(ImageSource source) async {
    final picked = await ImagePicker().pickImage(source: source);
    if (picked != null) setState(() => _image = File(picked.path));
  }

  void _analyze() {
    if (_image == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please upload an image')));
      return;
    }
    if (_textController.text.trim().isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please describe your symptoms')));
      return;
    }
    _cubit.runCombinedAnalysis(
      disease: _disease,
      imageFile: _image!,
      surveyData: AnemiaSurveyModel(
        age: _age,
        gender: _gender,
        ethnicity: _ethnicity,
        diabetes: _diabetes,
        hypertension: _hypertension,
        heartCondition: _heartCondition,
        asthma: _asthma,
      ).toJson(),
      symptomText: _textController.text.trim(),
    );
  }

  Widget _toggleBtn(String label, int val, int current, void Function(int) onChanged) {
    final selected = current == val;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => onChanged(val)),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: EdgeInsets.symmetric(vertical: 12.h),
          decoration: BoxDecoration(
            color: selected ? _color : Colors.transparent,
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: selected ? _color : Colors.grey.shade300),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              color: selected ? Colors.white : Colors.grey.shade600,
            ),
          ),
        ),
      ),
    );
  }

  Widget _binaryRow(String label, int value, void Function(int) onChanged) {
    return Container(
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500, height: 1.4),
          ),
          SizedBox(height: 12.h),
          Row(
            children: [
              _toggleBtn('No', 2, value, onChanged),
              SizedBox(width: 8.w),
              _toggleBtn('Yes', 1, value, onChanged),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _cubit,
      child: BlocListener<PredictionCubit, PredictionState>(
        listener: (context, state) {
          if (state is CombinedAnalysisSuccess) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => AnalysisResultScreen(
                  disease: _disease,
                  color: _color,
                  icon: '🩸',
                  result: state,
                ),
              ),
            );
          } else if (state is PredictionError) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        child: Scaffold(
          body: CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 150.h,
                pinned: true,
                backgroundColor: _color,
                leading: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    margin: EdgeInsets.all(8.w),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: const Icon(Icons.arrow_back_rounded, color: Colors.white),
                  ),
                ),
                actions: [
                  GestureDetector(
                    onTap: () => Navigator.push(context, MaterialPageRoute(
                      builder: (_) => const AnalysisHistoryScreen(disease: _disease, color: _color, icon: '🩸'),
                    )),
                    child: Container(
                      margin: EdgeInsets.all(8.w),
                      padding: EdgeInsets.all(8.w),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Icon(Icons.history_rounded, color: Colors.white, size: 20.sp),
                    ),
                  ),
                ],
                flexibleSpace: FlexibleSpaceBar(
                  background: Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xFFB71C1C), Colors.redAccent],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: Align(
                      alignment: Alignment.bottomLeft,
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(20.w, 0, 20.w, 20.h),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('🩸', style: TextStyle(fontSize: 30.sp)),
                            SizedBox(height: 4.h),
                            Text(
                              'Anemia Analysis',
                              style: TextStyle(
                                fontSize: 22.sp,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              'Complete all sections for accurate results',
                              style: TextStyle(fontSize: 13.sp, color: Colors.white70),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SliverPadding(
                padding: EdgeInsets.all(20.w),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    // ── Step 1: Image ──────────────────────────────
                    const StepHeader(step: '1', title: 'Upload Eye Image', color: _color),
                    SizedBox(height: 12.h),
                    AnalysisImagePicker(
                      image: _image,
                      color: _color,
                      samplePath: 'assets/images/eye.webp',
                      onPick: _pickImage,
                      onRemove: () => setState(() => _image = null),
                    ),

                    SizedBox(height: 28.h),

                    // ── Step 2: Survey ─────────────────────────────
                    const StepHeader(step: '2', title: 'Health Survey', color: _color),
                    SizedBox(height: 12.h),

                    // Age
                    Container(
                      padding: EdgeInsets.all(14.w),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade50,
                        borderRadius: BorderRadius.circular(14.r),
                        border: Border.all(color: Colors.grey.shade200),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Age (years)',
                            style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500),
                          ),
                          SizedBox(height: 10.h),
                          TextFormField(
                            initialValue: _age.toString(),
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              hintText: 'Enter age (1–120)',
                              filled: true,
                              fillColor: Colors.white,
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 14.w,
                                vertical: 14.h,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12.r),
                                borderSide: BorderSide(color: Colors.grey.shade200),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12.r),
                                borderSide: BorderSide(color: Colors.grey.shade200),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12.r),
                                borderSide: const BorderSide(color: _color),
                              ),
                            ),
                            onChanged: (v) {
                              final age = int.tryParse(v);
                              if (age != null && age >= 1 && age <= 120) setState(() => _age = age);
                            },
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 10.h),

                    // Gender
                    Container(
                      padding: EdgeInsets.all(14.w),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade50,
                        borderRadius: BorderRadius.circular(14.r),
                        border: Border.all(color: Colors.grey.shade200),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Biological Sex',
                            style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500),
                          ),
                          SizedBox(height: 12.h),
                          Row(
                            children: [
                              _toggleBtn('Male', 1, _gender, (v) => _gender = v),
                              SizedBox(width: 8.w),
                              _toggleBtn('Female', 2, _gender, (v) => _gender = v),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 10.h),

                    // Ethnicity
                    Container(
                      padding: EdgeInsets.all(14.w),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade50,
                        borderRadius: BorderRadius.circular(14.r),
                        border: Border.all(color: Colors.grey.shade200),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Ethnicity',
                            style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500),
                          ),
                          SizedBox(height: 10.h),
                          DropdownButtonFormField<int>(
                            value: _ethnicity,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 14.w,
                                vertical: 14.h,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12.r),
                                borderSide: BorderSide(color: Colors.grey.shade200),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12.r),
                                borderSide: BorderSide(color: Colors.grey.shade200),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12.r),
                                borderSide: const BorderSide(color: _color),
                              ),
                            ),
                            items: const [
                              DropdownMenuItem(value: 1, child: Text('Mexican American')),
                              DropdownMenuItem(value: 2, child: Text('Other Hispanic')),
                              DropdownMenuItem(value: 3, child: Text('Non-Hispanic White')),
                              DropdownMenuItem(value: 4, child: Text('Non-Hispanic Black')),
                              DropdownMenuItem(value: 5, child: Text('Other or Mixed')),
                            ],
                            onChanged: (v) => setState(() => _ethnicity = v!),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 10.h),

                    _binaryRow(
                      'Have you been diagnosed with diabetes?',
                      _diabetes,
                      (v) => _diabetes = v,
                    ),
                    SizedBox(height: 10.h),
                    _binaryRow(
                      'Have you been diagnosed with hypertension?',
                      _hypertension,
                      (v) => _hypertension = v,
                    ),
                    SizedBox(height: 10.h),
                    _binaryRow(
                      'Have you been diagnosed with a heart condition?',
                      _heartCondition,
                      (v) => _heartCondition = v,
                    ),
                    SizedBox(height: 10.h),
                    _binaryRow('Have you been diagnosed with asthma?', _asthma, (v) => _asthma = v),

                    SizedBox(height: 28.h),

                    // ── Step 3: Symptoms Text ──────────────────────
                    const StepHeader(step: '3', title: 'Describe Your Symptoms', color: _color),
                    SizedBox(height: 12.h),
                    TextField(
                      controller: _textController,
                      maxLines: 4,
                      decoration: InputDecoration(
                        hintText: 'e.g., I feel very tired, pale skin, shortness of breath...',
                        filled: true,
                        fillColor: Colors.grey.shade50,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14.r),
                          borderSide: BorderSide(color: Colors.grey.shade200),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14.r),
                          borderSide: BorderSide(color: Colors.grey.shade200),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14.r),
                          borderSide: const BorderSide(color: _color),
                        ),
                      ),
                    ),

                    SizedBox(height: 32.h),

                    // ── Analyze Button ─────────────────────────────
                    BlocBuilder<PredictionCubit, PredictionState>(
                      builder: (context, state) {
                        final loading = state is PredictionLoading;
                        return DecoratedBox(
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFFB71C1C), Colors.redAccent],
                            ),
                            borderRadius: BorderRadius.circular(16.r),
                            boxShadow: [
                              BoxShadow(
                                color: _color.withOpacity(0.4),
                                blurRadius: 12,
                                offset: const Offset(0, 6),
                              ),
                            ],
                          ),
                          child: ElevatedButton(
                            onPressed: loading ? null : _analyze,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              shadowColor: Colors.transparent,
                              minimumSize: Size(double.infinity, 54.h),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16.r),
                              ),
                            ),
                            child: loading
                                ? const CircularProgressIndicator(color: Colors.white)
                                : Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Icon(Icons.auto_awesome_rounded, color: Colors.white),
                                      SizedBox(width: 8.w),
                                      Text(
                                        'Analyze',
                                        style: TextStyle(
                                          fontSize: 16.sp,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                          ),
                        );
                      },
                    ),
                    SizedBox(height: 32.h),
                  ]),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
