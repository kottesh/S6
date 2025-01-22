import 'package:flutter/material.dart';

class Question {
  final String questionText;
  final List<String> options;
  final int correctAnswerIndex;

  Question({
    required this.questionText,
    required this.options,
    required this.correctAnswerIndex,
  });
}

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  QuizScreenState createState() => QuizScreenState();
}

class QuizScreenState extends State<QuizScreen> {
  int currentQuestionIndex = 0;
  int score = 0;
  bool isQuizComplete = false;

  // Quiz questions
  final List<Question> questions = [
    Question(
      questionText: "What is the capital of France?",
      options: ["London", "Berlin", "Paris", "Madrid"],
      correctAnswerIndex: 2,
    ),
    Question(
      questionText: "Which planet is known as the Red Planet?",
      options: ["Venus", "Mars", "Jupiter", "Saturn"],
      correctAnswerIndex: 1,
    ),
    Question(
      questionText: "What is the largest mammal in the world?",
      options: ["African Elephant", "Blue Whale", "Giraffe", "Polar Bear"],
      correctAnswerIndex: 1,
    ),
    Question(
      questionText: "Who painted the Mona Lisa?",
      options: ["Vincent van Gogh", "Pablo Picasso", "Michelangelo", "Leonardo da Vinci"],
      correctAnswerIndex: 3,
    ),
    Question(
      questionText: "What is the chemical symbol for gold?",
      options: ["Ag", "Fe", "Au", "Cu"],
      correctAnswerIndex: 2,
    ),
    Question(
      questionText: "Which country is home to the kangaroo?",
      options: ["New Zealand", "South Africa", "Australia", "Brazil"],
      correctAnswerIndex: 2,
    ),
    Question(
      questionText: "What is the largest organ in the human body?",
      options: ["Heart", "Brain", "Liver", "Skin"],
      correctAnswerIndex: 3,
    ),
    Question(
      questionText: "In which year did World War II end?",
      options: ["1943", "1944", "1945", "1946"],
      correctAnswerIndex: 2,
    ),
    Question(
      questionText: "What is the main component of the Sun?",
      options: ["Helium", "Oxygen", "Hydrogen", "Nitrogen"],
      correctAnswerIndex: 2,
    ),
    Question(
      questionText: "Which is the longest river in the world?",
      options: ["Amazon", "Nile", "Yangtze", "Mississippi"],
      correctAnswerIndex: 1,
    ),
  ];

  void checkAnswer(int selectedOption) {
    if (!isQuizComplete) {
      setState(() {
        if (selectedOption == questions[currentQuestionIndex].correctAnswerIndex) {
          score++;
        }

        if (currentQuestionIndex < questions.length - 1) {
          currentQuestionIndex++;
        } else {
          isQuizComplete = true;
        }
      });
    }
  }

  void restartQuiz() {
    setState(() {
      currentQuestionIndex = 0;
      score = 0;
      isQuizComplete = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quiz App'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: isQuizComplete
            ? _buildResultScreen()
            : _buildQuestionScreen(),
      ),
    );
  }

  Widget _buildQuestionScreen() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: Colors.purple.shade50,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              Text(
                'Question ${currentQuestionIndex + 1}/10',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.purple,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                questions[currentQuestionIndex].questionText,
                style: const TextStyle(fontSize: 18),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        ...List.generate(
          4,
          (index) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () => checkAnswer(index),
              child: Text(
                questions[currentQuestionIndex].options[index],
                style: const TextStyle(fontSize: 16),
              ),
            ),
          ),
        ),
        const Spacer(),
        Text(
          'Current Score: $score/${currentQuestionIndex + 1}',
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _buildResultScreen() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Quiz Complete!',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          Text(
            'Your Score: $score/10',
            style: const TextStyle(fontSize: 22),
          ),
          const SizedBox(height: 20),
          Text(
            'Percentage: ${(score / 10 * 100).toStringAsFixed(1)}%',
            style: const TextStyle(fontSize: 20),
          ),
          const SizedBox(height: 40),
          ElevatedButton.icon(
            onPressed: restartQuiz,
            icon: const Icon(Icons.replay),
            label: const Text(
              'Restart Quiz',
              style: TextStyle(fontSize: 18),
            ),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(
                horizontal: 32,
                vertical: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
