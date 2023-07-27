import 'package:flutter/material.dart';
import 'package:second_draft/Components/GradientButton.dart';

class Button{

  Widget createButton(BuildContext context, String text, Widget landingPage){

    Widget button = MyElevatedButton(
        onPressed: (){
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => landingPage)
          );
        },
        gradient: const LinearGradient(colors: [Colors.blue, Colors.pink]),
        borderRadius: BorderRadius.circular(20),
        width: 150,
        child: SizedBox(
          width: 150,
          child: Center(
            child: Text(text, style: const TextStyle(fontSize: 15, color: Colors.white),),
          ),
        )
    );

    return button;
  }
}