import 'package:flutter/material.dart';
import './quiz.dart';

class DifficultyListView extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      backgroundColor: Color(0xFFCBBB37),
      body: SafeArea(
        child: Container(
          //width: MediaQuery.of(context).size.width,
          //height: 120,
            child: Padding(
              padding: const EdgeInsets.only(
                top: 0,
                bottom: 50,
              ),
              child: Padding(
                padding: const EdgeInsets.all(0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Container(
                      width:400,
                      padding: EdgeInsets.only(left: 0),
                      child: const Text(
                          "難易度を選択",
                          textAlign: TextAlign.center,
                          style:TextStyle(
                            fontSize:30,
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                          )),
                      decoration: BoxDecoration(
                        color: Color(0xFFE8D121),
                        borderRadius: BorderRadius.circular(30),
                      ),),
                    ///easy
                    GestureDetector(
                        onTap: (){
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => QuizApp()),
                          );
                        },
                        child:Container(
                          width: 400,
                          height: 200,
                          //child:Text("easy"),
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage('images/difficulty_easy.png'),
                              fit: BoxFit.cover,
                            ),
                          ),
                          //child: Image.asset('assets/flag.png'),
                        )
                    ),
                    ///normal
                    GestureDetector(
                        onTap: (){
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => QuizApp()),
                          );
                        },
                        child:Container(
                          width: 400,
                          height: 200,
                          //child:Text("normal"),
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage('images/difficulty_normal.png'),
                              fit: BoxFit.cover,
                            ),
                          ),
                          //child: Image.asset('assets/flag.png'),
                        )
                    ),
                    ///hard
                    GestureDetector(
                        onTap: (){
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => QuizApp()),
                          );
                        },
                        child:Container(
                          width: 400,
                          height: 200,
                          //child:Text("hard"),
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage('images/difficulty_hard.png'),
                              fit: BoxFit.cover,
                            ),
                          ),
                          //child: Image.asset('assets/flag.png'),
                        )
                    )

                      ],
                    )
                ),
            ),

        ),
          ),
    );
  }
}
