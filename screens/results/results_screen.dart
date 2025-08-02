import 'package:flutter/material.dart';
import '../../constants/app_constants.dart';
import '../navigation/main_navigation.dart';

class ResultsScreen extends StatefulWidget {
  final Map<String, dynamic> results;

  const ResultsScreen({super.key, required this.results});

  @override
  State<ResultsScreen> createState() => _ResultsScreenState();
}

class _ResultsScreenState extends State<ResultsScreen>
    with TickerProviderStateMixin {
  late AnimationController _scoreAnimationController;
  late AnimationController _rewardAnimationController;
  late Animation<double> _scoreAnimation;
  late Animation<double> _rewardAnimation;

  @override
  void initState() {
    super.initState();
    
    _scoreAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    
    _rewardAnimationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _scoreAnimation = Tween<double>(
      begin: 0.0,
      end: widget.results['percentage'] / 100.0,
    ).animate(CurvedAnimation(
      parent: _scoreAnimationController,
      curve: Curves.easeOutCubic,
    ));

    _rewardAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _rewardAnimationController,
      curve: Curves.elasticOut,
    ));

    // Start animations
    _scoreAnimationController.forward();
    Future.delayed(const Duration(milliseconds: 1000), () {
      _rewardAnimationController.forward();
    });
  }

  @override
  void dispose() {
    _scoreAnimationController.dispose();
    _rewardAnimationController.dispose();
    super.dispose();
  }

  String _getPerformanceMessage(int percentage) {
    if (percentage >= 90) {
      return 'ممتاز! أداء رائع';
    } else if (percentage >= 70) {
      return 'جيد جداً! استمر';
    } else if (percentage >= 50) {
      return 'جيد، يمكنك التحسن';
    } else {
      return 'يحتاج إلى مراجعة';
    }
  }

  Color _getPerformanceColor(int percentage) {
    if (percentage >= 90) {
      return Colors.green;
    } else if (percentage >= 70) {
      return Colors.blue;
    } else if (percentage >= 50) {
      return Colors.orange;
    } else {
      return Colors.red;
    }
  }

  int _getStarRating(int percentage) {
    if (percentage >= 90) return 3;
    if (percentage >= 70) return 2;
    if (percentage >= 50) return 1;
    return 0;
  }

  void _navigateToHome() {
    Navigator.of(context).pushAndRemoveUntil(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            MainNavigation(onThemeToggle: () {}),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
        transitionDuration: const Duration(milliseconds: 300),
      ),
      (route) => false,
    );
  }

  void _retakeQuiz() {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final score = widget.results['score'] as int;
    final total = widget.results['total'] as int;
    final percentage = widget.results['percentage'] as int;
    final starRating = _getStarRating(percentage);
    final performanceColor = _getPerformanceColor(percentage);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppConstants.defaultPadding),
          child: Column(
            children: [
              const SizedBox(height: 32),
              
              // Celebration Illustration
              Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                  color: performanceColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(75),
                ),
                child: Icon(
                  percentage >= 70 ? Icons.celebration : Icons.refresh,
                  size: 80,
                  color: performanceColor,
                ),
              ),
              const SizedBox(height: 32),

              // Score Display
              AnimatedBuilder(
                animation: _scoreAnimation,
                builder: (context, child) {
                  return Column(
                    children: [
                      // Circular Progress
                      SizedBox(
                        width: 120,
                        height: 120,
                        child: Stack(
                          children: [
                            CircularProgressIndicator(
                              value: _scoreAnimation.value,
                              strokeWidth: 12,
                              backgroundColor: performanceColor.withOpacity(0.2),
                              valueColor: AlwaysStoppedAnimation<Color>(performanceColor),
                            ),
                            Center(
                              child: Text(
                                '${(_scoreAnimation.value * 100).toInt()}%',
                                style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: performanceColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      
                      // Score Text
                      Text(
                        '$score من $total',
                        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      
                      // Performance Message
                      Text(
                        _getPerformanceMessage(percentage),
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: performanceColor,
                          fontWeight: FontWeight.w600,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  );
                },
              ),
              const SizedBox(height: 24),

              // Star Rating
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(3, (index) {
                  return Icon(
                    index < starRating ? Icons.star : Icons.star_border,
                    color: Colors.amber,
                    size: 32,
                  );
                }),
              ),
              const SizedBox(height: 32),

              // Rewards Section
              AnimatedBuilder(
                animation: _rewardAnimation,
                builder: (context, child) {
                  return Transform.scale(
                    scale: _rewardAnimation.value,
                    child: Container(
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
                          Text(
                            'المكافآت المكتسبة',
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16),
                          
                          // Rewards Row
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              // Coins Reward
                              Column(
                                children: [
                                  Container(
                                    width: 60,
                                    height: 60,
                                    decoration: BoxDecoration(
                                      color: Theme.of(context).colorScheme.secondary,
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                    child: const Icon(
                                      Icons.monetization_on,
                                      color: Colors.white,
                                      size: 30,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    '+${percentage >= 70 ? 50 : 25} عملة',
                                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              
                              // XP Reward
                              Column(
                                children: [
                                  Container(
                                    width: 60,
                                    height: 60,
                                    decoration: BoxDecoration(
                                      color: Theme.of(context).colorScheme.primary,
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                    child: const Icon(
                                      Icons.star,
                                      color: Colors.white,
                                      size: 30,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    '+${percentage >= 70 ? 100 : 50} XP',
                                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          
                          // Level Up Notification (if applicable)
                          if (percentage >= 90) ...[
                            const SizedBox(height: 16),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                              decoration: BoxDecoration(
                                color: Colors.amber.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(color: Colors.amber),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(
                                    Icons.trending_up,
                                    color: Colors.amber,
                                    size: 20,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    'ترقية إلى المستوى ${AppConstants.mockUserLevel + 1}!',
                                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                      color: Colors.amber[700],
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 32),

              // Action Buttons
              Column(
                children: [
                  // Next Lesson Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _navigateToHome,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: Text(
                        percentage >= 70 ? 'الدرس التالي' : 'العودة للمسار',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  
                  // Secondary Actions Row
                  Row(
                    children: [
                      // Retake Quiz
                      Expanded(
                        child: OutlinedButton(
                          onPressed: _retakeQuiz,
                          child: const Text('إعادة الاختبار'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      
                      // Return to Course
                      Expanded(
                        child: OutlinedButton(
                          onPressed: _navigateToHome,
                          child: const Text('العودة للمسار'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
