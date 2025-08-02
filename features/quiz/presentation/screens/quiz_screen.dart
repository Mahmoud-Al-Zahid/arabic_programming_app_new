import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/providers/lesson_provider.dart';

class QuizScreen extends ConsumerStatefulWidget {
  final String quizId;

  const QuizScreen({super.key, required this.quizId});

  @override
  ConsumerState<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends ConsumerState<QuizScreen> {
  int _currentQuestion = 0;
  final Map<int, dynamic> _answers = {};

  void _selectAnswer(dynamic answer) {
    setState(() {
      _answers[_currentQuestion] = answer;
    });
  }

  void _nextQuestion(List<dynamic> questions) {
    if (_currentQuestion < questions.length - 1) {
      setState(() {
        _currentQuestion++;
      });
    } else {
      _finishQuiz(questions);
    }
  }

  void _previousQuestion() {
    if (_currentQuestion > 0) {
      setState(() {
        _currentQuestion--;
      });
    }
  }

  void _finishQuiz(List<dynamic> questions) {
    // Calculate score
    int correctAnswers = 0;
    for (int i = 0; i < questions.length; i++) {
      final question = questions[i];
      final userAnswer = _answers[i];
      
      if (userAnswer == question.correctAnswer) {
        correctAnswers++;
      }
    }

    final results = {
      'score': correctAnswers,
      'total': questions.length,
      'percentage': (correctAnswers / questions.length * 100).round(),
      'answers': _answers,
      'questions': questions,
    };

    context.pushReplacement('/results', extra: results);
  }

  Widget _buildMultipleChoiceQuestion(dynamic question) {
    final options = question.options as List<String>;
    final selectedAnswer = _answers[_currentQuestion];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          question.question,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 24),
        ...options.asMap().entries.map((entry) {
          final index = entry.key;
          final option = entry.value;
          final isSelected = selectedAnswer == index;

          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            child: InkWell(
              onTap: () => _selectAnswer(index),
              borderRadius: BorderRadius.circular(AppConstants.defaultBorderRadius),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(AppConstants.defaultPadding),
                decoration: BoxDecoration(
                  color: isSelected
                      ? Theme.of(context).colorScheme.primary.withOpacity(0.1)
                      : Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(AppConstants.defaultBorderRadius),
                  border: Border.all(
                    color: isSelected
                        ? Theme.of(context).colorScheme.primary
                        : Theme.of(context).colorScheme.primary.withOpacity(0.3),
                    width: isSelected ? 2 : 1,
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isSelected
                            ? Theme.of(context).colorScheme.primary
                            : Colors.transparent,
                        border: Border.all(
                          color: Theme.of(context).colorScheme.primary,
                          width: 2,
                        ),
                      ),
                      child: isSelected
                          ? const Icon(
                              Icons.check,
                              color: Colors.white,
                              size: 16,
                            )
                          : null,
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        option,
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final quizAsync = ref.watch(quizByIdProvider(widget.quizId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('الاختبار'),
      ),
      body: SafeArea(
        child: quizAsync.when(
          data: (quiz) {
            if (quiz == null || quiz.questions == null || quiz.questions!.isEmpty) {
              return const Center(child: Text('لا توجد أسئلة متاحة'));
            }

            final questions = quiz.questions!;
            final currentQuestion = questions[_currentQuestion];
            final hasAnswer = _answers.containsKey(_currentQuestion);
            final isLastQuestion = _currentQuestion == questions.length - 1;

            return Column(
              children: [
                // Progress Header
                Container(
                  padding: const EdgeInsets.all(AppConstants.defaultPadding),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'السؤال ${_currentQuestion + 1} من ${questions.length}',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.timer,
                                  size: 16,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  '05:00',
                                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: Theme.of(context).colorScheme.primary,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      LinearProgressIndicator(
                        value: (_currentQuestion + 1) / questions.length,
                        backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.2),
                        valueColor: AlwaysStoppedAnimation<Color>(
                          Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                ),

                // Question Content
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(AppConstants.defaultPadding),
                    child: _buildMultipleChoiceQuestion(currentQuestion),
                  ),
                ),

                // Navigation Buttons
                Container(
                  padding: const EdgeInsets.all(AppConstants.defaultPadding),
                  child: Row(
                    children: [
                      // Previous Button
                      if (_currentQuestion > 0)
                        Expanded(
                          child: OutlinedButton(
                            onPressed: _previousQuestion,
                            child: const Text('السابق'),
                          ),
                        ),
                      if (_currentQuestion > 0) const SizedBox(width: 16),
                      // Next/Finish Button
                      Expanded(
                        flex: _currentQuestion == 0 ? 1 : 1,
                        child: ElevatedButton(
                          onPressed: hasAnswer ? (isLastQuestion ? () => _finishQuiz(questions) : () => _nextQuestion(questions)) : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Theme.of(context).colorScheme.primary,
                            foregroundColor: Colors.white,
                          ),
                          child: Text(
                            isLastQuestion ? 'إنهاء الاختبار' : 'التالي',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stack) => Center(
            child: Text('حدث خطأ في تحميل الاختبار: $error'),
          ),
        ),
      ),
    );
  }
}
