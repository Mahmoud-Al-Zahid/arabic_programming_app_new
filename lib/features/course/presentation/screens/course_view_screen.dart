import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/data/repositories/python_repository.dart';

class CourseViewScreen extends StatelessWidget {
  final String trackId;

  const CourseViewScreen({super.key, required this.trackId});

  void _navigateToLesson(BuildContext context, String lessonId) {
    context.push('/lesson/$lessonId');
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
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
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
    final track = PythonRepository.pythonTrack;
    final units = PythonRepository.getPythonUnits();

    return Scaffold(
      appBar: AppBar(
        title: Text(track.title),
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
                            value: track.progress,
                            strokeWidth: 8,
                            backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.2),
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Theme.of(context).colorScheme.primary,
                            ),
                          ),
                          Center(
                            child: Text(
                              '${(track.progress * 100).toInt()}%',
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
                      track.title,
                      style: Theme.of(context).textTheme.headlineSmall,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      track.description,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // Units Layout
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
                              // Only first unit has accessible lesson
                              if (index == 0) {
                                _navigateToLesson(context, 'python_hello');
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
                                  : Theme.of(context).colorScheme.surface.withOpacity(0.5),
                              borderRadius: BorderRadius.circular(AppConstants.defaultBorderRadius),
                              border: Border.all(
                                color: unit['isCompleted']
                                    ? Theme.of(context).colorScheme.secondary
                                    : unit['isUnlocked']
                                        ? Theme.of(context).colorScheme.primary.withOpacity(0.3)
                                        : Theme.of(context).colorScheme.onSurface.withOpacity(0.3),
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
                                              : Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
                                    ),
                                    Text(
                                      '${unit['lessons']} دروس',
                                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                        color: unit['isUnlocked']
                                            ? Theme.of(context).colorScheme.onSurface.withOpacity(0.7)
                                            : Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
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
                                        : Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
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
                  color: Theme.of(context).colorScheme.surface.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(AppConstants.defaultBorderRadius),
                  border: Border.all(
                    color: Theme.of(context).colorScheme.onSurface.withOpacity(0.3),
                    width: 2,
                  ),
                ),
                child: Column(
                  children: [
                    Icon(
                      Icons.quiz,
                      size: 48,
                      color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'الامتحان النهائي',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'يجب إكمال جميع الوحدات أولاً',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
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
