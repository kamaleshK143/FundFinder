import 'package:flutter/material.dart';
import 'package:fundfinderff/Screens/Chatbot/scholarship_loader.dart';


class ChatProvider extends ChangeNotifier {
  List<Map<String, dynamic>> _messages = [];
  List<String> _userAnswers = [];

  List<Map<String, dynamic>> get messages => _messages;

  int _questionIndex = 0;
  bool _isProcessing = false;
  List<Map<String, dynamic>> _questions = [
    {
      'question': "What is your current level of education?",
      'options': ["High School", "Undergraduate", "Postgraduate", "PhD / Doctorate"]
    },
    {
      'question': "What is your gender?",
      'options': ["Male", "Female", "Other"]
    },
    {
      'question': "Do you belong to any reserved category?",
      'options': ["SC", "ST", "OBC", "General", "Minority"]
    },
    {
      'question': "What is your annual family income?",
      'options': ["Below ₹1 Lakh", "₹1–2.5 Lakhs", "₹2.5–5 Lakhs", "Above ₹5 Lakhs"]
    },
    {
      'question': "Which state are you residing or studying in?",
      'options': ["Tamil Nadu", "Karnataka", "Maharashtra", "Other"]
    },
    {
      'question': "What is your field of study?",
      'options': ["Engineering", "Arts", "Science", "Medicine", "Management", "Others"]
    },
    {
      'question': "Are you looking for merit-based or need-based scholarships?",
      'options': ["Merit-based", "Need-based", "Both"]
    },
    {
      'question': "Do you have a disability status?",
      'options': ["Yes", "No"]
    }
  ];

  ChatProvider() {
    _sendBotMessage(
        "Hello! I can help you find scholarships. Let's get started!");
    _askNextQuestion();
  }

  void _sendBotMessage(String text) {
    _messages.add({"text": text, "isUser": false});
    notifyListeners();
  }

  void sendUserMessage(String text) {
    if (_isProcessing) return;

    _messages.add({"text": text, "isUser": true});
    notifyListeners();

    _processUserResponse(text);
  }

  void _processUserResponse(String text) {
    if (_questionIndex < _questions.length) {
      _userAnswers.add(text);
      _questionIndex++;
      _askNextQuestion();
    } else {
      _fetchScholarships();
    }
  }

  void _askNextQuestion() {
    if (_questionIndex < _questions.length) {
      var questionData = _questions[_questionIndex];
      String questionText = questionData['question'];
      List<String> options = List<String>.from(questionData['options']);

      _messages.add({"text": questionText, "isUser": false});

      // Store options as selectable buttons
      for (var option in options) {
        _messages.add({"text": option, "isUser": false, "isOption": true});
      }

      notifyListeners();
    } else {
      _fetchScholarships();
    }
  }

  void searchScholarship(String name) {
    final scholarship = ScholarshipLoader.searchScholarshipByName(name);

    if (scholarship == null) {
      _sendBotMessage("No scholarship found with the name: $name");
    } else {
      _sendBotMessage(
          "${scholarship.name}\n\n${scholarship.about}\n\n🎓 Reward: ${scholarship.reward}\n\n🔗 [Apply Now](${scholarship.link})"
      );
    }
  }
  void _addScholarshipMessage(Scholarship scholarship) {
    _messages.add({
      "type": "scholarship",
      "scholarship": scholarship,
      "isUser": false,
    });
    notifyListeners();
  }


  void _fetchScholarships() async {
    _sendBotMessage("Fetching scholarships based on your answers... 🔍");

    try {
      await ScholarshipLoader.loadScholarships(); // Load from JSON
      final scholarships = ScholarshipLoader.filterScholarships(_userAnswers);

      if (scholarships.isEmpty) {
        _sendBotMessage("No scholarships matched your criteria. Try modifying your answers.");
      } else {
        _sendBotMessage("Here are some scholarships for you:");
        for (var scholarship in scholarships) {
          _addScholarshipMessage(scholarship); // 👈 Add this instead of a text message
        }
      }
    } catch (e) {
      _sendBotMessage("An error occurred while fetching scholarships. Please try again later.");
      print("Error in fetching scholarships: $e");
    }
  }

}