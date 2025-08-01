import 'package:flutter/material.dart';

class Track {
  final String id;
  final String title;
  final String description;
  final IconData icon;
  final Color color;
  final double progress;
  final int lessonsCount;
  final String duration;
  final bool isUnlocked;

  const Track({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
    required this.progress,
    required this.lessonsCount,
    required this.duration,
    required this.isUnlocked,
  });
}
