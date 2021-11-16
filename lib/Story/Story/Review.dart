import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../main.dart';
import 'StoryPosts.dart';
import 'StoryRead.dart';

class Review extends StatefulWidget {
  final String Author;
  final String StoryUserID;
  final String StoryUserPhoto;
  final String DocID;

  Review({this.Author, this.StoryUserID, this.StoryUserPhoto, this.DocID});

  @override
  _ReviewState createState() => _ReviewState();
}

class _ReviewState extends State<Review> {
  String Title;
  String Views;
  String StoryUserName;
  String StoryUserPhoto;
  int Rating;
  String Description;
  String StoryUserID;
  Timestamp Time;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: SafeArea(
          child: Container(
            child: Column(
              children: [
                SizedBox(height: 30),
                Text('More Stories From The Creator',
                    style: GoogleFonts.galada()),
                SizedBox(height: 30),
                FutureBuilder(
                  future: LoadUserStories(),
                  builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      return Container(
                        height: 152,
                        child: ListView.builder(
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            itemCount: snapshot.data.docs.length,
                            itemBuilder: (BuildContext context, int index) {
                              Title = snapshot.data.docs[index]
                                  .data()['Title']
                                  .toString();
                              Description = snapshot.data.docs[index]
                                  .data()['Description']
                                  .toString();

                              var formattedNumber =
                                  NumberFormat.compactCurrency(
                                decimalDigits: 0,
                                symbol:
                                    '', // if you want to add currency symbol then pass that in this else leave it empty.
                              ).format(snapshot.data.docs[index]
                                      .data()['Views']);
                              StoryUserName =
                                  snapshot.data.docs[index].data()['Name'];
                              Views = formattedNumber;
                              Rating = snapshot.data.docs[index].get('Rating');
                              StoryUserPhoto =
                                  snapshot.data.docs[index].data()['UserPhoto'];

                              Time = snapshot.data.docs[index].data()['Time'];
                              DocumentReference doc =
                                  stories.doc(snapshot.data.docs[index].id);
                              String doc2 = doc.id;
                              // UsersViewed =
                              //     snapshot.data.docs[index].data()['UsersViewed'];
                              return Card(
                                child: Container(
                                  height: 20,
                                  width: 267,
                                  child: FlatButton(
                                      color: Color(0xFFC8FDE2),
                                      padding: EdgeInsets.all(0),
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => StoryRead(
                                              DocID: doc2,
                                              Title: snapshot.data.docs[index]
                                                  .data()[' Title']
                                                  .toString(),
                                              Author: snapshot.data.docs[index]
                                                  .data()['UserName']
                                                  .toString(),
                                              Story: snapshot.data.docs[index]
                                                  .data()['Story'],
                                              Characters: snapshot
                                                  .data.docs[index]
                                                  .data()['Characters'],
                                              StoryUserID: snapshot
                                                  .data.docs[index]
                                                  .data()['UserID'],
                                            ),
                                          ),
                                        );

                                        firestore.runTransaction(
                                            (transaction) async {
                                          // Get the document

                                          DocumentSnapshot snapshot =
                                              await transaction.get(doc);

                                          if (!snapshot.exists) {
                                            throw Exception(
                                                "User does not exist!");
                                          }

                                          // Update the follower count based on the current count
                                          int views =
                                              snapshot.data()['Views'] + 1;

                                          // Perform an update on the document
                                          transaction
                                              .update(doc, {'Views': views});

                                          // Return the new count
                                          return views;
                                        });
                                      },
                                      child: Container(
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(31)),
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
                                                      borderRadius:
                                                          BorderRadius.only(
                                                              bottomLeft: Radius
                                                                  .circular(21),
                                                              topLeft: Radius
                                                                  .circular(21),
                                                              topRight:
                                                                  Radius.zero,
                                                              bottomRight:
                                                                  Radius.zero)),
                                                  child: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.only(
                                                            bottomLeft:
                                                                Radius.circular(
                                                                    21),
                                                            topLeft:
                                                                Radius.circular(
                                                                    21),
                                                            topRight:
                                                                Radius.zero,
                                                            bottomRight:
                                                                Radius.zero),
                                                    child: Image(
                                                        fit: BoxFit.fill,
                                                        image: NetworkImage(
                                                            // '$StoryPhoto'
                                                            'https://i.pinimg.com/originals/1d/05/dd/1d05ddd65c7ebceb5db020720d72af93.jpg')),
                                                  ),
                                                ),
                                              ),
                                              SizedBox(width: 2.3),
                                              Expanded(
                                                flex: 281,
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                      color: Color(0xFFC8FDE2),
                                                      borderRadius:
                                                          BorderRadius.only(
                                                              bottomRight:
                                                                  Radius
                                                                      .circular(
                                                                          31),
                                                              topRight: Radius
                                                                  .circular(31),
                                                              topLeft:
                                                                  Radius.zero,
                                                              bottomLeft:
                                                                  Radius.zero)),
                                                  width: 235,
                                                  child: Column(
                                                    children: [
                                                      SizedBox(height: 2),
                                                      Center(
                                                        child: Text(
                                                          snapshot
                                                              .data.docs[index]
                                                              .data()['title']
                                                              .toString(),
                                                          style: (GoogleFonts
                                                              .alegreya(
                                                            fontWeight:
                                                                FontWeight.w800,
                                                            fontSize: 20,
                                                            fontStyle: FontStyle
                                                                .italic,
                                                          )),
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        height: 6.2,
                                                      ),
                                                      Text(
                                                          snapshot
                                                              .data.docs[index]
                                                              .data()[
                                                                  'description']
                                                              .toString(),
                                                          style: (GoogleFonts
                                                              .averiaSansLibre())),
                                                      SizedBox(height: 9.8),
                                                      Row(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .end,
                                                        children: [
                                                          Text('~ '),
                                                          Text(
                                                              'BY BAL KRISHNA ',
                                                              style: (GoogleFonts
                                                                  .aladin(
                                                                      fontSize:
                                                                          17))),
                                                          SizedBox(width: 3),
                                                          ClipRRect(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        25),
                                                            child:
                                                                GestureDetector(
                                                              onTap: () {},
                                                              child:
                                                                  CircleAvatar(
                                                                radius: 25,

                                                                backgroundImage:
                                                                    NetworkImage(
                                                                  '$StoryUserPhoto',
                                                                ),
                                                                // NetworkImage(
                                                                //     'https://th.bing.com/th/id/OIP.UXYbDCut5tm5Qa6cYKxd4QHaHa?pid=Api&w=480&h=480&rs=1'),
                                                              ),
                                                            ),
                                                          )
                                                        ],
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              )
                                            ],
                                          ))),
                                ),
                              );
                            }),
                      );
                    } else if (snapshot.connectionState ==
                        ConnectionState.none) {
                      return Text("No data");
                    }
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<QuerySnapshot> LoadUserStories() async {
    return await firestore
        .collection('Stories')
        .where('UserID', isEqualTo: widget.StoryUserID)
        .get();
  }
}
