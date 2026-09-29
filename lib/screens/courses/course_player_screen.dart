import 'package:flutter/material.dart';
import '../../config/app_theme.dart';
import '../../models/ncct_models.dart';

class CoursePlayerScreen extends StatefulWidget {
  const CoursePlayerScreen({super.key});

  @override
  State<CoursePlayerScreen> createState() => _CoursePlayerScreenState();
}

class _CoursePlayerScreenState extends State<CoursePlayerScreen> {
  CourseModel? _course;
  int _selectedModuleIndex = 0;
  LessonModel? _activeLesson;
  bool _quizMode = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_course == null) {
      _course = ModalRoute.of(context)?.settings.arguments as CourseModel?;
      if (_course != null && _course!.modules.isNotEmpty) {
        // Find first incomplete module
        for (int i = 0; i < _course!.modules.length; i++) {
          if (!_course!.modules[i].isCompleted) {
            _selectedModuleIndex = i;
            break;
          }
        }
        final mod = _course!.modules[_selectedModuleIndex];
        _activeLesson = mod.lessons.firstWhere(
          (l) => !l.isCompleted,
          orElse: () => mod.lessons.first,
        );
      }
    }
  }

  void _completeLesson(LessonModel lesson) {
    setState(() {
      lesson.isCompleted = true;
      _course!.recalculateProgress();
    });
    // Move to next lesson
    final mod = _course!.modules[_selectedModuleIndex];
    final idx = mod.lessons.indexOf(lesson);
    if (idx + 1 < mod.lessons.length) {
      setState(() => _activeLesson = mod.lessons[idx + 1]);
    } else if (mod.quiz != null) {
      setState(() => _quizMode = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_course == null) {
      return const Scaffold(
        body: Center(child: Text('No course selected')),
      );
    }

    final module = _course!.modules[_selectedModuleIndex];

    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      body: SafeArea(
        child: Column(
          children: [
            // ── Top Bar ───────────────────────────────────────
            Container(
              color: AppTheme.pureBlack,
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 14),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 20),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _course!.shortCode,
                          style: const TextStyle(
                            fontFamily: 'Plus Jakarta Sans',
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: Colors.white54,
                            letterSpacing: 1,
                          ),
                        ),
                        Text(
                          _course!.title,
                          style: const TextStyle(
                            fontFamily: 'Plus Jakarta Sans',
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  // Progress
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '${(_course!.progressPercent * 100).round()}%',
                        style: const TextStyle(
                          fontFamily: 'Plus Jakarta Sans',
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        'complete',
                        style: TextStyle(
                          fontFamily: 'Plus Jakarta Sans',
                          fontSize: 10,
                          color: Colors.white.withValues(alpha: 0.5),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Progress Bar
            LinearProgressIndicator(
              value: _course!.progressPercent,
              backgroundColor: AppTheme.greyDark,
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
              minHeight: 3,
            ),

            Expanded(
              child: _quizMode && module.quiz != null
                  ? _QuizView(
                      quiz: module.quiz!,
                      onComplete: () {
                        setState(() {
                          module.isCompleted = true;
                          _quizMode = false;
                          // Move to next module if available
                          if (_selectedModuleIndex + 1 < _course!.modules.length) {
                            _selectedModuleIndex++;
                            final nextMod = _course!.modules[_selectedModuleIndex];
                            _activeLesson = nextMod.lessons.isNotEmpty ? nextMod.lessons.first : null;
                          }
                        });
                      },
                    )
                  : Row(
                      children: [
                        // ── Sidebar ─────────────────────────────
                        Container(
                          width: 220,
                          color: AppTheme.surfaceWhite,
                          child: ListView(
                            children: [
                              // Course module list
                              ...List.generate(_course!.modules.length, (mi) {
                                final m = _course!.modules[mi];
                                final isSelected = mi == _selectedModuleIndex;
                                return Theme(
                                  data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                                  child: ExpansionTile(
                                    initiallyExpanded: isSelected,
                                    tilePadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
                                    leading: Container(
                                      width: 24,
                                      height: 24,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: m.isCompleted ? AppTheme.pureBlack : isSelected ? AppTheme.greyDark : AppTheme.greySubtle,
                                      ),
                                      child: Icon(
                                        m.isCompleted ? Icons.check_rounded : Icons.lock_open_rounded,
                                        size: 13,
                                        color: m.isCompleted || isSelected ? Colors.white : AppTheme.greyLight,
                                      ),
                                    ),
                                    title: Text(
                                      'Wk ${m.weekNumber}: ${m.title}',
                                      style: TextStyle(
                                        fontFamily: 'Plus Jakarta Sans',
                                        fontSize: 11.5,
                                        fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                                        color: AppTheme.textPrimary,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    subtitle: Text(
                                      m.duration,
                                      style: const TextStyle(
                                        fontFamily: 'Plus Jakarta Sans',
                                        fontSize: 10,
                                        color: AppTheme.textHint,
                                      ),
                                    ),
                                    children: [
                                      ...m.lessons.map((lesson) {
                                        final isActive = lesson == _activeLesson;
                                        return GestureDetector(
                                          onTap: () => setState(() {
                                            _selectedModuleIndex = mi;
                                            _activeLesson = lesson;
                                            _quizMode = false;
                                          }),
                                          child: Container(
                                            color: isActive ? AppTheme.greySubtle : Colors.transparent,
                                            padding: const EdgeInsets.fromLTRB(44, 8, 12, 8),
                                            child: Row(
                                              children: [
                                                Icon(
                                                  lesson.isCompleted
                                                      ? Icons.check_circle_rounded
                                                      : isActive
                                                          ? Icons.play_circle_rounded
                                                          : Icons.play_circle_outline_rounded,
                                                  size: 16,
                                                  color: lesson.isCompleted
                                                      ? AppTheme.successGreen
                                                      : isActive
                                                          ? AppTheme.pureBlack
                                                          : AppTheme.greyLight,
                                                ),
                                                const SizedBox(width: 8),
                                                Expanded(
                                                  child: Text(
                                                    lesson.title,
                                                    style: TextStyle(
                                                      fontFamily: 'Plus Jakarta Sans',
                                                      fontSize: 11,
                                                      fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
                                                      color: isActive ? AppTheme.textPrimary : AppTheme.textSecondary,
                                                    ),
                                                    maxLines: 2,
                                                    overflow: TextOverflow.ellipsis,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      }),
                                      if (m.quiz != null)
                                        GestureDetector(
                                          onTap: () => setState(() {
                                            _selectedModuleIndex = mi;
                                            _quizMode = true;
                                          }),
                                          child: Container(
                                            padding: const EdgeInsets.fromLTRB(44, 8, 12, 8),
                                            child: Row(
                                              children: [
                                                Icon(
                                                  m.quiz!.isCompleted ? Icons.check_circle_rounded : Icons.quiz_rounded,
                                                  size: 16,
                                                  color: m.quiz!.isCompleted ? AppTheme.successGreen : AppTheme.pureBlack,
                                                ),
                                                const SizedBox(width: 8),
                                                Text(
                                                  m.quiz!.title,
                                                  style: const TextStyle(
                                                    fontFamily: 'Plus Jakarta Sans',
                                                    fontSize: 11,
                                                    fontWeight: FontWeight.w600,
                                                    color: AppTheme.textPrimary,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                );
                              }),
                            ],
                          ),
                        ),

                        // ── Main content ─────────────────────────
                        Expanded(
                          child: _activeLesson == null
                              ? const Center(child: Text('Select a lesson'))
                              : _LessonView(
                                  lesson: _activeLesson!,
                                  onComplete: () => _completeLesson(_activeLesson!),
                                ),
                        ),
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Lesson View ──────────────────────────────────────────────
class _LessonView extends StatelessWidget {
  final LessonModel lesson;
  final VoidCallback onComplete;
  const _LessonView({required this.lesson, required this.onComplete});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        // YouTube Embed card
        Container(
          height: 200,
          decoration: BoxDecoration(
            color: AppTheme.pureBlack,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Thumbnail-style placeholder
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  'https://img.youtube.com/vi/${lesson.youtubeVideoId}/mqdefault.jpg',
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: 200,
                  errorBuilder: (_, __, ___) => Container(
                    color: AppTheme.greyDark,
                    child: const Icon(Icons.movie_outlined, size: 48, color: Colors.white30),
                  ),
                ),
              ),
              // Play button overlay
              GestureDetector(
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Opening: ${lesson.youtubeVideoUrl}'),
                      backgroundColor: AppTheme.pureBlack,
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                },
                child: Container(
                  width: 58,
                  height: 58,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.3), blurRadius: 16)],
                  ),
                  child: const Icon(Icons.play_arrow_rounded, size: 32, color: AppTheme.pureBlack),
                ),
              ),
              // Duration badge
              Positioned(
                bottom: 10,
                right: 10,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.75),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Text(
                    '${lesson.durationMinutes} min',
                    style: const TextStyle(
                      fontFamily: 'Plus Jakarta Sans',
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 18),
        Text(
          lesson.title,
          style: const TextStyle(
            fontFamily: 'Plus Jakarta Sans',
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: AppTheme.textPrimary,
            letterSpacing: -0.3,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          lesson.summary,
          style: const TextStyle(
            fontFamily: 'Plus Jakarta Sans',
            fontSize: 13.5,
            color: AppTheme.textSecondary,
            height: 1.5,
          ),
        ),
        const SizedBox(height: 20),
        // Chapters
        if (lesson.chapters.isNotEmpty) ...[
          const Text(
            'Chapter Markers',
            style: TextStyle(
              fontFamily: 'Plus Jakarta Sans',
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: AppTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          ...lesson.chapters.map(
            (ch) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                    decoration: BoxDecoration(
                      color: AppTheme.greySubtle,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Text(
                      ch.timestamp,
                      style: const TextStyle(
                        fontFamily: 'Plus Jakarta Sans',
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.textSecondary,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    ch.title,
                    style: const TextStyle(
                      fontFamily: 'Plus Jakarta Sans',
                      fontSize: 12.5,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
        ],
        // Download notes
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: AppTheme.surfaceWhite,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: AppTheme.borderColor),
          ),
          child: Row(
            children: [
              const Icon(Icons.picture_as_pdf_rounded, size: 20, color: AppTheme.textSecondary),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  lesson.downloadableNotes,
                  style: const TextStyle(
                    fontFamily: 'Plus Jakarta Sans',
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textPrimary,
                  ),
                ),
              ),
              const Icon(Icons.download_rounded, size: 18, color: AppTheme.textSecondary),
            ],
          ),
        ),
        const SizedBox(height: 24),
        // Mark complete button
        GestureDetector(
          onTap: lesson.isCompleted ? null : onComplete,
          child: Container(
            height: 50,
            decoration: BoxDecoration(
              color: lesson.isCompleted ? AppTheme.greySubtle : AppTheme.pureBlack,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (lesson.isCompleted) ...[
                    const Icon(Icons.check_rounded, color: AppTheme.successGreen, size: 20),
                    const SizedBox(width: 8),
                    const Text(
                      'Lesson Complete',
                      style: TextStyle(
                        fontFamily: 'Plus Jakarta Sans',
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.successGreen,
                      ),
                    ),
                  ] else ...[
                    const Text(
                      'Mark as Complete',
                      style: TextStyle(
                        fontFamily: 'Plus Jakarta Sans',
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}

// ─── Quiz View ────────────────────────────────────────────────
class _QuizView extends StatefulWidget {
  final QuizModel quiz;
  final VoidCallback onComplete;
  const _QuizView({required this.quiz, required this.onComplete});

  @override
  State<_QuizView> createState() => _QuizViewState();
}

class _QuizViewState extends State<_QuizView> {
  int _currentQ = 0;
  bool _submitted = false;
  bool _showExplanation = false;

  QuizQuestion get _q => widget.quiz.questions[_currentQ];
  bool get _isLast => _currentQ == widget.quiz.questions.length - 1;

  void _selectOption(int idx) {
    if (_q.selectedOptionIndex != null) return;
    setState(() {
      _q.selectedOptionIndex = idx;
      _showExplanation = true;
    });
  }

  void _next() {
    if (_isLast) {
      // Calculate score
      int correct = widget.quiz.questions.where((q) => q.isCorrect).length;
      int score = ((correct / widget.quiz.questions.length) * 100).round();
      setState(() {
        _submitted = true;
        widget.quiz.userScore = score;
        widget.quiz.isPassed = score >= widget.quiz.passingScorePercent;
        widget.quiz.isCompleted = true;
      });
    } else {
      setState(() {
        _currentQ++;
        _showExplanation = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_submitted) {
      return _QuizResultView(
        quiz: widget.quiz,
        onContinue: widget.onComplete,
      );
    }

    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        // Header
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: AppTheme.pureBlack,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: [
              const Icon(Icons.quiz_rounded, color: Colors.white, size: 20),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  widget.quiz.title,
                  style: const TextStyle(
                    fontFamily: 'Plus Jakarta Sans',
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),
              Text(
                '${_currentQ + 1} / ${widget.quiz.questions.length}',
                style: TextStyle(
                  fontFamily: 'Plus Jakarta Sans',
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: Colors.white.withValues(alpha: 0.7),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        // Progress bar
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: (_currentQ + 1) / widget.quiz.questions.length,
            backgroundColor: AppTheme.greySubtle,
            valueColor: const AlwaysStoppedAnimation<Color>(AppTheme.pureBlack),
            minHeight: 5,
          ),
        ),
        const SizedBox(height: 20),
        Text(
          'Q${_currentQ + 1}. ${_q.question}',
          style: const TextStyle(
            fontFamily: 'Plus Jakarta Sans',
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: AppTheme.textPrimary,
            height: 1.4,
          ),
        ),
        const SizedBox(height: 18),
        ..._q.options.asMap().entries.map((e) {
          final i = e.key;
          final opt = e.value;
          final selected = _q.selectedOptionIndex == i;
          final isCorrect = i == _q.correctOptionIndex;
          final answered = _q.selectedOptionIndex != null;

          Color borderColor = AppTheme.borderColor;
          Color bgColor = AppTheme.surfaceWhite;

          if (answered) {
            if (isCorrect) {
              borderColor = AppTheme.successGreen;
              bgColor = AppTheme.successGreen.withValues(alpha: 0.06);
            } else if (selected) {
              borderColor = AppTheme.errorRed;
              bgColor = AppTheme.errorRed.withValues(alpha: 0.06);
            }
          }

          return GestureDetector(
            onTap: () => _selectOption(i),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: bgColor,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: borderColor, width: answered && (isCorrect || selected) ? 1.5 : 1),
              ),
              child: Row(
                children: [
                  Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: answered
                          ? isCorrect
                              ? AppTheme.successGreen
                              : selected
                                  ? AppTheme.errorRed
                                  : AppTheme.greySubtle
                          : AppTheme.greySubtle,
                    ),
                    child: Center(
                      child: answered && (isCorrect || selected)
                          ? Icon(
                              isCorrect ? Icons.check_rounded : Icons.close_rounded,
                              size: 15,
                              color: Colors.white,
                            )
                          : Text(
                              String.fromCharCode(65 + i),
                              style: const TextStyle(
                                fontFamily: 'Plus Jakarta Sans',
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: AppTheme.textSecondary,
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
                        fontSize: 13.5,
                        fontWeight: FontWeight.w500,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
        if (_showExplanation && _q.selectedOptionIndex != null) ...[
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppTheme.greySubtle,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.info_outline_rounded, size: 16, color: AppTheme.textSecondary),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    _q.explanation,
                    style: const TextStyle(
                      fontFamily: 'Plus Jakarta Sans',
                      fontSize: 12,
                      color: AppTheme.textSecondary,
                      height: 1.45,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
        const SizedBox(height: 24),
        if (_q.selectedOptionIndex != null)
          GestureDetector(
            onTap: _next,
            child: Container(
              height: 50,
              decoration: BoxDecoration(
                color: AppTheme.pureBlack,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Text(
                  _isLast ? 'Submit Quiz' : 'Next Question',
                  style: const TextStyle(
                    fontFamily: 'Plus Jakarta Sans',
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        const SizedBox(height: 24),
      ],
    );
  }
}

class _QuizResultView extends StatelessWidget {
  final QuizModel quiz;
  final VoidCallback onContinue;
  const _QuizResultView({required this.quiz, required this.onContinue});

  @override
  Widget build(BuildContext context) {
    final score = quiz.userScore ?? 0;
    final passed = quiz.isPassed;
    return Padding(
      padding: const EdgeInsets.all(28),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: passed ? AppTheme.successGreen.withValues(alpha: 0.1) : AppTheme.errorRed.withValues(alpha: 0.1),
              border: Border.all(color: passed ? AppTheme.successGreen : AppTheme.errorRed, width: 2),
            ),
            child: Icon(
              passed ? Icons.check_rounded : Icons.close_rounded,
              size: 40,
              color: passed ? AppTheme.successGreen : AppTheme.errorRed,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            passed ? 'Quiz Passed!' : 'Not Quite There',
            style: const TextStyle(
              fontFamily: 'Plus Jakarta Sans',
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: AppTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'You scored $score% (pass: ${quiz.passingScorePercent}%)',
            style: const TextStyle(
              fontFamily: 'Plus Jakarta Sans',
              fontSize: 14,
              color: AppTheme.textSecondary,
            ),
          ),
          const SizedBox(height: 28),
          GestureDetector(
            onTap: onContinue,
            child: Container(
              width: double.infinity,
              height: 50,
              decoration: BoxDecoration(
                color: AppTheme.pureBlack,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Center(
                child: Text(
                  'Continue to Next Module',
                  style: TextStyle(
                    fontFamily: 'Plus Jakarta Sans',
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
