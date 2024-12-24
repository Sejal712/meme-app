import 'package:flutter/material.dart';

class splashScreen extends StatelessWidget {
  const splashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.network("https://i.imgflip.com/1nbv5e.jpg"),
              SizedBox(height: 30,),
              Text("happiness ki Medicine",style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold
              ),)
            ],
          )
      ),
    );
  }
}
