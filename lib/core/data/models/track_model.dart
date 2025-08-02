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
  final String? backgroundImage;

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
    this.backgroundImage,
  });

  Track copyWith({
    String? id,
    String? title,
    String? description,
    IconData? icon,
    Color? color,
    double? progress,
    int? lessonsCount,
    String? duration,
    bool? isUnlocked,
    String? backgroundImage,
  }) {
    return Track(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      icon: icon ?? this.icon,
      color: color ?? this.color,
      progress: progress ?? this.progress,
      lessonsCount: lessonsCount ?? this.lessonsCount,
      duration: duration ?? this.duration,
      isUnlocked: isUnlocked ?? this.isUnlocked,
      backgroundImage: backgroundImage ?? this.backgroundImage,
    );
  }
}
