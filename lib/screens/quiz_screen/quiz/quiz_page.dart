import 'package:flutter/material.dart';
import 'dart:async';
import 'package:cyber_security_app/screens/quiz_screen/models/quiz_question_template.dart';
import 'package:flutter_rounded_progress_bar/flutter_rounded_progress_bar.dart';
import 'package:flutter_rounded_progress_bar/rounded_progress_bar_style.dart';

class QuizPage extends StatefulWidget {
  final int currentQuestionIndex;
  final QuizQuestion question;
  final int totalQuestions;
  final List<String> shuffleAnswers;

  QuizPage({
    required this.currentQuestionIndex,
    required this.question,
    required this.totalQuestions,
    required this.shuffleAnswers,
    super.key,
  });

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  int _timer = 10;
  Timer? _countdownTimer;
  bool _answered = false;
  String? _selectedAnswer;
  int _startTime = 0;

  @override
  void initState() {
    super.initState();
    _startTime = DateTime.now().millisecondsSinceEpoch;
    _startTimer();
  }

  @override
  void dispose() {
    _countdownTimer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    _countdownTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_timer > 0) {
          _timer--;
        } else {
          _submitAnswer(null);
        }
      });
    });
  }

  void _submitAnswer(String? answer) {
    if (_answered) return;

    setState(() {
      _answered = true;
      _selectedAnswer = answer;
    });

    _countdownTimer?.cancel();
    int elapsedTime =
        (DateTime.now().millisecondsSinceEpoch - _startTime) ~/ 1000;

    Navigator.pop(
      context,
      {
        'selectedAnswer': answer,
        'correct': answer == widget.question.correctAnswer,
        'timeTaken': elapsedTime,
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        title: Text(
          "Quiz",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        automaticallyImplyLeading:
            false, // Prevents the back button from showing
        centerTitle: true,
      ),
      body: Container(
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Row(
                children: [
                  Expanded(
                    child: RoundedProgressBar(
                      style: RoundedProgressBarStyle(
                          backgroundProgress: Colors.purple, widthShadow: 0),
                      height: 25,
                      borderRadius: BorderRadius.circular(24),
                      percent: (_timer / 10) * 100,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    '$_timer s',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20, vertical: 40),
              decoration: BoxDecoration(
                  color: Colors.purple.shade800,
                  borderRadius: BorderRadius.circular(30)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Stack(
                      alignment: Alignment.topCenter,
                      clipBehavior: Clip.none,
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(
                              vertical: 40, horizontal: 16),
                          child: Column(
                            children: [
                              Text(
                                "Question ${widget.currentQuestionIndex + 1}/${widget.totalQuestions}",
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 18,
                                ),
                              ),
                              SizedBox(height: 10),
                              Text(
                                widget.question.question,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                        // CircleAvatar positioned above the container
                        Positioned(
                          top:
                              -60, // Positioning the CircleAvatar above the purple container
                          child: CircleAvatar(
                            radius: 40,
                            child: ClipOval(
                              child: Image.asset(
                                "assets/quiz_img_1.png",
                                width: 80,
                                height: 80,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 40),
                    ...widget.shuffleAnswers.map((answer) {
                      return AnswerButton(
                        answer,
                        () => _submitAnswer(answer),
                      );
                    })
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AnswerButton extends StatelessWidget {
  final String answerText;
  final VoidCallback onPressed;

  AnswerButton(this.answerText, this.onPressed, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color.fromARGB(255, 56, 0, 66),
          padding: const EdgeInsets.symmetric(vertical: 15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
        onPressed: onPressed,
        child: Center(
          child: Text(
            answerText,
            style: const TextStyle(color: Colors.white, fontSize: 18),
          ),
        ),
      ),
    );
  }
}
