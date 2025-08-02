import 'package:flutter/material.dart';
import '../../constants/app_constants.dart';
import '../../constants/mock_data.dart';
import '../lesson/lesson_screen.dart';

class CourseViewScreen extends StatelessWidget {
  final Map<String, dynamic> track;

  const CourseViewScreen({super.key, required this.track});

  void _navigateToLesson(BuildContext context, Map<String, dynamic> lesson) {
    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            LessonScreen(lesson: lesson),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(1.0, 0.0),
              end: Offset.zero,
            ).animate(animation),
            child: child,
          );
        },
        transitionDuration: const Duration(milliseconds: 300),
      ),
    );
  }

  void _showLockedDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppConstants.defaultBorderRadius),
          ),
          title: Text(
            'درس مقفل',
            style: Theme.of(context).textTheme.headlineSmall,
            textAlign: TextAlign.center,
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.lock,
                size: 64,
                color: Colors.grey,
              ),
              const SizedBox(height: 16),
              Text(
                'يجب إكمال الدروس السابقة أولاً',
                style: Theme.of(context).textTheme.bodyLarge,
                textAlign: TextAlign.center,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('حسناً'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final trackTitle = track['title'] as String;
    final progress = track['progress'] as double;
    final lessonsCount = track['lessonsCount'] as int;

    // Mock units data for zigzag layout
    final List<Map<String, dynamic>> units = [
      {
        'id': 'unit_1',
        'title': 'الوحدة الأولى: المقدمة',
        'lessons': 3,
        'isUnlocked': true,
        'isCompleted': track['id'] == 'python' ? true : false,
      },
      {
        'id': 'unit_2',
        'title': 'الوحدة الثانية: الأساسيات',
        'lessons': 4,
        'isUnlocked': track['id'] == 'python' ? true : false,
        'isCompleted': false,
      },
      {
        'id': 'unit_3',
        'title': 'الوحدة الثالثة: التطبيق',
        'lessons': 5,
        'isUnlocked': false,
        'isCompleted': false,
      },
      {
        'id': 'unit_4',
        'title': 'الوحدة الرابعة: المشاريع',
        'lessons': 3,
        'isUnlocked': false,
        'isCompleted': false,
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(trackTitle),
        centerTitle: true,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppConstants.defaultPadding),
          child: Column(
            children: [
              // Progress Overview
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(AppConstants.defaultPadding),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Theme.of(context).colorScheme.primary.withOpacity(0.1),
                      Theme.of(context).colorScheme.secondary.withOpacity(0.1),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(AppConstants.defaultBorderRadius),
                ),
                child: Column(
                  children: [
                    // Circular Progress
                    SizedBox(
                      width: 100,
                      height: 100,
                      child: Stack(
                        children: [
                          CircularProgressIndicator(
                            value: progress,
                            strokeWidth: 8,
                            backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.2),
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Theme.of(context).colorScheme.primary,
                            ),
                          ),
                          Center(
                            child: Text(
                              '${(progress * 100).toInt()}%',
                              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      trackTitle,
                      style: Theme.of(context).textTheme.headlineSmall,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      track['description'],
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // Zigzag Units Layout
              ...units.asMap().entries.map((entry) {
                final index = entry.key;
                final unit = entry.value;
                final isLeft = index % 2 == 0;

                return Container(
                  margin: const EdgeInsets.only(bottom: 24),
                  child: Row(
                    children: [
                      if (!isLeft) const Expanded(child: SizedBox()),
                      // Unit Card
                      Expanded(
                        flex: 2,
                        child: GestureDetector(
                          onTap: () {
                            if (unit['isUnlocked']) {
                              // For demo, only Python track has accessible lesson
                              if (track['id'] == 'python' && index == 0) {
                                _navigateToLesson(context, MockData.pythonDemoLesson);
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('محتوى تجريبي - الدروس قيد التطوير'),
                                  ),
                                );
                              }
                            } else {
                              _showLockedDialog(context);
                            }
                          },
                          child: Container(
                            padding: const EdgeInsets.all(AppConstants.defaultPadding),
                            decoration: BoxDecoration(
                              color: unit['isUnlocked']
                                  ? Theme.of(context).colorScheme.surface
                                  : Colors.grey.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(AppConstants.defaultBorderRadius),
                              border: Border.all(
                                color: unit['isCompleted']
                                    ? Theme.of(context).colorScheme.secondary
                                    : unit['isUnlocked']
                                        ? Theme.of(context).colorScheme.primary.withOpacity(0.3)
                                        : Colors.grey.withOpacity(0.3),
                                width: 2,
                              ),
                              boxShadow: unit['isUnlocked']
                                  ? [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.1),
                                        blurRadius: 8,
                                        offset: const Offset(0, 4),
                                      ),
                                    ]
                                  : null,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Icon(
                                      unit['isCompleted']
                                          ? Icons.check_circle
                                          : unit['isUnlocked']
                                              ? Icons.play_circle_outline
                                              : Icons.lock,
                                      color: unit['isCompleted']
                                          ? Theme.of(context).colorScheme.secondary
                                          : unit['isUnlocked']
                                              ? Theme.of(context).colorScheme.primary
                                              : Colors.grey,
                                    ),
                                    Text(
                                      '${unit['lessons']} دروس',
                                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                        color: unit['isUnlocked']
                                            ? Theme.of(context).colorScheme.onSurface.withOpacity(0.7)
                                            : Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  unit['title'],
                                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                    color: unit['isUnlocked']
                                        ? Theme.of(context).colorScheme.onSurface
                                        : Colors.grey,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      if (isLeft) const Expanded(child: SizedBox()),
                    ],
                  ),
                );
              }).toList(),

              // Final Exam Section
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(AppConstants.defaultPadding),
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(AppConstants.defaultBorderRadius),
                  border: Border.all(
                    color: Colors.grey.withOpacity(0.3),
                    width: 2,
                  ),
                ),
                child: Column(
                  children: [
                    Icon(
                      Icons.quiz,
                      size: 48,
                      color: Colors.grey,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'الامتحان النهائي',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: Colors.grey,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'يجب إكمال جميع الوحدات أولاً',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.grey,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: null, // Disabled
                      child: const Text('ابدأ الامتحان'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
