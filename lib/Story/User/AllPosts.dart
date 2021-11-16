import 'package:Kahani_App/Story/Story/StoryRead.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import '../../main.dart';
import 'UserViewer.dart';
// import 'package:razorpay_flutter/razorpay_flutter.dart';

class AllPosts extends StatefulWidget {
  final Future<QuerySnapshot> future;
  final String StoryUserID;

  final String StoryUserName;
  final String StoryUserPhoto;
  final String UserEmail;
  final String UserID;
  final String UserName;
  final String UserPhoto;
  final bool
      AllPosts1; // CHECK IF THE FUTURE IS FOR ALL POSTS OF USER OR JUST FOR "RECENT READS"
  AllPosts(
      {this.future,
      this.UserEmail,
      this.UserID,
      this.UserName,
      this.UserPhoto,
      this.StoryUserID,
      this.StoryUserName,
      this.StoryUserPhoto,
      this.AllPosts1});
  @override
  _AllPostsState createState() => _AllPostsState();
}

class _AllPostsState extends State<AllPosts> {
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
        child: Container(
          child: FutureBuilder(
            future: widget.future,
            builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              }
              return widget.AllPosts1 == false
                  ? ListView.builder(
                      itemBuilder: (BuildContext context, int index) {
                        int Rating = snapshot.data.docs[index].data()['Rating'];
                        String Views = NumberFormat.compactCurrency(
                          decimalDigits: 0,
                          symbol:
                              '', // if you want to add currency symbol then pass that in this else leave it empty.
                        ).format(snapshot.data.docs[index].data()['Views']);
                        AverageTime =
                            snapshot.data.docs[index].data()['Average Time'];
                        List Description =
                            snapshot.data.docs[index].data()['Description'];
                        return TextButton(
                          onPressed: () async {
                            String Story =
                                snapshot.data.docs[index].data()['Story'];

                            DocumentReference doc =
                                stories.doc(snapshot.data.docs[index].id);
                            String doc2 = doc.id;
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => StoryRead(
                                  TitleImage: snapshot.data.docs[index]
                                      .data()['TitleImage'],
                                  StoryUserPhoto: snapshot.data.docs[index]
                                      .data()['UserPhoto'],
                                  DocID: doc2,
                                  Title: snapshot.data.docs[index]
                                      .data()['Title']
                                      .toString(),
                                  Author: snapshot.data.docs[index]
                                      .data()['UserName']
                                      .toString(),
                                  Story: Story.split('< NEW PART BEGINS >'),
                                  Characters: snapshot.data.docs[index]
                                      .data()['Characters'],
                                  StoryUserID: snapshot.data.docs[index]
                                      .data()['UserID'],
                                ),
                              ),
                            );
                            DocumentSnapshot viewers = await FirebaseFirestore
                                .instance
                                .collection('Stories')
                                .doc(doc2)
                                .collection('UsersViewed')
                                .doc(UserID)
                                .get();

                            // setState(() {
                            //   Viewers = viewers;
                            // });

                            if (viewers.exists == false) {
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
                            }
                          },
                          child: Card(
                            margin: EdgeInsets.all(0),
                            child: Container(
                              height: 452,
                              width: 252,
                              child: Column(
                                children: [
                                  Container(
                                    height: 175,
                                    width: 252,
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                          image: NetworkImage(
                                            snapshot.data.docs[index]
                                                .data()['TitleImage'],
                                          ),
                                          fit: BoxFit.fill),
                                    ),
                                  ),
                                  SizedBox(height: 7),
                                  Padding(
                                    padding: EdgeInsets.only(left: 8, right: 8),
                                    child: Text(
                                        snapshot.data.docs[index]
                                            .data()['Title'],
                                        style: GoogleFonts.ptSansNarrow(
                                            fontSize: 19,
                                            fontWeight: FontWeight.w400)),
                                  ),
                                  SizedBox(height: 4),
                                  Padding(
                                    padding: EdgeInsets.only(left: 8, right: 8),
                                    child: Row(
                                      // mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Text('$Views Views',
                                            style: TextStyle(
                                              fontFamily: 'Ebrima',
                                              color: Color(0xff707070),
                                              fontSize: 16,
                                              fontWeight: FontWeight.w400,
                                              fontStyle: FontStyle.normal,
                                            )),
                                        Spacer(),
                                        Text('5 mins read',
                                            style: TextStyle(
                                              fontFamily: 'Ebrima',
                                              color: Color(0xff707070),
                                              fontSize: 16,
                                              fontWeight: FontWeight.w400,
                                              fontStyle: FontStyle.normal,
                                            )),
                                        Spacer(),
                                        Row(
                                          textBaseline:
                                              TextBaseline.ideographic,
                                          children: [
                                            Text('$Rating',
                                                style: TextStyle(
                                                  fontFamily: 'Ebrima',
                                                  color: Color(0xff707070),
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w400,
                                                  fontStyle: FontStyle.normal,
                                                )),
                                            Icon(Icons.star_rate_rounded),
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                  Container(
                                    child: Padding(
                                      padding: EdgeInsets.only(
                                          top: 5, bottom: 4, left: 8, right: 8),
                                      child: Text(Description.join(' '),
                                          style: GoogleFonts.ptSerif(
                                              fontWeight: FontWeight.w500)),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                      itemCount: snapshot.data.docs.length,
                      scrollDirection: Axis.vertical,
                    )
                  : ListView.builder(
                      // gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      //     crossAxisCount: 2),
                      itemCount: snapshot.data.docs.length,
                      itemBuilder: (BuildContext context, int index) {
                        String TitleImage =
                            snapshot.data.docs[index].data()['TitleImage'];
                        String Title =
                            snapshot.data.docs[index].data()['Title'];
                        String Story =
                            snapshot.data.docs[index].data()['Story'];
                        String StoryUserPhoto =
                            snapshot.data.docs[index].data()['UserPhoto'];
                        String StoryUserName =
                            snapshot.data.docs[index].data()['UserName'];
                        String StoryUserID =
                            snapshot.data.docs[index].data()['UserID'];
                        DocumentReference doc =
                            stories.doc(snapshot.data.docs[index].id);
                        String doc2 = doc.id;
                        return TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => StoryRead(
                                    TitleImage: TitleImage,
                                    StoryUserPhoto: StoryUserPhoto,
                                    DocID: doc2,
                                    Title: Title,
                                    Author: StoryUserName,
                                    Story: Story.split('< NEW PART BEGINS >'),
                                    // Characters: snapshot.data.docs[index]
                                    //     .data()['Characters'],
                                    StoryUserID: StoryUserID,
                                  ),
                                ),
                              );
                            },
                            child: Card(
                              child: Column(
                                children: [
                                  Container(
                                    height: MediaQuery.of(context).size.height,
                                    width: MediaQuery.of(context).size.width,
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                        fit: BoxFit.fill,
                                        image: NetworkImage(TitleImage),
                                      ),
                                    ),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        GestureDetector(
                                            child: Icon(Icons.info),
                                            onTap: () {
                                              Details(context, 'HELLO THERE',
                                                  '2.24M', 5);
                                            })
                                      ],
                                    ),
                                  ),
                                  Container(
                                    height: 25,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(Title),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ));
                      },
                    );
            },
          ),
        ),
      ),
    );
  }

  LoadUserData() {
    Box UserData = Hive.box('UserData');
    UserEmail = UserData.get('UserEmail');
    UserPhoto = UserData.get('UserPhoto');
    UserName = UserData.get('UserName');
    UserID = UserData.get('UserID');
  }

  Future<QuerySnapshot> LoadArticles() async {
    return await firestore.collection('Articles').get();
  }

  Future<QuerySnapshot> LoadUsers() async {
    return await firestore.collection('Users').get();
  }

  Future<QuerySnapshot> LoadArticlesPopularTrending(String index) async {
    return await firestore
        .collection('Articles')
        //  .where('Tag', arrayContains: StoryTags[index])
        // .where(
        //   'Time',
        //   isGreaterThanOrEqualTo: DateTime.now().subtract(
        //     Duration(hours: 1200),
        //   ),
        // )
        // .orderBy('Views')
        .get();
  }
}

Widget Details(
    BuildContext context, String Description, String Views, int Rating) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Center(
        child: SingleChildScrollView(
          child: AlertDialog(
            content: ListBody(
              children: <Widget>[
                TextButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              // builder: (context) => SelectPlan()
                              ));
                    },
                    child: Text('Promote')),
                SizedBox(
                  height: 11,
                ),
                TextButton(onPressed: () {}, child: Text('Delete')),
                TextButton(onPressed: () {}, child: Text('Edit')),
                TextButton(
                    onPressed: () {}, child: Text('Pin as Channel Post')),
                TextButton(onPressed: () {}, child: Text('Hide')),
                TextButton(
                    onPressed: () {
                      Options(context, Description, Views, Rating);
                    },
                    child: Text('See Details')),
              ],
            ),
          ),
        ),
      );
    },
  );
}

Widget Options(
  BuildContext context,
  String Description,
  String Views,
  int Rating,
) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Center(
        child: SingleChildScrollView(
          child: AlertDialog(
            content: ListBody(
              children: <Widget>[
                Text(Description),
                SizedBox(
                  height: 11,
                ),
                Text('Views : $Views'),
                Text('Rating : $Rating'),
                // Text('Uploaded on : $Time'),
              ],
            ),
          ),
        ),
      );
    },
  );
}
