import 'dart:async';
import 'package:final_620710293/mod/q.dart';
import 'package:final_620710293/ser/api.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Quiz>? q_list;
  int c = 0;
  int wrong_g = 0;
  String message = "";

  @override
  void initState() {
    super.initState();
    _fetch();
  }

  void _fetch() async {
    List list = await Api().fetch('quizzes');
    setState(() {
      q_list = list.map((item) => Quiz.fromJson(item)).toList();
    });
  }

  void guess(String choice) {
    setState(() {
      if (q_list![c].answer == choice) {
        message = "เก่งมากค้าบ เอาไปเลย👍นิ้วโป้ง👍👍เอาไปเล้ยย";
      } else {
        message = "ตอบผิดนะคับ ลองตอบใหม่ดูนะคะตะหนู😇✌️";
      }
    });
    Timer timer = Timer(Duration(seconds: 2), () {
      setState(() {
        message = "";
        if (q_list![c].answer == choice) {
          c++;
        } else {
          wrong_g++;
        }
      });
    });
  }

  Widget printGuess() {
    if (message.isEmpty) {
      return SizedBox(height: 30, width: 20);
    } else if (message == "เก่งมากค้าบ เอาไปเลย👍นิ้วโป้ง👍👍เอาไปเล้ยย") {
      return Text(message);
    } else {
      return Text(message);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: q_list != null && c < q_list!.length-1
          ? buildQuiz()
          : q_list != null && c == q_list!.length-1
          ? buildTryAgain()
          : const Center(child: CircularProgressIndicator()),
    );
  }

  Widget buildTryAgain() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('เกมจบล้าวฮะ😎🍎🥓'),
            Text('ทายผิด ${wrong_g} ครั้งนะคับ😢🤌'),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    wrong_g = 0;
                    c = 0;
                    q_list = null;
                    _fetch();
                  });
                },
                child: Text('ลองเล่นใหม่อ้ะป่าวว👉👈🥺'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Padding buildQuiz() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Image.network(q_list![c].image_url, fit: BoxFit.cover),
            Column(
              children: [
                for (int i = 0; i < q_list![c].choices.length; i++)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () =>
                                guess(q_list![c].choices[i].toString()),
                            child: Text(q_list![c].choices[i]),
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
            printGuess(),
          ],
        ),
      ),
    );
  }
}