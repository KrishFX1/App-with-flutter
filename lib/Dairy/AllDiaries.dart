import 'package:Kahani_App/Dairy/ShowDiary.dart';
import 'package:Kahani_App/Dairy/WriteDiary.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../main.dart';

bool DiaryData;

class AllDiaries extends StatefulWidget {
  final String UserName;
  final String UserID;
  final String UserEmail;
  final String UserPhoto;

  AllDiaries({this.UserEmail, this.UserID, this.UserName, this.UserPhoto});
  @override
  _AllDiariesState createState() => _AllDiariesState();
}

class _AllDiariesState extends State<AllDiaries> {
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

  String UserName;
  String UserPhoto;
  String UserEmail;
  String UserID;
  String DiaryTitle;
  Timestamp Time;
  String Diary;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        elevation: 0,
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => WriteDiary(
                UserEmail: UserEmail,
                UserID: UserID,
                UserName: UserName,
                UserPhoto: UserPhoto,
              ),
            ),
          );
        },
      ),
      body: SafeArea(
        child: Container(
            child: DiaryData == false
                ? FutureBuilder(
                    future: LoadDiaries(),
                    builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        return ListView.builder(
                            itemCount: snapshot.data.docs.length,
                            itemBuilder: (BuildContext context, int index) {
                              String DiaryTitle =
                                  snapshot.data.docs[index].data()['Title'];
                              String Diary =
                                  snapshot.data.docs[index].data()['Diary'];
                              int Date =
                                  snapshot.data.docs[index].data()['Date'];
                              String Month =
                                  snapshot.data.docs[index].data()['Month'];
                              int Year =
                                  snapshot.data.docs[index].data()['Year'];
                              List AllImages =
                                  snapshot.data.docs[index].data()['Images'];
                              String Day =
                                  snapshot.data.docs[index].data()['Day'];
                              int Rating =
                                  snapshot.data.docs[index].data()['Rating'];
                              List Tags =
                                  snapshot.data.docs[index].data()['Tags'];
                              return Card(
                                child: Column(
                                  children: [
                                    FlatButton(
                                        padding: EdgeInsets.all(0),
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => ShowDiary(
                                                Diary: Diary,
                                                Day: Day,
                                                DiaryTitle: DiaryTitle,
                                                Date: Date,
                                                Month: Month,
                                                Year: Year,
                                                AllImages: AllImages,
                                                Rating: Rating,
                                                Tags: Tags,
                                              ),
                                            ),
                                          );
                                        },
                                        child: Container(
                                          width:
                                              MediaQuery.of(context).size.width,
                                          decoration: BoxDecoration(
                                            color: Color(0xfffefff7),
                                          ),
                                          child: Padding(
                                            padding: EdgeInsets.fromLTRB(
                                                33, 13, 0, 0),
                                            child: Column(
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Row(
                                                      children: [
                                                        Text('$Rating'),
                                                        Icon(
                                                          Icons.star_rate,
                                                          size: 18,
                                                        )
                                                      ],
                                                    ),
                                                    Text(
                                                      "$Date $Month $Year",
                                                      style: TextStyle(
                                                        fontFamily: 'SegoeUI',
                                                        color:
                                                            Color(0xff831a71),
                                                        fontSize: 15,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        fontStyle:
                                                            FontStyle.normal,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Text(
                                                  DiaryTitle,
                                                ),
                                                Container(
                                                    decoration: BoxDecoration(
                                                        color:
                                                            Colors.yellow[500],
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(25)),
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              11.0),
                                                      child: Text(
                                                          '   ${Tags.asMap()[0]}'),
                                                    )),
                                                Container(
                                                    decoration: BoxDecoration(
                                                        color:
                                                            Colors.yellow[500],
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(25)),
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              11.0),
                                                      child: Text(
                                                          '   ${Tags.asMap()[1]}'),
                                                    )),
                                                Container(
                                                    decoration: BoxDecoration(
                                                        color:
                                                            Colors.yellow[500],
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(25)),
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              11.0),
                                                      child: Text(
                                                          '   ${Tags.asMap()[2]}'),
                                                    )),
                                                Container(
                                                  height: 75,
                                                  width: 50,
                                                  decoration: BoxDecoration(
                                                      image: DecorationImage(
                                                          image: NetworkImage(
                                                              AllImages.asMap()[
                                                                  0]),
                                                          fit: BoxFit.fill)),
                                                )
                                              ],
                                            ),
                                          ),
                                        )),
                                  ],
                                ),
                              );
                            });
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
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Center(
                            child: Text('No Diary yet'),
                          )
                        ],
                      ),
                    ],
                  )),
      ),
    );
  }

  LoadUserData() {
    Box UserData = Hive.box('UserData');
    UserID = UserData.get('UserID');
  }

  Future<QuerySnapshot> LoadDiaries() async {
    QuerySnapshot data = await firestore
        .collection('Users')
        .doc(UserID)
        .collection('Diaries')
        .get();
    print(data);
    if (data != null) {
      DiaryData = true;
      return data;
    } else {
      DiaryData = false;
    }
  }
}
