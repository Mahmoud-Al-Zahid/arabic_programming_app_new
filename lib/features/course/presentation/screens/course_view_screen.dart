import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/data/repositories/python_repository.dart';
import '../../../../core/data/models/lesson_model.dart';

class CourseViewScreen extends ConsumerStatefulWidget {
  final String trackId;

  const CourseViewScreen({super.key, required this.trackId});

  @override
  ConsumerState<CourseViewScreen> createState() => _CourseViewScreenState();
}

class _CourseViewScreenState extends ConsumerState<CourseViewScreen>
    with TickerProviderStateMixin {
  late AnimationController _headerController;
  late AnimationController _lessonsController;
  late Animation<double> _headerAnimation;
  late Animation<double> _lessonsAnimation;

  @override
  void initState() {
    super.initState();
    _headerController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _lessonsController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _headerAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _headerController,
      curve: Curves.easeOut,
    ));

    _lessonsAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _lessonsController,
      curve: Curves.easeOutCubic,
    ));

    _headerController.forward();
    Future.delayed(const Duration(milliseconds: 300), () {
      _lessonsController.forward();
    });
  }

  @override
  void dispose() {
    _headerController.dispose();
    _lessonsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final track = ref.watch(pythonRepositoryProvider).getTrackById(widget.trackId);
    final lessons = ref.watch(pythonRepositoryProvider).getLessonsByTrackId(widget.trackId);

    if (track == null) {
      return const Scaffold(
        body: Center(child: Text('المسار غير موجود')),
      );
    }

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              const Color(0xFF4A90E2),
              const Color(0xFF7BB3F0),
              Theme.of(context).colorScheme.surface,
            ],
            stops: const [0.0, 0.4, 1.0],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header Section
              FadeTransition(
                opacity: _headerAnimation,
                child: Container(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      // Top Bar
                      Row(
                        children: [
                          IconButton(
                            onPressed: () => context.pop(),
                            icon: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(
                                Icons.arrow_back_ios_rounded,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                          ),
                          const Spacer(),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  width: 32,
                                  height: 32,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: const Center(
                                    child: Text(
                                      '🐍',
                                      style: TextStyle(fontSize: 18),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                const Text(
                                  'PYTHON X',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Spacer(),
                          IconButton(
                            onPressed: () {},
                            icon: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(
                                Icons.search_rounded,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                          ),
                        ],
                      ),
                      
                      const SizedBox(height: 20),
                      
                      // Welcome Message
                      const Text(
                        'أحمد، مرحباً بك في عالم Python',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),

              // Lessons Path
              Expanded(
                child: Container(
                  margin: const EdgeInsets.only(top: 20),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: AnimatedBuilder(
                    animation: _lessonsAnimation,
                    builder: (context, child) {
                      return SingleChildScrollView(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          children: [
                            const SizedBox(height: 20),
                            ...lessons.asMap().entries.map((entry) {
                              final index = entry.key;
                              final lesson = entry.value;
                              final isLeft = index % 2 == 0;
                              
                              return AnimatedOpacity(
                                opacity: _lessonsAnimation.value,
                                duration: Duration(milliseconds: 300 + (index * 100)),
                                child: AnimatedSlide(
                                  offset: Offset(
                                    isLeft ? -0.3 * (1 - _lessonsAnimation.value) : 0.3 * (1 - _lessonsAnimation.value),
                                    0,
                                  ),
                                  duration: Duration(milliseconds: 500 + (index * 100)),
                                  curve: Curves.easeOutCubic,
                                  child: _buildLessonCard(lesson, index, isLeft),
                                ),
                              );
                            }).toList(),
                            const SizedBox(height: 100),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLessonCard(LessonModel lesson, int index, bool isLeft) {
    final colors = [
      [const Color(0xFF4A90E2), const Color(0xFF7BB3F0)], // Blue
      [const Color(0xFF8E44AD), const Color(0xFFBB6BD9)], // Purple
      [const Color(0xFF27AE60), const Color(0xFF58D68D)], // Green
      [const Color(0xFFE67E22), const Color(0xFFF39C12)], // Orange
      [const Color(0xFFE91E63), const Color(0xFFF48FB1)], // Pink
      [const Color(0xFFFFD700), const Color(0xFFFFF176)], // Gold
    ];
    
    final icons = [
      Icons.rocket_launch_rounded,
      Icons.storage_rounded,
      Icons.computer_rounded,
      Icons.functions_rounded,
      Icons.loop_rounded,
      Icons.emoji_events_rounded,
    ];

    final colorPair = colors[index % colors.length];
    final icon = icons[index % icons.length];
    final isCompleted = index < 2; // First 2 lessons completed
    final isLocked = index > 2; // Lessons after 3rd are locked

    return Container(
      margin: EdgeInsets.only(
        bottom: 30,
        left: isLeft ? 0 : 60,
        right: isLeft ? 60 : 0,
      ),
      child: Stack(
        children: [
          // Connecting Line
          if (index < 5)
            Positioned(
              top: 80,
              left: isLeft ? 120 : -60,
              child: Container(
                width: 80,
                height: 2,
                child: CustomPaint(
                  painter: DottedLinePainter(
                    color: Theme.of(context).colorScheme.outline.withOpacity(0.3),
                  ),
                ),
              ),
            ),

          // Lesson Card
          GestureDetector(
            onTap: isLocked ? null : () {
              context.push('/lesson/${lesson.id}');
            },
            child: Container(
              width: 200,
              height: 120,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: isLocked 
                    ? [Colors.grey.shade300, Colors.grey.shade400]
                    : colorPair,
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: (isLocked ? Colors.grey : colorPair[0]).withOpacity(0.3),
                    blurRadius: 15,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Stack(
                children: [
                  // Background Pattern
                  Positioned(
                    top: -20,
                    right: -20,
                    child: Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                  
                  // Content
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Icon
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            isLocked ? Icons.lock_rounded : icon,
                            color: Colors.white,
                            size: 24,
                          ),
                        ),
                        
                        const Spacer(),
                        
                        // Title
                        Text(
                          '${index + 1}. ${lesson.title}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  
                  // Status Badge
                  if (isCompleted)
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Container(
                        width: 24,
                        height: 24,
                        decoration: BoxDecoration(
                          color: Colors.green,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                        child: const Icon(
                          Icons.check_rounded,
                          color: Colors.white,
                          size: 14,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
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
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    const dashWidth = 5.0;
    const dashSpace = 3.0;
    double startX = 0;

    while (startX < size.width) {
      canvas.drawLine(
        Offset(startX, size.height / 2),
        Offset(startX + dashWidth, size.height / 2),
        paint,
      );
      startX += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
