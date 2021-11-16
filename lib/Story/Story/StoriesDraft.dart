import 'package:Kahani_App/Story/Story/StoryWorkspace.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../../main.dart';

class StoriesDraft extends StatefulWidget {
  final String UserName;
  final String UserID;
  final String UserEmail;
  final String UserPhoto;

  StoriesDraft({this.UserEmail, this.UserID, this.UserName, this.UserPhoto});

  @override
  _StoriesDraftState createState() => _StoriesDraftState();
}

class _StoriesDraftState extends State<StoriesDraft> {
  String UserName;
  String UserID;
  String UserEmail;
  String UserPhoto;

  @override
  void initState() {
    super.initState();

    if (widget.UserID == null) {
      LoadUserData();
    } else {
      UserName = widget.UserName;
      UserEmail = widget.UserEmail;
      UserID = widget.UserID;
      UserPhoto = widget.UserPhoto;
    }
  }

  Timestamp time;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Container(
          child: FutureBuilder(
            future: LoadDraftStories(),
            builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return ListView.builder(
                    itemCount: snapshot.data.docs.length,
                    itemBuilder: (BuildContext context, int index) {
                      String Title = snapshot.data.docs[index].data()['Title'];
                      String Description =
                          snapshot.data.docs[index].data()['Description'];
                      return Column(
                        children: [
                          FlatButton(
                              padding: EdgeInsets.all(0),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => StoryWorkspace(
                                      Description: snapshot.data.docs[index]
                                          .data()['Description'],
                                      Title: snapshot.data.docs[index]
                                          .data()['Title']
                                          .toString(),
                                      Story: snapshot.data.docs[index]
                                          .data()['Story'],
                                      TitleImage: snapshot.data.docs[index]
                                          .data()['TitleImage'],
                                      doc: snapshot.data.docs[index]
                                          .data()['doc'],
                                    ),
                                  ),
                                );
                              },
                              color: Colors.yellow[200],
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                              child: Column(
                                children: [
                                  Center(
                                    child: Text(
                                      snapshot.data.docs[index].data()['Title'],
                                      // '$Title',
                                      style: TextStyle(fontSize: 22),
                                    ),
                                  ),
                                  Center(
                                    child: Text(
                                      snapshot.data.docs[index]
                                          .data()['Description'],
                                      // Description,
                                      style: TextStyle(fontSize: 16),
                                    ),
                                  ),
                                  SizedBox(height: 7),
                                ],
                              )),
                        ],
                      );
                    });
              } else if (snapshot.connectionState == ConnectionState.none) {
                return Text("No data");
              }
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(child: CircularProgressIndicator()),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Future<QuerySnapshot> LoadDraftStories() async {
    return await firestore
        .collection('Users')
        .doc(UserID)
        .collection('StoriesDarft')
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
