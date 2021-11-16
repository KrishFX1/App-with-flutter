import 'package:Kahani_App/Widgets/FBuilder.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../../main.dart';

class RecentReads extends StatefulWidget {
  final String UserName;
  final String UserID;
  final String UserEmail;
  final String UserPhoto;

  RecentReads({this.UserEmail, this.UserID, this.UserName, this.UserPhoto});
  @override
  _RecentReadsState createState() => _RecentReadsState();
}

class _RecentReadsState extends State<RecentReads> {
  String UserName;
  String UserID;
  String UserPhoto;
  String UserEmail;

  @override
  void initState() {
    if (widget.UserID == null) {
      LoadUserData();
    } else {
      UserName = widget.UserName;
      UserEmail = widget.UserEmail;
      UserID = widget.UserID;
      UserPhoto = widget.UserPhoto;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                  child: SingleChildScrollView(
                      child: RecentReads50(RecentReads, UserID, UserName,
                          UserEmail, UserPhoto))),
            ],
          ),
        ),
      ),
    );
  }

  Future<QuerySnapshot> RecentReads() async {
    return await firestore
        .collection('Users')
        .doc(UserID)
        .collection('Recent Reads')
        .limit(50)
        .get();
  }

  LoadUserData() {
    Box UserData = Hive.box('UserData');
    UserEmail = UserData.get('UserEmail');
    UserPhoto = UserData.get('UserPhoto');
    UserName = UserData.get('UserName');
    UserID = UserData.get('UserID');
  }
}
