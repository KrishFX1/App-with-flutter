import 'package:Kahani_App/login/Widgets/Passwordlesssignin.dart';
import 'package:flutter/material.dart';

class LoadingWidget extends StatefulWidget {
  @override
  _LoadingWidgetState createState() => _LoadingWidgetState();
}

class _LoadingWidgetState extends State<LoadingWidget> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
      body: Center(
        child: Container(
          child: GestureDetector(
            onTap: () {
              return PasswordLessSignIn(context);
            },
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Loading....'),
                CircularProgressIndicator(),
              ],
            ),
          ),
        ),
      ),
    ));
  }
}
