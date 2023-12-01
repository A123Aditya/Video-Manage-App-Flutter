import 'package:flutter/material.dart';
import 'package:myapp/Camera/CameraPage.dart';

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Center(
            child: Text("Record a video"),
          )
        ],
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder: (context) => Camera_Page(),));
        },
        child: Icon(Icons.camera),
        ),
    );
  }
}
