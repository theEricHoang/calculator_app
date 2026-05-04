import 'package:flutter/material.dart';
import 'calculator_logic.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calculator',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const CalculatorScreen(),
    );
  }
}

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  String _display = '0';
  double? _firstOperand;
  String? _operator;
  bool _waitingForSecondOperand = false;
  bool _isDarkMode = false;

  void _toggleTheme() {
    setState(() {
      _isDarkMode = !_isDarkMode;
    });
  }

  Color get _scaffoldColor =>
      _isDarkMode ? Colors.grey[900]! : Colors.white;

  Color get _displayColor =>
      _isDarkMode ? const Color(0xFF303030) : Colors.grey[200]!;

  Color get _displayTextColor =>
      _isDarkMode ? Colors.white : Colors.black;

  Color get _numberButtonColor =>
      _isDarkMode ? Colors.grey[700]! : Colors.grey[300]!;

  Color get _numberButtonTextColor =>
      _isDarkMode ? Colors.white : Colors.black;

  void _onNumberPressed(String digit) {
    setState(() {
      if (_waitingForSecondOperand) {
        _display = digit;
        _waitingForSecondOperand = false;
      } else {
        _display = _display == '0' ? digit : _display + digit;
      }
    });
  }

  void _onOperatorPressed(String op) {
    setState(() {
      _firstOperand = double.tryParse(_display);
      _operator = op;
      _waitingForSecondOperand = true;
    });
  }

  void _onEqualsPressed() {
    if (_firstOperand == null || _operator == null) return;
    final secondOperand = double.tryParse(_display);
    if (secondOperand == null) return;

    final result = calculate(_firstOperand!, _operator!, secondOperand);
    setState(() {
      if (result == null) {
        _display = 'Error';
      } else {
        _display = _formatResult(result);
      }
      _firstOperand = null;
      _operator = null;
      _waitingForSecondOperand = false;
    });
  }

  void _onClearPressed() {
    setState(() {
      _display = '0';
      _firstOperand = null;
      _operator = null;
      _waitingForSecondOperand = false;
    });
  }

  String _formatResult(double value) {
    if (value == value.truncateToDouble()) {
      return value.toInt().toString();
    }
    return value.toString();
  }

  Widget _buildButton(String label, {Color? color}) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: color ?? _numberButtonColor,
            foregroundColor: color != null ? Colors.white : _numberButtonTextColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          onPressed: () {
            if (label == 'C') {
              _onClearPressed();
            } else if (label == '=') {
              _onEqualsPressed();
            } else if (['+', '-', '*', '/'].contains(label)) {
              _onOperatorPressed(label);
            } else {
              _onNumberPressed(label);
            }
          },
          child: Text(
            label,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _scaffoldColor,
      body: Column(
        children: [
          Expanded(
            flex: 2,
            child: Container(
              width: double.infinity,
              color: _displayColor,
              child: Stack(
                children: [
                  Positioned(
                    top: 40,
                    right: 8,
                    child: IconButton(
                      icon: Icon(
                        _isDarkMode ? Icons.wb_sunny : Icons.nightlight_round,
                        color: _displayTextColor,
                      ),
                      onPressed: _toggleTheme,
                    ),
                  ),
                  Positioned(
                    bottom: 24,
                    left: 24,
                    right: 24,
                    child: Text(
                      _display,
                      style: TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                        color: _displayTextColor,
                      ),
                      textAlign: TextAlign.right,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 5,
            child: Column(
              children: [
                _buildRow(['7', '8', '9', '/']),
                _buildRow(['4', '5', '6', '*']),
                _buildRow(['1', '2', '3', '-']),
                _buildRow(['C', '0', '=', '+']),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRow(List<String> labels) {
    return Expanded(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: labels.map((label) {
          Color? color;
          if (['+', '-', '*', '/'].contains(label)) {
            color = Colors.orange;
          } else if (label == 'C') {
            color = Colors.red;
          } else if (label == '=') {
            color = Colors.blue;
          }
          return _buildButton(label, color: color);
        }).toList(),
      ),
    );
  }
}
