import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/data/repositories/python_repository.dart';

class CourseViewScreen extends StatefulWidget {
  final String trackId;

  const CourseViewScreen({super.key, required this.trackId});

  @override
  State<CourseViewScreen> createState() => _CourseViewScreenState();
}

class _CourseViewScreenState extends State<CourseViewScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late List<AnimationController> _lessonControllers;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    // Initialize lesson controllers for staggered animation
    _lessonControllers = List.generate(
      6, // Number of lessons
      (index) => AnimationController(
        duration: Duration(milliseconds: 300 + (index * 100)),
        vsync: this,
      ),
    );

    _animationController.forward();
    _startLessonAnimations();
  }

  void _startLessonAnimations() async {
    for (int i = 0; i < _lessonControllers.length; i++) {
      await Future.delayed(Duration(milliseconds: i * 150));
      if (mounted) {
        _lessonControllers[i].forward();
      }
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    for (var controller in _lessonControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _navigateToLesson(BuildContext context, String lessonId) {
    context.push('/lesson/$lessonId');
  }

  void _showLockedDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Text(
            'درس مقفل 🔒',
            style: Theme.of(context).textTheme.headlineSmall,
            textAlign: TextAlign.center,
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.errorContainer,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Icon(
                  Icons.lock_rounded,
                  size: 40,
                  color: Theme.of(context).colorScheme.error,
                ),
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

  Widget _buildLessonNode({
    required int index,
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required bool isUnlocked,
    required bool isCompleted,
    required VoidCallback onTap,
    required bool isLeft,
  }) {
    return AnimatedBuilder(
      animation: _lessonControllers[index],
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(
            0,
            50 * (1 - _lessonControllers[index].value),
          ),
          child: Opacity(
            opacity: _lessonControllers[index].value,
            child: Container(
              margin: EdgeInsets.only(
                left: isLeft ? 0 : 100,
                right: isLeft ? 100 : 0,
                bottom: 40,
              ),
              child: GestureDetector(
                onTap: onTap,
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: isUnlocked
                        ? LinearGradient(
                            colors: [
                              color,
                              color.withOpacity(0.7),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          )
                        : LinearGradient(
                            colors: [
                              Colors.grey.shade300,
                              Colors.grey.shade400,
                            ],
                          ),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: isUnlocked
                            ? color.withOpacity(0.3)
                            : Colors.grey.withOpacity(0.2),
                        blurRadius: 15,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 5,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: Icon(
                              isCompleted
                                  ? Icons.check_circle_rounded
                                  : isUnlocked
                                      ? icon
                                      : Icons.lock_rounded,
                              color: isCompleted
                                  ? Colors.green
                                  : isUnlocked
                                      ? color
                                      : Colors.grey,
                              size: 28,
                            ),
                          ),
                          const Spacer(),
                          if (isCompleted)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                '✓ مكتمل',
                                style: TextStyle(
                                  color: Colors.green,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        title,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.white.withOpacity(0.9),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildConnectionLine(bool isLeft) {
    return Container(
      margin: EdgeInsets.only(
        left: isLeft ? 80 : 180,
        right: isLeft ? 180 : 80,
      ),
      child: CustomPaint(
        size: const Size(double.infinity, 40),
        painter: DottedLinePainter(
          color: Theme.of(context).colorScheme.primary.withOpacity(0.5),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final track = PythonRepository.pythonTrack;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFF),
      body: SafeArea(
        child: Column(
          children: [
            // Custom Header
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    const Color(0xFF4A90E2),
                    const Color(0xFF7B68EE),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      IconButton(
                        onPressed: () => context.pop(),
                        icon: const Icon(
                          Icons.arrow_back_ios_rounded,
                          color: Colors.white,
                        ),
                      ),
                      const Spacer(),
                      Row(
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Center(
                              child: Text('🐍', style: TextStyle(fontSize: 20)),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            'PYTHON X',
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.2,
                            ),
                          ),
                        ],
                      ),
                      const Spacer(),
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.search_rounded,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Text(
                    '${AppConstants.mockUserName}، مرحباً بك في عالم البايثون',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Colors.white.withOpacity(0.9),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),

            // Learning Path
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    // Lesson 1 - Getting Started (Unlocked)
                    _buildLessonNode(
                      index: 0,
                      title: '1. البداية',
                      subtitle: 'تعلم أساسيات البايثون',
                      icon: Icons.rocket_launch_rounded,
                      color: const Color(0xFF4A90E2),
                      isUnlocked: true,
                      isCompleted: false,
                      isLeft: true,
                      onTap: () => _navigateToLesson(context, 'python_hello'),
                    ),

                    _buildConnectionLine(true),

                    // Lesson 2 - Variables (Locked)
                    _buildLessonNode(
                      index: 1,
                      title: '2. المتغيرات',
                      subtitle: 'تعلم كيفية استخدام المتغيرات',
                      icon: Icons.storage_rounded,
                      color: const Color(0xFF7B68EE),
                      isUnlocked: false,
                      isCompleted: false,
                      isLeft: false,
                      onTap: () => _showLockedDialog(context),
                    ),

                    _buildConnectionLine(false),

                    // Lesson 3 - Working (Locked)
                    _buildLessonNode(
                      index: 2,
                      title: '3. العمل مع البيانات',
                      subtitle: 'معالجة وتحليل البيانات',
                      icon: Icons.computer_rounded,
                      color: const Color(0xFF4CAF50),
                      isUnlocked: false,
                      isCompleted: false,
                      isLeft: true,
                      onTap: () => _showLockedDialog(context),
                    ),

                    _buildConnectionLine(true),

                    // Lesson 4 - Functions (Locked)
                    _buildLessonNode(
                      index: 3,
                      title: '4. الدوال',
                      subtitle: 'إنشاء واستخدام الدوال',
                      icon: Icons.functions_rounded,
                      color: const Color(0xFFFF9800),
                      isUnlocked: false,
                      isCompleted: false,
                      isLeft: false,
                      onTap: () => _showLockedDialog(context),
                    ),

                    _buildConnectionLine(false),

                    // Lesson 5 - Loops (Locked)
                    _buildLessonNode(
                      index: 4,
                      title: '5. الحلقات',
                      subtitle: 'التكرار والحلقات',
                      icon: Icons.loop_rounded,
                      color: const Color(0xFFE91E63),
                      isUnlocked: false,
                      isCompleted: false,
                      isLeft: true,
                      onTap: () => _showLockedDialog(context),
                    ),

                    _buildConnectionLine(true),

                    // Final Project (Locked)
                    _buildLessonNode(
                      index: 5,
                      title: '6. المشروع النهائي',
                      subtitle: 'تطبيق ما تعلمته',
                      icon: Icons.emoji_events_rounded,
                      color: const Color(0xFFFFD700),
                      isUnlocked: false,
                      isCompleted: false,
                      isLeft: false,
                      onTap: () => _showLockedDialog(context),
                    ),

                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DottedLinePainter extends CustomPainter {
  final Color color;

  DottedLinePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    const dashWidth = 8.0;
    const dashSpace = 4.0;
    double startY = 0;

    while (startY < size.height) {
      canvas.drawLine(
        Offset(size.width / 2, startY),
        Offset(size.width / 2, startY + dashWidth),
        paint,
      );
      startY += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
