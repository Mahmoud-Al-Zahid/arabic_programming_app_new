import 'package:flutter/material.dart';
import '../../../../core/data/models/user_model.dart';

class ContinueLearningCard extends StatelessWidget {
  final User user;

  const ContinueLearningCard({
    super.key,
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    final currentLanguage = user.progress.currentLanguage;
    final currentLesson = user.progress.currentLesson;
    
    if (currentLanguage.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.indigo.shade400,
            Colors.purple.shade400,
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.indigo.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          // Icon
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(15),
            ),
            child: const Icon(
              Icons.play_circle_fill,
              color: Colors.white,
              size: 28,
            ),
          ),
          
          const SizedBox(width: 16),
          
          // Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'استمر في التعلم',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _getLanguageName(currentLanguage),
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 14,
                  ),
                ),
                if (currentLesson.isNotEmpty) ...[
                  const SizedBox(height: 2),
                  Text(
                    'الدرس الحالي: ${_getLessonName(currentLesson)}',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.8),
                      fontSize: 12,
                    ),
                  ),
                ],
              ],
            ),
          ),
          
          // Arrow
          Icon(
            Icons.arrow_forward_ios,
            color: Colors.white.withOpacity(0.8),
            size: 16,
          ),
        ],
      ),
    );
  }

  String _getLanguageName(String languageId) {
    switch (languageId) {
      case 'python':
        return 'Python';
      case 'javascript':
        return 'JavaScript';
      case 'java':
        return 'Java';
      default:
        return languageId;
    }
  }

  String _getLessonName(String lessonId) {
    switch (lessonId) {
      case 'intro_01':
        return 'مقدمة في البرمجة';
      case 'variables_03':
        return 'المتغيرات';
      default:
        return lessonId;
    }
  }
}
