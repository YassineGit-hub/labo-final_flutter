import 'package:flutter/material.dart';

class VideoPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:const  Text('Video Page'),
        backgroundColor:Colors.blue ,
      ),
      body:const  Center(
        child: Text(
          'Video',
          style: TextStyle(fontSize: 48, color: Colors.red),
        ),
      ),
    );
  }
}
