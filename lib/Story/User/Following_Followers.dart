import 'package:Kahani_App/Story/Story/StoryRead.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_admob/flutter_native_admob.dart';
import 'package:flutter_native_admob/native_admob_options.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import '../../main.dart';
import 'UserViewer.dart';

// ignore: camel_case_types
class followingsAndFollowers extends StatefulWidget {
  final String UserName;
  final String UserID;
  final String UserEmail;
  final String UserPhoto;

  followingsAndFollowers(
      {this.UserEmail, this.UserID, this.UserName, this.UserPhoto});
  @override
  _followingAndFollowersState createState() => _followingAndFollowersState();
}

class _followingAndFollowersState extends State<followingsAndFollowers> {
  String UserName;
  String UserID;
  String UserPhoto;
  String UserEmail;

  var controller;

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

  var Followings;
  var Viewers;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: FutureBuilder(
          future: GetFollowing(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return Expanded(
                child: ListView.separated(
                    shrinkWrap: true,
                    itemCount: snapshot.data.docs.length,
                    itemBuilder: (BuildContext context, int index) {
                      //  int a = index;
                      //  var doc  =
                      return Card(
                        child: Container(
                          child: FlatButton(
                            color: Color(0xFFC8FDE2),
                            padding: EdgeInsets.all(0),
                            onPressed: () async {
                              DocumentReference doc =
                                  stories.doc(snapshot.data.docs[index].id);
                              String doc2 = doc.id;
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => StoryRead(
                                    DocID: doc2,
                                    Title: snapshot.data.docs[index]
                                        .data()['Title']
                                        .toString(),
                                    Author: snapshot.data.docs[index]
                                        .data()['UserName']
                                        .toString(),
                                    Story: snapshot.data.docs[index]
                                        .data()['Story'],
                                    Characters: snapshot.data.docs[index]
                                        .data()['Characters'],
                                    StoryUserID: snapshot.data.docs[index]
                                        .data()['UserID'],
                                  ),
                                ),
                              );
                              DocumentSnapshot viewers = await firestore
                                  .collection('Stories')
                                  .doc(doc2)
                                  .collection('UsersViewed')
                                  .doc(UserID)
                                  .get();
                              setState(() {
                                Viewers = viewers;
                              });

                              if (Viewers == null) {
                                firestore.runTransaction((transaction) async {
                                  // Get the document

                                  DocumentSnapshot snapshot =
                                      await transaction.get(doc);

                                  if (!snapshot.exists) {
                                    throw Exception("User does not exist!");
                                  }

                                  // Update the follower count based on the current count
                                  int views = snapshot.data()['Views'] + 1;

                                  // Perform an update on the document
                                  transaction.update(doc, {'Views': views});
                                }).then((value) => () {
                                      firestore
                                          .collection('Stories')
                                          .doc(doc2)
                                          .collection('UsersViewed')
                                          .doc(UserID)
                                          .set({
                                        'UserID': UserID,
                                        'Attempted': true,
                                        "Completed": false,
                                        "Time": DateTime.now()
                                      });
                                    });
                              } else {}
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(31)),
                              width: double.infinity,
                              height: 180,
                              child: Row(
                                children: [
                                  Expanded(
                                    flex: 136,
                                    child: Container(
                                      height: 180,
                                      decoration: BoxDecoration(
                                          color: Colors.red,
                                          borderRadius: BorderRadius.only(
                                              bottomLeft: Radius.circular(21),
                                              topLeft: Radius.circular(21),
                                              topRight: Radius.zero,
                                              bottomRight: Radius.zero)),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.only(
                                            bottomLeft: Radius.circular(21),
                                            topLeft: Radius.circular(21),
                                            topRight: Radius.zero,
                                            bottomRight: Radius.zero),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            image: DecorationImage(
                                                image: snapshot.data.docs[index]
                                                                .data()[
                                                            'TitleImage'] ==
                                                        null
                                                    ? NetworkImage(
                                                        'https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcQ1mp1Me8Nu3Mt2HKYaYGbffVX8I7v83p1lHA&usqp=CAU')
                                                    : NetworkImage(snapshot
                                                        .data.docs[index]
                                                        .data()['TitleImage']),
                                                fit: BoxFit.fill),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 2.3),
                                  Expanded(
                                    flex: 281,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Color(0xFFC8FDE2),
                                        borderRadius: BorderRadius.only(
                                            bottomRight: Radius.circular(31),
                                            topRight: Radius.circular(31),
                                            topLeft: Radius.zero,
                                            bottomLeft: Radius.zero),
                                      ),
                                      width: 235,
                                      child: Column(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          SizedBox(height: 2),
                                          Center(
                                            child: Text(
                                              snapshot.data.docs[index]
                                                          .data()['Title'] ==
                                                      null
                                                  ? 'NO TEXT'
                                                  : snapshot.data.docs[index]
                                                      .data()['Title'],
                                              style: (GoogleFonts.alegreya(
                                                fontWeight: FontWeight.w800,
                                                fontSize: 20,
                                                fontStyle: FontStyle.italic,
                                              )),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 6.2,
                                          ),
                                          Text(
                                            snapshot.data.docs[index]
                                                        .data()['Description']
                                                        .join(' ') ==
                                                    null
                                                ? 'NO TEXT'
                                                : snapshot.data.docs[index]
                                                    .data()['Description']
                                                    .join(' '),
                                            style:
                                                (GoogleFonts.averiaSansLibre()),
                                          ),
                                          SizedBox(height: 9.8),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            children: [
                                              Column(
                                                children: [
                                                  SizedBox(
                                                    height: 2.3,
                                                  ),
                                                  Text(
                                                    snapshot.data.docs[index]
                                                                    .data()[
                                                                'UserName'] ==
                                                            null
                                                        ? 'NO UID'
                                                        : snapshot
                                                            .data.docs[index]
                                                            .data()['UserName'],
                                                    style: (GoogleFonts.aladin(
                                                        fontSize: 17)),
                                                  ),
                                                ],
                                              ),
                                              // SizedBox(width: 3),
                                              ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(25),
                                                child: GestureDetector(
                                                  onTap: () {
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) =>
                                                            UserViewer(
                                                          UserName: UserName,
                                                          UserEmail: UserEmail,
                                                          UserID: UserID,
                                                          UserPhoto: UserPhoto,
                                                          StoryUserID: snapshot
                                                              .data.docs[index]
                                                              .data()['UserID'],
                                                          StoryUserName: snapshot
                                                                  .data
                                                                  .docs[index]
                                                                  .data()[
                                                              'UserName'],
                                                          StoryUserPhoto: snapshot
                                                                  .data
                                                                  .docs[index]
                                                                  .data()[
                                                              'UserPhoto'],
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                  child: CircleAvatar(
                                                    radius: 25,
                                                    child: snapshot.data
                                                                    .docs[index]
                                                                    .data()[
                                                                'UserPhoto'] ==
                                                            null
                                                        ? Center(
                                                            child: Icon(
                                                              Icons
                                                                  .account_circle,
                                                              size: 50,
                                                            ),
                                                          )
                                                        : Container(
                                                            height: 0,
                                                            width: 0,
                                                          ),
                                                    backgroundImage: snapshot
                                                                    .data
                                                                    .docs[index]
                                                                    .data()[
                                                                'UserPhoto'] ==
                                                            null
                                                        ? NetworkImage(
                                                            'https://images.everydayhealth.com/images/despite-more-dieting--americans-still-arent-losing-weight-722x406.jpg')
                                                        : NetworkImage(snapshot
                                                                .data
                                                                .docs[index]
                                                                .data()[
                                                            'UserPhoto']),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                    separatorBuilder: (context, index) {
                      return Container(
                        child: (index != 0 && index % 6 == 0)
                            ? Container(
                                height: 180,
                                width: 360,
                                child: Card(
                                  child: NativeAdmob(
                                    options: NativeAdmobOptions(
                                        headlineTextStyle:
                                            NativeTextStyle(fontSize: 44),
                                        bodyTextStyle:
                                            NativeTextStyle(fontSize: 44),
                                        advertiserTextStyle:
                                            NativeTextStyle(fontSize: 77)),
                                    adUnitID:
                                        'ca-app-pub-4144128581194892/2113810299',
                                    controller: controller,
                                  ),
                                ),
                              )
                            : null,
                      );
                    }),
              );
            } else if (snapshot.connectionState == ConnectionState.none) {
              return Text("No data");
            }
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
              ],
            );
          },
        ));
  }

  LoadUserData() {
    Box UserData = Hive.box('UserData');
    UserEmail = UserData.get('UserEmail');
    UserPhoto = UserData.get('UserPhoto');
    UserName = UserData.get('UserName');
    UserID = UserData.get('UserID');
  }

  Future<QuerySnapshot> GetFollowing() async {
    await firestore
        .collection('Users')
        .doc(UserID)
        .collection('Following')
        .get()
        .then((value) {
      Followings = value.docs[value.size].data()['UserID'];
    }).then((value) async {
      return await firestore
          .collection('Stories')
          .where('UserID', arrayContainsAny: Followings)
          .get();
    });
  }
}
