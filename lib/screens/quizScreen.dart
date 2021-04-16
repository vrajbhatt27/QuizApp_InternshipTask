import 'package:flutter/material.dart';
import './resultScreen.dart';
import '../data.dart';

class QuizScreen extends StatefulWidget {
  @override
  _QuizScreenState createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  
  int seconds = 7;
  int index = 0;
  int totCorrectAns = 0;
  int totIncorrectAns = 0;
  List selectedOptions = [];
  int selOptionIndex; //temporary

  @override
  void initState() {
    super.initState();
    // countDown();
  }

  countDown() {
    Future.doWhile(() async {
      await Future.delayed(
        Duration(seconds: 1),
      );
      setState(() {
        seconds--;
      });
      if (seconds == 0) {
        nextQues();
      }
      return seconds != -1;
    });
  }

  void nextQues() {
    if (index < 2) {
      setState(() {
        index = (index + 1);
        selOptionIndex = 0;
        seconds = 7;
      });
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => ResultScreen(totCorrectAns, selectedOptions),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    var quesText = questions[index].keys.toList()[0]; //The question text
    var options = questions[index][quesText];

    return Scaffold(
        appBar: AppBar(
          title: Text('Quiz'),
        ),
        body: Column(
          children: [
            //For  Question
            Container(
              height: 100,
              width: double.infinity,
              child: Card(
                color: Colors.blue,
                elevation: 5,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          " Correct: $totCorrectAns",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        Text("$seconds"),
                        Text(
                          " Incorrect: $totIncorrectAns",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text("Question ${index + 1}/3"),
                    SizedBox(
                      height: 10,
                    ),
                    Center(
                      child: Text(
                        quesText,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            //For Option
            Container(
              height: 250,
              child: ListView.builder(
                  itemCount: options.length,
                  itemBuilder: (context, ind) {
                    return Card(
                      color: questions[index]['colors'][ind],
                      elevation: 5,
                      child: ListTile(
                        title: Text(options[ind]),
                        onTap: selOptionIndex != -1
                            ? () {
                                selOptionIndex = ind;
                                setState(() {
                                  questions[index]['colors'][ind] = Colors.blue;
                                  for (var i = 0; i < 4; i++) {
                                    if (i != selOptionIndex) {
                                      questions[index]['colors'][i] =
                                          Colors.black54;
                                    }
                                  }
                                });
                              }
                            : () {},
                      ),
                    );
                  }),
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                //Submit Button
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 80),
                  child: ElevatedButton(
                    onPressed: () {
                      selectedOptions.add(options[selOptionIndex]);
                      var ansInd = questions[index]['ans'];

                      setState(() {
                        if (ansInd == selOptionIndex) {
                          questions[index]['colors'][selOptionIndex] =
                              Colors.green;
                          totCorrectAns++;
                        } else {
                          questions[index]['colors'][selOptionIndex] =
                              Colors.red;
                          questions[index]['colors'][ansInd] = Colors.green;
                          totIncorrectAns++;
                        }
                      });
                      selOptionIndex = -1;
                    },
                    child: Text('Submit'),
                  ),
                ),

                // Next Question
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    onPressed: nextQues,
                    child: index > 1 ? Text("Finish") : Text('Next'),
                  ),
                )
              ],
            ),
          ],
        ));
  }
}
