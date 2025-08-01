import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_constants.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<OnboardingSlide> _slides = [
    const OnboardingSlide(
      title: 'تعلم البايثون بالعربية بسهولة',
      subtitle: 'منصة شاملة لتعلم لغة البايثون من الصفر',
      icon: Icons.code,
      color: Color(0xFF2979FF),
    ),
    const OnboardingSlide(
      title: 'تعلم واربح النقاط والمستويات',
      subtitle: 'نظام تفاعلي مع XP ومستويات وعملات',
      icon: Icons.emoji_events,
      color: Color(0xFF00E676),
    ),
    const OnboardingSlide(
      title: 'اختبارات وتحديات تفاعلية',
      subtitle: 'طور مهاراتك من خلال التطبيق العملي',
      icon: Icons.quiz,
      color: Color(0xFFFF6B35),
    ),
  ];

  void _nextPage() {
    if (_currentPage < _slides.length - 1) {
      _pageController.nextPage(
        duration: AppConstants.defaultAnimationDuration,
        curve: Curves.easeInOut,
      );
    } else {
      context.go('/registration');
    }
  }

  void _skipToRegistration() {
    context.go('/registration');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Header with indicators and skip button
            Padding(
              padding: const EdgeInsets.all(AppConstants.defaultPadding),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SizedBox(width: 60),
                  // Page Indicators
                  Row(
                    children: List.generate(
                      _slides.length,
                      (index) => Container(
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        width: _currentPage == index ? 24 : 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: _currentPage == index
                              ? Theme.of(context).colorScheme.primary
                              : Theme.of(context).colorScheme.primary.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                  ),
                  // Skip Button
                  TextButton(
                    onPressed: _skipToRegistration,
                    child: Text(
                      'تخطي',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // PageView
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                itemCount: _slides.length,
                itemBuilder: (context, index) {
                  final slide = _slides[index];
                  return Padding(
                    padding: const EdgeInsets.all(AppConstants.largePadding),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Illustration
                        Container(
                          width: 200,
                          height: 200,
                          decoration: BoxDecoration(
                            color: slide.color.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(100),
                          ),
                          child: Icon(
                            slide.icon,
                            size: 100,
                            color: slide.color,
                          ),
                        ),
                        const SizedBox(height: 40),
                        // Title
                        Text(
                          slide.title,
                          style: Theme.of(context).textTheme.headlineLarge,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        // Subtitle
                        Text(
                          slide.subtitle,
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            // Next Button
            Padding(
              padding: const EdgeInsets.all(AppConstants.largePadding),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _nextPage,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: Text(
                    _currentPage == _slides.length - 1 ? 'ابدأ الآن' : 'التالي',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class OnboardingSlide {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;

  const OnboardingSlide({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
  });
}
