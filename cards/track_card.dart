import 'package:flutter/material.dart';
import '../../constants/app_constants.dart';

class TrackCard extends StatelessWidget {
  final Map<String, dynamic> track;
  final VoidCallback onTap;

  const TrackCard({
    super.key,
    required this.track,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isAccessible = track['isAccessible'] as bool;
    final progress = track['progress'] as double;
    final lessonsCount = track['lessonsCount'] as int;

    return Card(
      elevation: AppConstants.cardElevation,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppConstants.defaultBorderRadius),
        child: Container(
          padding: const EdgeInsets.all(AppConstants.defaultPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Track Icon and Lock Status
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: isAccessible
                          ? Theme.of(context).colorScheme.primary.withOpacity(0.1)
                          : Colors.grey.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Center(
                      child: Text(
                        track['icon'],
                        style: const TextStyle(fontSize: 20),
                      ),
                    ),
                  ),
                  if (!isAccessible)
                    Icon(
                      Icons.lock,
                      color: Colors.grey,
                      size: 20,
                    ),
                ],
              ),
              const SizedBox(height: 12),

              // Track Title
              Text(
                track['title'],
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: isAccessible
                      ? Theme.of(context).colorScheme.onSurface
                      : Colors.grey,
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),

              // Lessons Count
              Text(
                '$lessonsCount دروس',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: isAccessible
                      ? Theme.of(context).colorScheme.onSurface.withOpacity(0.7)
                      : Colors.grey,
                ),
              ),
              const Spacer(),

              // Progress Bar (only for accessible tracks)
              if (isAccessible) ...[
                LinearProgressIndicator(
                  value: progress,
                  backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.2),
                  valueColor: AlwaysStoppedAnimation<Color>(
                    Theme.of(context).colorScheme.primary,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '${(progress * 100).toInt()}% مكتمل',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ] else ...[
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'قريباً',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.grey,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
