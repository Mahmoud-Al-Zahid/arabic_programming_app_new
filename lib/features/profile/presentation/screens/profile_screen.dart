import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen>
    with TickerProviderStateMixin {
  late AnimationController _headerController;
  late AnimationController _statsController;
  late AnimationController _achievementsController;
  late List<AnimationController> _statControllers;

  @override
  void initState() {
    super.initState();
    
    _headerController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    
    _statsController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    
    _achievementsController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    // Individual stat controllers for staggered animation
    _statControllers = List.generate(4, (index) => 
      AnimationController(
        duration: const Duration(milliseconds: 800),
        vsync: this,
      )
    );

    _startAnimations();
  }

  void _startAnimations() {
    _headerController.forward();
    
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) {
        for (int i = 0; i < _statControllers.length; i++) {
          Future.delayed(Duration(milliseconds: 150 * i), () {
            if (mounted) {
              _statControllers[i].forward();
            }
          });
        }
      }
    });
    
    Future.delayed(const Duration(milliseconds: 800), () {
      if (mounted) {
        _achievementsController.forward();
      }
    });
  }

  @override
  void dispose() {
    _headerController.dispose();
    _statsController.dispose();
    _achievementsController.dispose();
    for (var controller in _statControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // Profile Header
            SliverToBoxAdapter(
              child: AnimatedBuilder(
                animation: _headerController,
                builder: (context, child) {
                  return Transform.translate(
                    offset: Offset(0, -50 * (1 - _headerController.value)),
                    child: Opacity(
                      opacity: _headerController.value,
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Theme.of(context).colorScheme.primary,
                              Theme.of(context).colorScheme.secondary,
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
                            // Profile Picture
                            Container(
                              width: 100,
                              height: 100,
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(50),
                                border: Border.all(
                                  color: Colors.white.withOpacity(0.3),
                                  width: 3,
                                ),
                              ),
                              child: const Icon(
                                Icons.person,
                                color: Colors.white,
                                size: 50,
                              ),
                            ),
                            const SizedBox(height: 16),
                            
                            // User Info
                            Text(
                              'أحمد محمد',
                              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'مطور Python متحمس',
                              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                color: Colors.white.withOpacity(0.9),
                              ),
                            ),
                            const SizedBox(height: 16),
                            
                            // Level Progress
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(25),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(
                                    Icons.star,
                                    color: Colors.amber,
                                    size: 20,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    'المستوى 5',
                                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            // Statistics Section
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'الإحصائيات',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    
                    // Stats Grid
                    GridView.count(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisCount: 2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: 1.2,
                      children: [
                        _buildAnimatedStatCard(
                          controller: _statControllers[0],
                          icon: Icons.emoji_events,
                          title: 'النقاط',
                          value: '1,250',
                          color: Colors.amber,
                          gradient: [Colors.amber, Colors.orange],
                        ),
                        _buildAnimatedStatCard(
                          controller: _statControllers[1],
                          icon: Icons.monetization_on,
                          title: 'العملات',
                          value: '850',
                          color: Colors.green,
                          gradient: [Colors.green, Colors.teal],
                        ),
                        _buildAnimatedStatCard(
                          controller: _statControllers[2],
                          icon: Icons.local_fire_department,
                          title: 'أيام متتالية',
                          value: '12',
                          color: Colors.red,
                          gradient: [Colors.red, Colors.pink],
                        ),
                        _buildAnimatedStatCard(
                          controller: _statControllers[3],
                          icon: Icons.school,
                          title: 'الدروس المكتملة',
                          value: '24',
                          color: Colors.blue,
                          gradient: [Colors.blue, Colors.purple],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // Achievements Section
            SliverToBoxAdapter(
              child: AnimatedBuilder(
                animation: _achievementsController,
                builder: (context, child) {
                  return Transform.translate(
                    offset: Offset(0, 30 * (1 - _achievementsController.value)),
                    child: Opacity(
                      opacity: _achievementsController.value,
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'الإنجازات',
                              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 16),
                            
                            // Achievement Cards
                            _buildAchievementCard(
                              icon: Icons.rocket_launch,
                              title: 'أول خطوة',
                              description: 'أكمل أول درس في Python',
                              isUnlocked: true,
                              color: Colors.blue,
                            ),
                            const SizedBox(height: 12),
                            _buildAchievementCard(
                              icon: Icons.local_fire_department,
                              title: 'متحمس للتعلم',
                              description: 'ادرس لمدة 7 أيام متتالية',
                              isUnlocked: true,
                              color: Colors.orange,
                            ),
                            const SizedBox(height: 12),
                            _buildAchievementCard(
                              icon: Icons.code,
                              title: 'مبرمج محترف',
                              description: 'أكمل 50 درس في Python',
                              isUnlocked: false,
                              color: Colors.grey,
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            // Bottom Spacing
            const SliverToBoxAdapter(
              child: SizedBox(height: 100),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnimatedStatCard({
    required AnimationController controller,
    required IconData icon,
    required String title,
    required String value,
    required Color color,
    required List<Color> gradient,
  }) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        return Transform.scale(
          scale: 0.8 + (0.2 * controller.value),
          child: Opacity(
            opacity: controller.value,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: gradient.map((c) => c.withOpacity(0.1)).toList(),
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: color.withOpacity(0.2),
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: color.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: gradient,
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: Icon(
                      icon,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    value,
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    title,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildAchievementCard({
    required IconData icon,
    required String title,
    required String description,
    required bool isUnlocked,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isUnlocked 
            ? color.withOpacity(0.1) 
            : Theme.of(context).colorScheme.surfaceVariant,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isUnlocked 
              ? color.withOpacity(0.3) 
              : Theme.of(context).colorScheme.outline.withOpacity(0.2),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: isUnlocked ? color : Colors.grey,
              borderRadius: BorderRadius.circular(25),
            ),
            child: Icon(
              icon,
              color: Colors.white,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: isUnlocked 
                        ? Theme.of(context).colorScheme.onSurface
                        : Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          if (isUnlocked)
            Icon(
              Icons.check_circle,
              color: color,
              size: 24,
            ),
        ],
      ),
    );
  }
}
