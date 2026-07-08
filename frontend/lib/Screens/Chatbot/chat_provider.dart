import 'package:flutter/material.dart';
import 'package:fundfinderff/models/enums.dart';
import 'package:fundfinderff/services/match_service.dart';

class _ChatQuestion {
  final String text;
  final List<String>? options; // null means free-text input (income)

  _ChatQuestion({required this.text, this.options});
}

/// A step-by-step guided Q&A that builds a MatchCriteria one answer at a
/// time, then submits it to POST /api/match/preview - the exact same
/// EligibilityDecisionEngine the dashboard uses via GET /api/match. This is
/// a rule-driven guided flow, not AI/NLP: every question maps directly onto
/// one MatchCriteria field, and answers are constrained to the same enum
/// options as the profile form, so there's no free-text interpretation or
/// substring guessing involved anywhere in the pipeline.
class ChatProvider extends ChangeNotifier {
  final MatchService _matchService = MatchService();

  final List<Map<String, dynamic>> _messages = [];
  List<Map<String, dynamic>> get messages => _messages;

  int _questionIndex = 0;
  bool _isProcessing = false;

  EducationLevel? _educationLevel;
  double? _annualIncome;
  Category? _category;
  Gender? _gender;
  String? _state;
  bool? _hasDisability;

  static final List<_ChatQuestion> _questions = [
    _ChatQuestion(
      text: "What is your current education level?",
      options: EducationLevel.values.map((e) => e.label).toList(),
    ),
    _ChatQuestion(
      text: "What is your annual family income, in rupees? (type a number, e.g. 250000)",
    ),
    _ChatQuestion(
      text: "Which category do you belong to?",
      options: Category.values.map((e) => e.label).toList(),
    ),
    _ChatQuestion(
      text: "What is your gender?",
      options: Gender.values.map((e) => e.label).toList(),
    ),
    _ChatQuestion(
      text: "Which state are you from?",
      options: indianStates,
    ),
    _ChatQuestion(
      text: "Do you have a disability?",
      options: ["Yes", "No"],
    ),
  ];

  ChatProvider() {
    _sendBotMessage(
        "Hi! I'll ask a few quick questions and match you against the same rule-based eligibility engine used on the dashboard - a plain decision tree, not AI.");
    _askNextQuestion();
  }

  void _sendBotMessage(String text) {
    _messages.add({"text": text, "isUser": false});
    notifyListeners();
  }

  void sendUserMessage(String text) {
    if (_isProcessing || _questionIndex >= _questions.length) return;

    _messages.add({"text": text, "isUser": true});
    notifyListeners();

    _recordAnswer(text.trim());
  }

  void _recordAnswer(String text) {
    switch (_questionIndex) {
      case 0:
        _educationLevel = EducationLevel.values.firstWhere((e) => e.label == text);
        break;
      case 1:
        final parsed = double.tryParse(text);
        if (parsed == null || parsed < 0) {
          _sendBotMessage("That doesn't look like a valid amount. Please enter a number, e.g. 250000");
          return;
        }
        _annualIncome = parsed;
        break;
      case 2:
        _category = Category.values.firstWhere((e) => e.label == text);
        break;
      case 3:
        _gender = Gender.values.firstWhere((e) => e.label == text);
        break;
      case 4:
        _state = text;
        break;
      case 5:
        _hasDisability = text == "Yes";
        break;
    }
    _questionIndex++;
    _askNextQuestion();
  }

  void _askNextQuestion() {
    if (_questionIndex >= _questions.length) {
      _fetchMatches();
      return;
    }

    final question = _questions[_questionIndex];
    _messages.add({"text": question.text, "isUser": false});

    if (question.options != null) {
      for (final option in question.options!) {
        _messages.add({"text": option, "isUser": false, "isOption": true});
      }
    }

    notifyListeners();
  }

  Future<void> _fetchMatches() async {
    _isProcessing = true;
    _sendBotMessage("Finding scholarships that match your answers...");

    try {
      final matches = await _matchService.preview({
        'educationLevel': _educationLevel!.name,
        'annualIncome': _annualIncome,
        'category': _category!.name,
        'gender': _gender!.name,
        'state': _state,
        'hasDisability': _hasDisability,
      });

      if (matches.isEmpty) {
        _sendBotMessage("No scholarships matched your answers right now. Try a different combination.");
      } else {
        _sendBotMessage("Here are ${matches.length} scholarship(s) you're eligible for:");
        for (final scholarship in matches) {
          _messages.add({"type": "scholarship", "scholarship": scholarship, "isUser": false});
        }
        notifyListeners();
      }
    } catch (e) {
      _sendBotMessage("Something went wrong while matching. Please try again in a moment.");
    } finally {
      _isProcessing = false;
      notifyListeners();
    }
  }
}
