import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';

class CatalogModel {
  final String? catalogId;
  final String? title;
  final String? instructor;
  final String? category;
  final String? level;
  final String? subject;
  final String? language;
  final String? certificationStatus;
  final String? imageUrl;
  final double? rating;
  final bool? isFree;
  final String? content;
  final String? instructorInfo;
  List<String>? videoIds;
  Duration? estimatedTime;
  double? progress;
  DateTime? startDate;
  DateTime? endDate;

  CatalogModel({
    this.catalogId,
    this.title,
    this.instructor,
    this.category,
    this.level,
    this.subject,
    this.language,
    this.certificationStatus,
    this.imageUrl,
    this.rating,
    this.isFree,
    this.content,
    this.instructorInfo,
    this.videoIds,
    this.estimatedTime,
    this.progress = 0.0,
    this.startDate,
    this.endDate,
  });

  factory CatalogModel.fromFirestore(DocumentSnapshot doc) {
    final Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return CatalogModel(
      catalogId: data['catalogId'] ?? '',
      title: data['title'] ?? '',
      instructor: data['instructor'] ?? '',
      category: data['category'] ?? '',
      level: data['level'] ?? '',
      subject: data['subject'] ?? '',
      language: data['language'] ?? '',
      certificationStatus: data['certificationStatus'] ?? '',
      imageUrl: data['imageUrl'] ?? '',
      rating: (data['rating'] is int) ? (data['rating'] as int).toDouble() : (data['rating'] as double?) ?? 0.0,
      isFree: data['isFree'] ?? false,
      content: data['content'] ?? '',
      instructorInfo: data['instructorInfo'] ?? '',
      videoIds: data['videoIds'] != null ? List<String>.from(data['videoIds']) : null,
      estimatedTime: data['estimatedTime'] != null ? Duration(seconds: data['estimatedTime']) : null,
      progress: data['progress'] != null ? data['progress'].toDouble() : 0.0,
      startDate: data['startDate'] != null
          ? (data['startDate'] as Timestamp).toDate()
          : null,
      endDate: data['endDate'] != null
          ? (data['endDate'] as Timestamp).toDate()
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'catalogId': catalogId,
      'title': title,
      'instructor': instructor,
      'category': category,
      'level': level,
      'subject': subject,
      'language': language,
      'certificationStatus': certificationStatus,
      'imageUrl': imageUrl,
      'rating': rating,
      'isFree': isFree,
      'content': content,
      'instructorInfo': instructorInfo,
      'videoIds': videoIds,
      'estimatedTime': estimatedTime?.inSeconds,
      'progress': progress,
      'startDate': startDate?.toUtc(),
      'endDate': endDate?.toUtc(),
    };
  }

  factory CatalogModel.fromMap(Map<String, dynamic> map) {
    return CatalogModel(
      catalogId: map['catalogId'],
      title: map['title'],
      instructor: map['instructor'],
      category: map['category'],
      level: map['level'],
      subject: map['subject'],
      language: map['language'],
      certificationStatus: map['certificationStatus'],
      imageUrl: map['imageUrl'],
      rating: (map['rating'] is int) ? (map['rating'] as int).toDouble() : (map['rating'] as double?) ?? 0.0,
      isFree: map['isFree'],
      content: map['content'],
      instructorInfo: map['instructorInfo'],
      videoIds: map['videoIds'] != null ? List<String>.from(map['videoIds']) : null,
      estimatedTime: map['estimatedTime'] != null ? Duration(seconds: map['estimatedTime']) : null,
      progress: map['progress'] != null ? map['progress'].toDouble() : 0.0,
      startDate: (map['startDate'] as Timestamp?)?.toDate(),
      endDate: (map['endDate'] as Timestamp?)?.toDate(),
    );
  }

  String toJson() => json.encode(toMap());

  factory CatalogModel.fromJson(String source) => CatalogModel.fromMap(json.decode(source));

CatalogModel copyWith({
    String? catalogId,
    String? title,
    String? instructor,
    String? category,
    String? level,
    String? subject,
    String? language,
    String? certificationStatus,
    String? imageUrl,
    double? rating,
    bool? isFree,
    String? content,
    String? instructorInfo,
    List<String>? videoIds,
    Duration? estimatedTime,
    double? progress,
    DateTime? startDate,
    DateTime? endDate,
  }) {
    return CatalogModel(
      catalogId: catalogId ?? this.catalogId,
      title: title ?? this.title,
      instructor: instructor ?? this.instructor,
      category: category ?? this.category,
      level: level ?? this.level,
      subject: subject ?? this.subject,
      language: language ?? this.language,
      certificationStatus: certificationStatus ?? this.certificationStatus,
      imageUrl: imageUrl ?? this.imageUrl,
      rating: rating ?? this.rating,
      isFree: isFree ?? this.isFree,
      content: content ?? this.content,
      instructorInfo: instructorInfo ?? this.instructorInfo,
      videoIds: videoIds ?? this.videoIds,
      estimatedTime: estimatedTime ?? this.estimatedTime,
      progress: progress ?? this.progress,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
    );
  }
}
