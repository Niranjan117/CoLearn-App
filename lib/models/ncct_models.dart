import 'package:flutter/material.dart';

/// ─────────────────────────────────────────────────────────────
/// COURSE & MODULE PROGRESS MODELS (Coursera-style)
/// ─────────────────────────────────────────────────────────────

class CourseModel {
  final String id;
  final String title;
  final String shortCode;
  final String code;
  final String category;
  final String institute;
  final String duration;
  final int totalModules;
  final String totalHours;
  final int credits;
  final double rating;
  final int enrolledLearners;
  bool isEnrolled;
  String? enrolledBatch;
  double progressPercent;
  final bool featured;
  final String bannerImageUrl;
  final String description;
  final List<CourseModule> modules;
  final String facultyName;
  final String facultyTitle;
  final String sponsorship;
  final String eligibility;

  CourseModel({
    required this.id,
    required this.title,
    required this.shortCode,
    required this.code,
    required this.category,
    required this.institute,
    required this.duration,
    required this.totalModules,
    required this.totalHours,
    required this.credits,
    required this.rating,
    required this.enrolledLearners,
    this.isEnrolled = false,
    this.enrolledBatch,
    this.progressPercent = 0.0,
    this.featured = false,
    required this.bannerImageUrl,
    required this.description,
    required this.modules,
    required this.facultyName,
    required this.facultyTitle,
    required this.sponsorship,
    required this.eligibility,
  });

  int get completedLessonsCount {
    int count = 0;
    for (final m in modules) {
      for (final l in m.lessons) {
        if (l.isCompleted) count++;
      }
    }
    return count;
  }

  int get totalLessonsCount {
    int count = 0;
    for (final m in modules) {
      count += m.lessons.length;
    }
    return count;
  }

  void recalculateProgress() {
    final total = totalLessonsCount;
    if (total == 0) {
      progressPercent = 0.0;
    } else {
      progressPercent = (completedLessonsCount / total).clamp(0.0, 1.0);
    }
  }
}

class CourseModule {
  final String id;
  final int weekNumber;
  final String title;
  final String duration;
  final List<LessonModel> lessons;
  final QuizModel? quiz;
  bool isCompleted;

  CourseModule({
    required this.id,
    required this.weekNumber,
    required this.title,
    required this.duration,
    required this.lessons,
    this.quiz,
    this.isCompleted = false,
  });
}

class LessonModel {
  final String id;
  final String title;
  final int durationMinutes;
  final String type; // 'video', 'reading', 'assessment'
  final String youtubeVideoId;
  final String youtubeVideoUrl;
  bool isCompleted;
  final String summary;
  final String transcript;
  final List<LessonChapter> chapters;
  final String downloadableNotes;

  LessonModel({
    required this.id,
    required this.title,
    required this.durationMinutes,
    this.type = 'video',
    required this.youtubeVideoId,
    required this.youtubeVideoUrl,
    this.isCompleted = false,
    required this.summary,
    required this.transcript,
    required this.chapters,
    required this.downloadableNotes,
  });
}

class LessonChapter {
  final String timestamp;
  final String title;

  LessonChapter({required this.timestamp, required this.title});
}

/// ─────────────────────────────────────────────────────────────
/// QUIZZES & ASSESSMENTS
/// ─────────────────────────────────────────────────────────────

class QuizModel {
  final String id;
  final String courseId;
  final String title;
  final int durationMinutes;
  final int passingScorePercent;
  final List<QuizQuestion> questions;
  int? userScore;
  bool isPassed;
  bool isCompleted;

  QuizModel({
    required this.id,
    required this.courseId,
    required this.title,
    required this.durationMinutes,
    required this.passingScorePercent,
    required this.questions,
    this.userScore,
    this.isPassed = false,
    this.isCompleted = false,
  });
}

class QuizQuestion {
  final String id;
  final String question;
  final List<String> options;
  final int correctOptionIndex;
  final String explanation;
  int? selectedOptionIndex;

  QuizQuestion({
    required this.id,
    required this.question,
    required this.options,
    required this.correctOptionIndex,
    required this.explanation,
    this.selectedOptionIndex,
  });

  bool get isCorrect => selectedOptionIndex == correctOptionIndex;
}

/// ─────────────────────────────────────────────────────────────
/// CERTIFICATES & VERIFICATION
/// ─────────────────────────────────────────────────────────────

class CertificateModel {
  final String id;
  final String certificateNumber;
  final String recipientName;
  final String rollNumber;
  final String courseTitle;
  final String courseCode;
  final String institute;
  final String issueDate;
  final String grade;
  final String qrPayload;
  final String digitalHash;
  final bool isVerified;
  final String councilSealText;
  final String directorGeneral;
  final String instituteDirector;
  final List<String> skills;

  CertificateModel({
    required this.id,
    required this.certificateNumber,
    required this.recipientName,
    required this.rollNumber,
    required this.courseTitle,
    required this.courseCode,
    required this.institute,
    required this.issueDate,
    required this.grade,
    required this.qrPayload,
    required this.digitalHash,
    this.isVerified = true,
    required this.councilSealText,
    required this.directorGeneral,
    required this.instituteDirector,
    required this.skills,
  });
}

/// ─────────────────────────────────────────────────────────────
/// LEARNER PROFILE & SKILLS/BADGES
/// ─────────────────────────────────────────────────────────────

class LearnerProfileModel {
  final String id;
  final String fullName;
  final String rollNumber;
  final String email;
  final String phone;
  final String currentInstitute;
  final String activeProgramme;
  final String enrolledBatch;
  final double attendanceRate;
  final String gpa;
  final int totalCreditsEarned;
  final int requiredCredits;
  final String academicRank;
  final List<SkillBadge> earnedBadges;
  final int certificatesCount;
  final int jobApplicationsCount;

  LearnerProfileModel({
    required this.id,
    required this.fullName,
    required this.rollNumber,
    required this.email,
    required this.phone,
    required this.currentInstitute,
    required this.activeProgramme,
    required this.enrolledBatch,
    required this.attendanceRate,
    required this.gpa,
    required this.totalCreditsEarned,
    required this.requiredCredits,
    required this.academicRank,
    required this.earnedBadges,
    required this.certificatesCount,
    required this.jobApplicationsCount,
  });

  String get initials {
    final parts = fullName.split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return fullName.isNotEmpty ? fullName[0].toUpperCase() : 'CL';
  }
}

class SkillBadge {
  final String id;
  final String name;
  final String tier; // Platinum, Gold, Silver
  final String category;
  final String description;
  final String dateAwarded;
  final IconData icon;

  SkillBadge({
    required this.id,
    required this.name,
    required this.tier,
    required this.category,
    required this.description,
    required this.dateAwarded,
    required this.icon,
  });
}

/// ─────────────────────────────────────────────────────────────
/// ATTENDANCE
/// ─────────────────────────────────────────────────────────────

class AttendanceRecord {
  final String id;
  final String date;
  final String courseName;
  final String sessionTopic;
  final String faculty;
  final String status; // Present, Absent, Late, FieldVisit
  final String checkInTime;
  final bool geoVerified;

  AttendanceRecord({
    required this.id,
    required this.date,
    required this.courseName,
    required this.sessionTopic,
    required this.faculty,
    required this.status,
    required this.checkInTime,
    required this.geoVerified,
  });
}

class AttendanceSummary {
  final double percentage;
  final double requiredThreshold;
  final int totalSessions;
  final int attended;
  final int absent;
  final int fieldVisits;

  AttendanceSummary({
    required this.percentage,
    required this.requiredThreshold,
    required this.totalSessions,
    required this.attended,
    required this.absent,
    required this.fieldVisits,
  });
}

/// ─────────────────────────────────────────────────────────────
/// CAREER & COOPERATIVE JOBS
/// ─────────────────────────────────────────────────────────────

class JobPostingModel {
  final String id;
  final String title;
  final String organization;
  final String logoLetter;
  final String location;
  final String salaryRange;
  final String jobType;
  final String deadline;
  final String description;
  final List<String> qualifications;
  final List<String> skillsRequired;
  bool isApplied;
  String? applicationStatus;

  JobPostingModel({
    required this.id,
    required this.title,
    required this.organization,
    required this.logoLetter,
    required this.location,
    required this.salaryRange,
    required this.jobType,
    required this.deadline,
    required this.description,
    required this.qualifications,
    required this.skillsRequired,
    this.isApplied = false,
    this.applicationStatus,
  });
}

/// ─────────────────────────────────────────────────────────────
/// NOTIFICATIONS
/// ─────────────────────────────────────────────────────────────

class NotificationItem {
  final String id;
  final String title;
  final String body;
  final String category; // 'Academic', 'Ministry', 'Assessment', 'Placement'
  final String timeAgo;
  bool isRead;

  NotificationItem({
    required this.id,
    required this.title,
    required this.body,
    required this.category,
    required this.timeAgo,
    this.isRead = false,
  });
}

class BulletinItem {
  final String id;
  final String title;
  final String category;
  final String source;
  final String date;
  final String summary;
  final String imageUrl;

  BulletinItem({
    required this.id,
    required this.title,
    required this.category,
    required this.source,
    required this.date,
    required this.summary,
    required this.imageUrl,
  });
}

/// ─────────────────────────────────────────────────────────────
/// 360° & VR LEARNING (Factory/Machine Demos & WebXR)
/// ─────────────────────────────────────────────────────────────

class VRDemoModel {
  final String id;
  final String title;
  final String sector;
  final String facilityName;
  final String location;
  final String duration;
  final String description;
  final String panoramaImageUrl;
  final String webXRUrl;
  final List<VRHotspot> hotspots;
  final List<MachineSpec> keyMachinery;

  VRDemoModel({
    required this.id,
    required this.title,
    required this.sector,
    required this.facilityName,
    required this.location,
    required this.duration,
    required this.description,
    required this.panoramaImageUrl,
    required this.webXRUrl,
    required this.hotspots,
    required this.keyMachinery,
  });
}

class VRHotspot {
  final String title;
  final double azimuthDegrees; // 0 to 360
  final double elevationDegrees; // -90 to +90
  final String description;
  final String diagnosticMetric;
  final String alertLevel; // 'Normal', 'Optimal', 'Notice'

  VRHotspot({
    required this.title,
    required this.azimuthDegrees,
    required this.elevationDegrees,
    required this.description,
    required this.diagnosticMetric,
    this.alertLevel = 'Optimal',
  });
}

class MachineSpec {
  final String name;
  final String parameter;
  final String value;
  final String standardOperatingProcedure;

  MachineSpec({
    required this.name,
    required this.parameter,
    required this.value,
    required this.standardOperatingProcedure,
  });
}
