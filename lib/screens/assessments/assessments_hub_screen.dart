import 'package:flutter/material.dart';
import '../../config/app_theme.dart';
import '../../models/mock_data_service.dart';
import '../../models/ncct_models.dart';

/// CoLearn Assessments Hub Screen
/// Central assessment dashboard across all enrolled & available NCCT courses
class AssessmentsHubScreen extends StatefulWidget {
  const AssessmentsHubScreen({super.key});

  @override
  State<AssessmentsHubScreen> createState() => _AssessmentsHubScreenState();
}

class _AssessmentsHubScreenState extends State<AssessmentsHubScreen> {
  String _selectedFilter = 'All'; // 'All', 'Action Required', 'Passed'

  List<_QuizCardData> get _allQuizzes {
    final list = <_QuizCardData>[];
    for (final course in MockDataService.courses) {
      for (final module in course.modules) {
        if (module.quiz != null) {
          list.add(_QuizCardData(
            course: course,
            module: module,
            quiz: module.quiz!,
          ));
        }
      }
    }
    return list;
  }

  List<_QuizCardData> get _filteredQuizzes {
    final all = _allQuizzes;
    if (_selectedFilter == 'Passed') {
      return all.where((q) => q.quiz.isPassed).toList();
    } else if (_selectedFilter == 'Action Required') {
      return all.where((q) => !q.quiz.isPassed).toList();
    }
    return all;
  }

  void _startQuiz(BuildContext context, _QuizCardData data) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => _InteractiveQuizModal(
        quizData: data,
        onCompleted: () => setState(() {}),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final all = _allQuizzes;
    final passedCount = all.where((q) => q.quiz.isPassed).length;
    final totalCount = all.length;
    final pendingCount = totalCount - passedCount;

    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      appBar: AppBar(
        backgroundColor: AppTheme.surfaceWhite,
        title: const Text(
          'Assessments & Quizzes',
          style: TextStyle(
            fontFamily: 'Plus Jakarta Sans',
            fontSize: 19,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.3,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 40),
        children: [
          // ── Assessment Performance Summary Card ───────────────
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppTheme.pureBlack,
              borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Examination Performance',
                          style: TextStyle(
                            fontFamily: 'Plus Jakarta Sans',
                            fontSize: 12,
                            color: Colors.white.withValues(alpha: 0.6),
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          '88.5% Avg Score',
                          style: TextStyle(
                            fontFamily: 'Plus Jakarta Sans',
                            fontSize: 24,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                            letterSpacing: -0.5,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        '$passedCount / $totalCount Passed',
                        style: const TextStyle(
                          fontFamily: 'Plus Jakarta Sans',
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: totalCount > 0 ? passedCount / totalCount : 0,
                    backgroundColor: Colors.white.withValues(alpha: 0.15),
                    valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                    minHeight: 6,
                  ),
                ),
                const SizedBox(height: 14),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '$pendingCount assessment${pendingCount == 1 ? '' : 's'} remaining for module completion',
                      style: TextStyle(
                        fontFamily: 'Plus Jakarta Sans',
                        fontSize: 11,
                        color: Colors.white.withValues(alpha: 0.6),
                      ),
                    ),
                    const Icon(Icons.workspace_premium_rounded, size: 16, color: Colors.white),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // ── Filter Chips ──────────────────────────────────────
          SizedBox(
            height: 36,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: ['All', 'Action Required', 'Passed'].map((filter) {
                final active = _selectedFilter == filter;
                return GestureDetector(
                  onTap: () => setState(() => _selectedFilter = filter),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    margin: const EdgeInsets.only(right: 8),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: active ? AppTheme.pureBlack : AppTheme.surfaceWhite,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: active ? AppTheme.pureBlack : AppTheme.borderColor,
                      ),
                    ),
                    child: Text(
                      filter,
                      style: TextStyle(
                        fontFamily: 'Plus Jakarta Sans',
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: active ? Colors.white : AppTheme.textMuted,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 16),

          // ── Assessment Cards ──────────────────────────────────
          if (_filteredQuizzes.isEmpty)
            Container(
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                color: AppTheme.surfaceWhite,
                borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
                border: Border.all(color: AppTheme.borderColor),
              ),
              child: Column(
                children: const [
                  Icon(Icons.check_circle_outline_rounded, size: 40, color: AppTheme.textMuted),
                  SizedBox(height: 12),
                  Text(
                    'No pending assessments found',
                    style: TextStyle(
                      fontFamily: 'Plus Jakarta Sans',
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            )
          else
            ..._filteredQuizzes.map((data) {
              final quiz = data.quiz;
              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppTheme.surfaceWhite,
                  borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
                  border: Border.all(
                    color: quiz.isPassed ? AppTheme.borderColor : AppTheme.pureBlack.withValues(alpha: 0.3),
                    width: quiz.isPassed ? 1 : 1.2,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: AppTheme.surfaceMuted,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            data.course.shortCode,
                            style: const TextStyle(
                              fontFamily: 'Plus Jakarta Sans',
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              color: AppTheme.textPrimary,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Week ${data.module.weekNumber}',
                          style: const TextStyle(
                            fontFamily: 'Plus Jakarta Sans',
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.textMuted,
                          ),
                        ),
                        const Spacer(),
                        if (quiz.isPassed)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: AppTheme.successGreen.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.check_rounded, size: 12, color: AppTheme.successGreen),
                                const SizedBox(width: 4),
                                Text(
                                  'PASSED (${quiz.userScore ?? 90}%)',
                                  style: const TextStyle(
                                    fontFamily: 'Plus Jakarta Sans',
                                    fontSize: 9.5,
                                    fontWeight: FontWeight.w800,
                                    color: AppTheme.successGreen,
                                  ),
                                ),
                              ],
                            ),
                          )
                        else
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: AppTheme.pureBlack,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: const Text(
                              'READY TO TAKE',
                              style: TextStyle(
                                fontFamily: 'Plus Jakarta Sans',
                                fontSize: 9.5,
                                fontWeight: FontWeight.w800,
                                color: Colors.white,
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      quiz.title,
                      style: const TextStyle(
                        fontFamily: 'Plus Jakarta Sans',
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      data.course.title,
                      style: const TextStyle(
                        fontFamily: 'Plus Jakarta Sans',
                        fontSize: 12,
                        color: AppTheme.textMuted,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        const Icon(Icons.help_outline_rounded, size: 14, color: AppTheme.textMuted),
                        const SizedBox(width: 4),
                        Text(
                          '${quiz.questions.length} Questions',
                          style: const TextStyle(fontFamily: 'Plus Jakarta Sans', fontSize: 11.5, color: AppTheme.textMuted),
                        ),
                        const SizedBox(width: 14),
                        const Icon(Icons.timer_outlined, size: 14, color: AppTheme.textMuted),
                        const SizedBox(width: 4),
                        Text(
                          '${quiz.durationMinutes} Minutes',
                          style: const TextStyle(fontFamily: 'Plus Jakarta Sans', fontSize: 11.5, color: AppTheme.textMuted),
                        ),
                        const SizedBox(width: 14),
                        const Icon(Icons.grading_rounded, size: 14, color: AppTheme.textMuted),
                        const SizedBox(width: 4),
                        Text(
                          'Pass: ${quiz.passingScorePercent}%',
                          style: const TextStyle(fontFamily: 'Plus Jakarta Sans', fontSize: 11.5, color: AppTheme.textMuted),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    SizedBox(
                      width: double.infinity,
                      height: 40,
                      child: ElevatedButton(
                        onPressed: () => _startQuiz(context, data),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: quiz.isPassed ? AppTheme.surfaceMuted : AppTheme.pureBlack,
                          foregroundColor: quiz.isPassed ? AppTheme.pureBlack : Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                            side: quiz.isPassed ? const BorderSide(color: AppTheme.borderColor) : BorderSide.none,
                          ),
                        ),
                        child: Text(
                          quiz.isPassed ? 'Review Assessment' : 'Start Assessment',
                          style: const TextStyle(
                            fontFamily: 'Plus Jakarta Sans',
                            fontSize: 12.5,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }),
        ],
      ),
    );
  }
}

class _QuizCardData {
  final CourseModel course;
  final CourseModule module;
  final QuizModel quiz;

  _QuizCardData({
    required this.course,
    required this.module,
    required this.quiz,
  });
}

// ─── Interactive Quiz Modal ──────────────────────────────────────
class _InteractiveQuizModal extends StatefulWidget {
  final _QuizCardData quizData;
  final VoidCallback onCompleted;

  const _InteractiveQuizModal({
    required this.quizData,
    required this.onCompleted,
  });

  @override
  State<_InteractiveQuizModal> createState() => _InteractiveQuizModalState();
}

class _InteractiveQuizModalState extends State<_InteractiveQuizModal> {
  int _currentQuestionIndex = 0;
  bool _submitted = false;
  late List<int?> _selectedAnswers;

  @override
  void initState() {
    super.initState();
    _selectedAnswers = List<int?>.filled(widget.quizData.quiz.questions.length, null);
    // Pre-populate if quiz was already passed
    if (widget.quizData.quiz.isCompleted) {
      for (int i = 0; i < widget.quizData.quiz.questions.length; i++) {
        _selectedAnswers[i] = widget.quizData.quiz.questions[i].correctOptionIndex;
      }
      _submitted = true;
    }
  }

  void _submitQuiz() {
    int correctCount = 0;
    for (int i = 0; i < widget.quizData.quiz.questions.length; i++) {
      if (_selectedAnswers[i] == widget.quizData.quiz.questions[i].correctOptionIndex) {
        correctCount++;
      }
    }

    final scorePercent = (correctCount / widget.quizData.quiz.questions.length * 100).round();
    final passed = scorePercent >= widget.quizData.quiz.passingScorePercent;

    setState(() {
      _submitted = true;
      widget.quizData.quiz.isCompleted = true;
      widget.quizData.quiz.isPassed = passed;
      widget.quizData.quiz.userScore = scorePercent;
      if (passed) {
        widget.quizData.module.isCompleted = true;
        widget.quizData.course.recalculateProgress();
      }
    });

    widget.onCompleted();
  }

  @override
  Widget build(BuildContext context) {
    final quiz = widget.quizData.quiz;
    final questions = quiz.questions;
    final currentQ = questions[_currentQuestionIndex];

    return Container(
      height: MediaQuery.of(context).size.height * 0.88,
      decoration: const BoxDecoration(
        color: AppTheme.surfaceWhite,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        quiz.title,
                        style: const TextStyle(
                          fontFamily: 'Plus Jakarta Sans',
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: AppTheme.textPrimary,
                        ),
                      ),
                      Text(
                        'Question ${_currentQuestionIndex + 1} of ${questions.length}',
                        style: const TextStyle(
                          fontFamily: 'Plus Jakarta Sans',
                          fontSize: 11.5,
                          color: AppTheme.textMuted,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close_rounded),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: AppTheme.borderColor),

          // Question Body
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                Text(
                  currentQ.question,
                  style: const TextStyle(
                    fontFamily: 'Plus Jakarta Sans',
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.textPrimary,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 18),
                ...List.generate(currentQ.options.length, (optIdx) {
                  final opt = currentQ.options[optIdx];
                  final isSelected = _selectedAnswers[_currentQuestionIndex] == optIdx;
                  final isCorrect = optIdx == currentQ.correctOptionIndex;

                  Color borderCol = isSelected ? AppTheme.pureBlack : AppTheme.borderColor;
                  Color bgCol = isSelected ? AppTheme.pureBlack : AppTheme.surfaceWhite;
                  Color textCol = isSelected ? Colors.white : AppTheme.textPrimary;

                  if (_submitted) {
                    if (isCorrect) {
                      borderCol = AppTheme.successGreen;
                      bgCol = AppTheme.successGreen.withValues(alpha: 0.1);
                      textCol = AppTheme.successGreen;
                    } else if (isSelected) {
                      borderCol = AppTheme.errorRed;
                      bgCol = AppTheme.errorRed.withValues(alpha: 0.1);
                      textCol = AppTheme.errorRed;
                    } else {
                      borderCol = AppTheme.borderColor;
                      bgCol = AppTheme.surfaceWhite;
                      textCol = AppTheme.textMuted;
                    }
                  }

                  return GestureDetector(
                    onTap: _submitted
                        ? null
                        : () {
                            setState(() {
                              _selectedAnswers[_currentQuestionIndex] = optIdx;
                            });
                          },
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      decoration: BoxDecoration(
                        color: bgCol,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: borderCol, width: 1.2),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 24,
                            height: 24,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: isSelected && !_submitted ? Colors.white : AppTheme.textMuted,
                              ),
                            ),
                            child: Center(
                              child: Text(
                                String.fromCharCode(65 + optIdx),
                                style: TextStyle(
                                  fontFamily: 'Plus Jakarta Sans',
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                  color: textCol,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              opt,
                              style: TextStyle(
                                fontFamily: 'Plus Jakarta Sans',
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: textCol,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
                if (_submitted) ...[
                  const SizedBox(height: 14),
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: AppTheme.surfaceMuted,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: AppTheme.borderColor),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'NCCT Faculty Rationale',
                          style: TextStyle(
                            fontFamily: 'Plus Jakarta Sans',
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: AppTheme.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          currentQ.explanation,
                          style: const TextStyle(
                            fontFamily: 'Plus Jakarta Sans',
                            fontSize: 11.5,
                            color: AppTheme.textSecondary,
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),

          // Bottom Navigation
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
            child: Row(
              children: [
                if (_currentQuestionIndex > 0)
                  OutlinedButton(
                    onPressed: () {
                      setState(() => _currentQuestionIndex--);
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppTheme.pureBlack,
                      side: const BorderSide(color: AppTheme.borderColor),
                    ),
                    child: const Text('Previous'),
                  ),
                const Spacer(),
                if (_currentQuestionIndex < questions.length - 1)
                  ElevatedButton(
                    onPressed: () {
                      setState(() => _currentQuestionIndex++);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.pureBlack,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Next'),
                  )
                else if (!_submitted)
                  ElevatedButton(
                    onPressed: _selectedAnswers.contains(null) ? null : _submitQuiz,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.pureBlack,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Submit Assessment'),
                  )
                else
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.pureBlack,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Done'),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
