import 'package:calculator_flutter/button.dart';
import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';

const List<List<String>> myButton = [
  ['C', 'DEL', '%', '/'],
  ['7', '8', '9', 'X'],
  ['4', '5', '6', '-'],
  ['1', '2', '3', '+'],
  [
    '0',
    '.',
    'ANS',
    '=',
  ],
];
const List<String> buttonsPrimary = [
  'C',
  'DEL',
  '%',
  '/',
  'X',
  '-',
  '+',
  '=',
];

void main() {
  runApp(const Home());
}

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Calculator(),
    );
  }
}

class Calculator extends StatefulWidget {
  const Calculator({super.key});

  @override
  State<Calculator> createState() => _CalculatorState();
}

class _CalculatorState extends State<Calculator> {
  String answer = '0';
  String question = '';

  @override
  Widget build(BuildContext context) {
    void clear() {
      setState(() {
        answer = '0';
        question = '';
      });
    }

    void calculation() {
      if (answer.isNotEmpty) {
        question = question.replaceAll('X', '*');
        Parser p = Parser();
        Expression exp = p.parse(question);
        ContextModel cm = ContextModel();
        double eval = exp.evaluate(EvaluationType.REAL, cm);
        setState(() {
          answer = eval.toString();
        });
      }
    }

    List<Row> getButtons() {
      List<Row> buttons = [];
      for (int i = 0; i < 5; i++) {
        buttons.add(Row(
          children: myButton[i].map((item) {
            var isButtonPrimary = buttonsPrimary.contains(item);
            return MyButton(
              buttonText: item,
              buttonColor: isButtonPrimary ? Colors.lightBlue : Colors.white,
              textColor: isButtonPrimary ? Colors.white : Colors.black,
              onPressed: () {
                if (item == 'C') {
                  return clear();
                }

                if (item == 'DEL') {
                  if (question.isNotEmpty) {
                    return setState(() {
                      question = question.substring(0, question.length - 1);
                    });
                  } else {
                    return clear();
                  }
                }

                if (item == '=') {
                  return calculation();
                }

                return setState(() {
                  answer = item;
                  question += item;
                });
              },
            );
          }).toList(),
        ));
      }
      return buttons;
    }

    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: Container(
              color: Colors.lightGreen,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.only(left: 20, top: 30),
                    alignment: Alignment.centerLeft,
                    child: Text(
                      question,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 25,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.only(right: 20),
                    alignment: Alignment.centerRight,
                    child: Text(
                      answer,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 100,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Container(
              color: Colors.lightGreen,
              child: Column(
                children: getButtons(),
              ),
            ),
          )
        ],
      ),
    );
  }
}
