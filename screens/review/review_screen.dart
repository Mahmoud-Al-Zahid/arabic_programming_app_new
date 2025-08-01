import 'package:flutter/material.dart';
import '../../constants/app_constants.dart';
import '../../constants/mock_data.dart';

class ReviewScreen extends StatefulWidget {
  const ReviewScreen({super.key});

  @override
  State<ReviewScreen> createState() => _ReviewScreenState();
}

class _ReviewScreenState extends State<ReviewScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // Mock data for completed lessons
  final List<Map<String, dynamic>> _recentLessons = [
    {
      'id': 'python_hello',
      'title': 'مرحباً بايثون',
      'track': 'Python - الثعبان الودود',
      'completedDate': 'منذ يومين',
      'score': 85,
      'coins': 50,
    },
    {
      'id': 'html_intro',
      'title': 'مقدمة في HTML',
      'track': 'HTML - هيكل الويب',
      'completedDate': 'منذ 3 أيام',
      'score': 92,
      'coins': 60,
    },
    {
      'id': 'logic_basics',
      'title': 'أساسيات المنطق',
      'track': 'التفكير المنطقي',
      'completedDate': 'منذ أسبوع',
      'score': 78,
      'coins': 40,
    },
  ];

  final List<Map<String, dynamic>> _favoriteLessons = [
    {
      'id': 'python_hello',
      'title': 'مرحباً بايثون',
      'track': 'Python - الثعبان الودود',
      'completedDate': 'منذ يومين',
      'score': 85,
      'coins': 50,
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Widget _buildLessonCard(Map<String, dynamic> lesson) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: AppConstants.cardElevation,
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.defaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Lesson Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        lesson['title'],
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        lesson['track'],
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: Icon(
                    _favoriteLessons.any((fav) => fav['id'] == lesson['id'])
                        ? Icons.favorite
                        : Icons.favorite_border,
                    color: _favoriteLessons.any((fav) => fav['id'] == lesson['id'])
                        ? Colors.red
                        : null,
                  ),
                  onPressed: () {
                    setState(() {
                      if (_favoriteLessons.any((fav) => fav['id'] == lesson['id'])) {
                        _favoriteLessons.removeWhere((fav) => fav['id'] == lesson['id']);
                      } else {
                        _favoriteLessons.add(lesson);
                      }
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 12),
            
            // Lesson Stats
            Row(
              children: [
                // Score
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: _getScoreColor(lesson['score']).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.grade,
                        size: 16,
                        color: _getScoreColor(lesson['score']),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${lesson['score']}%',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: _getScoreColor(lesson['score']),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                
                // Coins
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.secondary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.monetization_on,
                        size: 16,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '+${lesson['coins']}',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.secondary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                
                // Completion Date
                Text(
                  lesson['completedDate'],
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            
            // Action Button
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('مراجعة الدرس - قيد التطوير'),
                    ),
                  );
                },
                child: const Text('مراجعة'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getScoreColor(int score) {
    if (score >= 90) return Colors.green;
    if (score >= 70) return Colors.blue;
    if (score >= 50) return Colors.orange;
    return Colors.red;
  }

  Widget _buildFilterChips() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: AppConstants.defaultPadding),
      child: Row(
        children: [
          FilterChip(
            label: const Text('الكل'),
            selected: true,
            onSelected: (selected) {},
          ),
          const SizedBox(width: 8),
          FilterChip(
            label: const Text('Python'),
            selected: false,
            onSelected: (selected) {},
          ),
          const SizedBox(width: 8),
          FilterChip(
            label: const Text('HTML'),
            selected: false,
            onSelected: (selected) {},
          ),
          const SizedBox(width: 8),
          FilterChip(
            label: const Text('90%+'),
            selected: false,
            onSelected: (selected) {},
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('المراجعة'),
        centerTitle: true,
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'الأخيرة'),
            Tab(text: 'جميع الدروس'),
            Tab(text: 'المفضلة'),
          ],
        ),
      ),
      body: Column(
        children: [
          const SizedBox(height: 16),
          _buildFilterChips(),
          const SizedBox(height: 16),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                // Recently Completed Tab
                _recentLessons.isEmpty
                    ? _buildEmptyState('لا توجد دروس مكتملة حديثاً')
                    : ListView.builder(
                        padding: const EdgeInsets.all(AppConstants.defaultPadding),
                        itemCount: _recentLessons.length,
                        itemBuilder: (context, index) {
                          return _buildLessonCard(_recentLessons[index]);
                        },
                      ),
                
                // All Lessons Tab
                ListView.builder(
                  padding: const EdgeInsets.all(AppConstants.defaultPadding),
                  itemCount: _recentLessons.length,
                  itemBuilder: (context, index) {
                    return _buildLessonCard(_recentLessons[index]);
                  },
                ),
                
                // Favorites Tab
                _favoriteLessons.isEmpty
                    ? _buildEmptyState('لا توجد دروس مفضلة')
                    : ListView.builder(
                        padding: const EdgeInsets.all(AppConstants.defaultPadding),
                        itemCount: _favoriteLessons.length,
                        itemBuilder: (context, index) {
                          return _buildLessonCard(_favoriteLessons[index]);
                        },
                      ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.book_outlined,
            size: 64,
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          Text(
            message,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            'ابدأ بحل بعض الدروس لتظهر هنا',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
