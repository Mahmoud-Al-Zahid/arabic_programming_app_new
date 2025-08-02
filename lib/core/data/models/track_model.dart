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
  final String? imageUrl;

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
    this.imageUrl,
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
    String? imageUrl,
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
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'progress': progress,
      'lessonsCount': lessonsCount,
      'duration': duration,
      'isUnlocked': isUnlocked,
      'imageUrl': imageUrl,
    };
  }

  factory Track.fromJson(Map<String, dynamic> json) {
    return Track(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      icon: Icons.code, // Default icon
      color: const Color(0xFF4A90E2), // Default color
      progress: json['progress']?.toDouble() ?? 0.0,
      lessonsCount: json['lessonsCount'] ?? 0,
      duration: json['duration'] ?? '',
      isUnlocked: json['isUnlocked'] ?? false,
      imageUrl: json['imageUrl'],
    );
  }

  @override
  String toString() {
    return 'Track(id: $id, title: $title, progress: $progress)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Track && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
