import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/providers/data_providers.dart';
import '../../../../core/constants/app_constants.dart';

class CourseViewScreen extends ConsumerStatefulWidget {
  final String trackId;

  const CourseViewScreen({super.key, required this.trackId});

  @override
  ConsumerState<CourseViewScreen> createState() => _CourseViewScreenState();
}

class _CourseViewScreenState extends ConsumerState<CourseViewScreen>
    with TickerProviderStateMixin {
  late AnimationController _headerController;
  late AnimationController _pathController;
  late List<AnimationController> _lessonControllers;
  late Animation<double> _headerAnimation;

  @override
  void initState() {
    super.initState();
    
    _headerController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _pathController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _headerAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _headerController,
      curve: Curves.easeOutCubic,
    ));

    _lessonControllers = [];

    // Start animations
    _headerController.forward();
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        _pathController.forward();
      }
    });
  }

  void _initializeLessonControllers(int lessonCount) {
    // Dispose existing controllers
    for (var controller in _lessonControllers) {
      controller.dispose();
    }
    
    // Create new controllers
    _lessonControllers = List.generate(
      lessonCount,
      (index) => AnimationController(
        duration: const Duration(milliseconds: 600),
        vsync: this,
      ),
    );
    
    _startLessonAnimations();
  }

  void _startLessonAnimations() {
    for (int i = 0; i < _lessonControllers.length; i++) {
      Future.delayed(Duration(milliseconds: 200 * i), () {
        if (mounted && i < _lessonControllers.length) {
          _lessonControllers[i].forward();
        }
      });
    }
  }

  @override
  void dispose() {
    _headerController.dispose();
    _pathController.dispose();
    for (var controller in _lessonControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final trackAsync = ref.watch(trackProvider(widget.trackId));
    final lessonsAsync = ref.watch(lessonsProvider(widget.trackId));

    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(trackProvider(widget.trackId));
            ref.invalidate(lessonsProvider(widget.trackId));
          },
          child: trackAsync.when(
            data: (track) {
              if (track == null) {
                return const Center(child: Text('المسار غير موجود'));
              }
              
              return lessonsAsync.when(
                data: (lessons) {
                  // Initialize lesson controllers when data is loaded
                  if (_lessonControllers.length != lessons.length) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      _initializeLessonControllers(lessons.length);
                    });
                  }
                  
                  return CustomScrollView(
                    slivers: [
                      // Animated Header
                      SliverToBoxAdapter(
                        child: AnimatedBuilder(
                          animation: _headerAnimation,
                          builder: (context, child) {
                            return Transform.translate(
                              offset: Offset(0, -50 * (1 - _headerAnimation.value)),
                              child: Opacity(
                                opacity: _headerAnimation.value,
                                child: Container(
                                  height: 120,
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        track.color,
                                        track.color.withOpacity(0.8),
                                      ],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 20,
                                      vertical: 16,
                                    ),
                                    child: Row(
                                      children: [
                                        // Back Button
                                        GestureDetector(
                                          onTap: () => context.pop(),
                                          child: Container(
                                            padding: const EdgeInsets.all(8),
                                            decoration: BoxDecoration(
                                              color: Colors.white.withOpacity(0.2),
                                              borderRadius: BorderRadius.circular(12),
                                            ),
                                            child: const Icon(
                                              Icons.arrow_back_ios,
                                              color: Colors.white,
                                              size: 20,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 16),
                                        
                                        // Track Icon and Title
                                        Row(
                                          children: [
                                            Container(
                                              width: 40,
                                              height: 40,
                                              decoration: BoxDecoration(
                                                color: Colors.white.withOpacity(0.2),
                                                borderRadius: BorderRadius.circular(20),
                                              ),
                                              child: Icon(
                                                track.icon,
                                                color: Colors.white,
                                                size: 24,
                                              ),
                                            ),
                                            const SizedBox(width: 12),
                                            Text(
                                              track.title.toUpperCase(),
                                              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                                letterSpacing: 1.2,
                                              ),
                                            ),
                                          ],
                                        ),
                                        
                                        const Spacer(),
                                        
                                        // Progress Info
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 12,
                                            vertical: 6,
                                          ),
                                          decoration: BoxDecoration(
                                            color: Colors.white.withOpacity(0.2),
                                            borderRadius: BorderRadius.circular(12),
                                          ),
                                          child: Text(
                                            '${(track.progress * 100).toInt()}%',
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),

                      // Welcome Message
                      SliverToBoxAdapter(
                        child: Container(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'مرحباً بك في عالم ${track.title}',
                                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                track.description,
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      // Learning Path
                      SliverToBoxAdapter(
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Column(
                            children: [
                              for (int index = 0; index < lessons.length; index++)
                                if (index < _lessonControllers.length)
                                  AnimatedBuilder(
                                    animation: _lessonControllers[index],
                                    builder: (context, child) {
                                      return Transform.scale(
                                        scale: 0.8 + (0.2 * _lessonControllers[index].value),
                                        child: Opacity(
                                          opacity: _lessonControllers[index].value,
                                          child: _buildLessonCard(
                                            lessons[index],
                                            index,
                                            lessons.length,
                                          ),
                                        ),
                                      );
                                    },
                                  )
                                else
                                  _buildLessonCard(lessons[index], index, lessons.length),
                            ],
                          ),
                        ),
                      ),

                      // Bottom Spacing
                      const SliverToBoxAdapter(
                        child: SizedBox(height: 100),
                      ),
                    ],
                  );
                },
                loading: () => const Center(
                  child: Padding(
                    padding: EdgeInsets.all(50),
                    child: CircularProgressIndicator(),
                  ),
                ),
                error: (error, stack) => Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.error_outline, size: 64, color: Colors.red),
                      const SizedBox(height: 16),
                      Text('خطأ في تحميل الدروس: $error'),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                          ref.invalidate(lessonsProvider(widget.trackId));
                        },
                        child: const Text('إعادة المحاولة'),
                      ),
                    ],
                  ),
                ),
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, stack) => Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 64, color: Colors.red),
                  const SizedBox(height: 16),
                  Text('خطأ في تحميل المسار: $error'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      ref.invalidate(trackProvider(widget.trackId));
                    },
                    child: const Text('إعادة المحاولة'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLessonCard(lesson, int index, int totalLessons) {
    final isEven = index % 2 == 0;
    final colors = AppConstants.trackColors;
    final icons = [
      Icons.rocket_launch,
      Icons.storage,
      Icons.computer,
      Icons.functions,
      Icons.loop,
      Icons.emoji_events,
    ];

    final cardColor = colors[index % colors.length];
    final cardIcon = icons[index % icons.length];

    return Container(
      margin: const EdgeInsets.only(bottom: 30),
      child: Row(
        children: [
          if (!isEven) const Spacer(),
          
          // Lesson Card
          Expanded(
            flex: 2,
            child: GestureDetector(
              onTap: lesson.isUnlocked 
                  ? () => context.go('/lesson/${lesson.id}')
                  : null,
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: lesson.isUnlocked ? cardColor : Colors.grey,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: (lesson.isUnlocked ? cardColor : Colors.grey).withOpacity(0.3),
                      blurRadius: 15,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Icon and Status
                    Row(
                      children: [
                        Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(25),
                          ),
                          child: Icon(
                            lesson.isCompleted ? Icons.check_circle : cardIcon,
                            color: Colors.white,
                            size: 24,
                          ),
                        ),
                        const Spacer(),
                        if (!lesson.isUnlocked)
                          const Icon(Icons.lock, color: Colors.white, size: 20),
                      ],
                    ),
                    const SizedBox(height: 12),
                    
                    // Title
                    Text(
                      '${index + 1}. ${lesson.title}',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    
                    // Description
                    Text(
                      lesson.description,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.white.withOpacity(0.9),
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 12),
                    
                    // Duration and Status
                    Row(
                      children: [
                        Icon(Icons.access_time, color: Colors.white, size: 16),
                        const SizedBox(width: 4),
                        Text(
                          '${lesson.duration} دقيقة',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                          ),
                        ),
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            lesson.isCompleted 
                                ? 'مكتمل' 
                                : lesson.isUnlocked 
                                    ? 'متاح' 
                                    : 'مقفل',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          
          if (isEven) const Spacer(),
          
          // Connection Line (except for last item)
          if (index < totalLessons - 1)
            Container(
              width: 2,
              height: 50,
              margin: const EdgeInsets.symmetric(horizontal: 20),
              child: CustomPaint(
                painter: DottedLinePainter(
                  color: Theme.of(context).colorScheme.outline.withOpacity(0.5),
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

    const dashHeight = 5.0;
    const dashSpace = 3.0;
    double startY = 0;

    while (startY < size.height) {
      canvas.drawLine(
        Offset(size.width / 2, startY),
        Offset(size.width / 2, startY + dashHeight),
        paint,
      );
      startY += dashHeight + dashSpace;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
