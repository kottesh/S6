import 'package:flutter/material.dart';

class Calculator extends StatefulWidget {
  const Calculator({super.key});

  @override
  CalculatorState createState() => CalculatorState();
}

class CalculatorState extends State<Calculator> {
  String _output = "0";
  String _currentNumber = "";
  double _num1 = 0;
  String _operand = "";
  bool _newNumber = true;

  void _buttonPressed(String buttonText) {
    setState(() {
      if (buttonText == "C") {
        _output = "0";
        _currentNumber = "";
        _num1 = 0;
        _operand = "";
        _newNumber = true;
      } else if (buttonText == "+" || buttonText == "-" || 
                 buttonText == "×" || buttonText == "÷") {
        if (_currentNumber.isNotEmpty) {
          _num1 = double.parse(_currentNumber);
          _operand = buttonText;
          _newNumber = true;
        }
      } else if (buttonText == "=") {
        if (_currentNumber.isNotEmpty && _operand.isNotEmpty) {
          double num2 = double.parse(_currentNumber);
          switch (_operand) {
            case "+":
              _output = (_num1 + num2).toString();
              break;
            case "-":
              _output = (_num1 - num2).toString();
              break;
            case "×":
              _output = (_num1 * num2).toString();
              break;
            case "÷":
              _output = (_num1 / num2).toString();
              break;
          }
          _currentNumber = _output;
          _operand = "";
        }
      } else {
        if (_newNumber) {
          _currentNumber = buttonText;
          _newNumber = false;
        } else {
          _currentNumber += buttonText;
        }
        _output = _currentNumber;
      }
    });
  }

  Widget _buildButton(String buttonText, {Color? color}) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: color ?? Colors.grey[300],
            padding: const EdgeInsets.all(24.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          onPressed: () => _buttonPressed(buttonText),
          child: Text(
            buttonText,
            style: const TextStyle(
              fontSize: 24.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Calculator'),
      ),
      body: Column(
        children: <Widget>[
          Container(
            alignment: Alignment.bottomRight,
            padding: const EdgeInsets.symmetric(
              vertical: 24.0,
              horizontal: 12.0,
            ),
            child: Text(
              _output,
              style: const TextStyle(
                fontSize: 48.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const Expanded(child: Divider()),
          Column(
            children: [
              Row(
                children: [
                  _buildButton("7"),
                  _buildButton("8"),
                  _buildButton("9"),
                  _buildButton("÷", color: Colors.blue[300]),
                ],
              ),
              Row(
                children: [
                  _buildButton("4"),
                  _buildButton("5"),
                  _buildButton("6"),
                  _buildButton("×", color: Colors.blue[300]),
                ],
              ),
              Row(
                children: [
                  _buildButton("1"),
                  _buildButton("2"),
                  _buildButton("3"),
                  _buildButton("-", color: Colors.blue[300]),
                ],
              ),
              Row(
                children: [
                  _buildButton("C", color: Colors.red[300]),
                  _buildButton("0"),
                  _buildButton("=", color: Colors.green[300]),
                  _buildButton("+", color: Colors.blue[300]),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}