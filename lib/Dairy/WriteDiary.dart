import 'dart:io';
import 'package:Kahani_App/Dairy/AllDiaries.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_rounded_date_picker/rounded_picker.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:image_picker/image_picker.dart';
import '../main.dart';

List AllImages = [];

class WriteDiary extends StatefulWidget {
  WriteDiary(
      {this.UserEmail, this.UserID, this.UserName, this.UserPhoto, this.title});

  String title;
  final String UserEmail;
  final String UserID;
  final String UserName;
  final String UserPhoto;

  @override
  _WriteDiaryState createState() => _WriteDiaryState();
}

class _WriteDiaryState extends State<WriteDiary> {
  TextEditingController c1 = TextEditingController();
  TextEditingController c2 = TextEditingController();
  TextEditingController c3 = TextEditingController();
  double DayRating;
  String Diary;
  String ImageLink;
  ImagePicker imagePicker = ImagePicker();
  PickedFile imageSelected;
  List TimeToShow;
  String TimeSelected;
  String Title;
  String UserEmail;
  String UserID;
  String UserName;
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

  // Future GetImage(String WhichImage) async {
  //   WhichImage == 'gallery'
  //       ? imageSelected = await imagePicker.getImage(
  //           source: ImageSource.gallery,
  //           imageQuality: 100,
  //           maxHeight: 1500,
  //           maxWidth: 1500)
  //       : imageSelected = await imagePicker.getImage(
  //           source: ImageSource.camera,
  //           imageQuality: 100,
  //           maxHeight: 1500,
  //           maxWidth: 1500);

  //   await storage
  //       .ref()
  //       .child(UserID)
  //       .child('DiaryImages')
  //       .child(imageSelected.path)
  //       .putFile(File(imageSelected.path))
  //       .onComplete
  //       .then((value) async {
  //     String link = await value.ref.getDownloadURL();
  //     print(link);
  //     List a = AllImages;
  //     a.add(link);
  //     setState(() {
  //       AllImages = a;
  //     });
  //   });
  // }

  Widget image(index) {
    return Container(
      height: 140,
      width: 100,
      decoration: BoxDecoration(
          image: DecorationImage(
              image: NetworkImage(AllImages.asMap()[index]), fit: BoxFit.fill)),
    );
  }

  LoadUserData() {
    Box UserData = Hive.box('UserData');
    UserEmail = UserData.get('UserEmail');
    UserPhoto = UserData.get('UserPhoto');
    UserName = UserData.get('UserName');
    UserID = UserData.get('UserID');
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      color: Colors.white,
      debugShowCheckedModeBanner: false,
      home: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            leading: GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AllDiaries(
                              UserEmail: UserEmail,
                              UserID: UserID,
                              UserName: UserName,
                              UserPhoto: UserPhoto,
                            )));
                // Navigator.pop(context);
              },
              child: Icon(
                Icons.arrow_back_ios,
                color: Colors.black,
              ),
            ),
            title: Center(
              child: Text(
                'Write Your Diary         ',
                style: GoogleFonts.saira(
                    fontSize: 25,
                    fontWeight: FontWeight.w600,
                    color: Colors.black),
              ),
            ),
            elevation: 0,
            backgroundColor: Colors.transparent,
            actions: [
              GestureDetector(
                onTap: () {
                  AllImages.length < 6
                      ? showModalBottomSheet(
                          context: context,
                          builder: (BuildContext bc) {
                            return Container(
                              child: Wrap(
                                children: <Widget>[
                                  FlatButton(
                                    padding: EdgeInsets.fromLTRB(11, 11, 0, 0),
                                    child: ListTile(
                                      leading: SvgPicture.asset(
                                        'Icons/gallery.svg',
                                        height: 40,
                                        width: 22,
                                      ),
                                      title: Text('Gallery'),
                                    ),
                                    onPressed: () {
                                      Navigator.pop(context);
                                      // GetImage('gallery');
                                    },
                                  ),
                                  FlatButton(
                                    padding: EdgeInsets.fromLTRB(11, 11, 0, 0),
                                    child: ListTile(
                                      leading: SvgPicture.asset(
                                        'Icons/camera.svg',
                                        height: 40,
                                        width: 22,
                                      ),
                                      title: Text('Camera'),
                                    ),
                                    onPressed: () {
                                      Navigator.pop(context);
                                      // GetImage('camera');
                                    },
                                  ),
                                  FlatButton(
                                    padding: EdgeInsets.fromLTRB(11, 0, 0, 11),
                                    onPressed: () {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return Center(
                                            child: SingleChildScrollView(
                                              child: AlertDialog(
                                                title: Center(
                                                  child: Text(
                                                      'Give An Image Link'),
                                                ),
                                                content: ListBody(
                                                  children: <Widget>[
                                                    Center(
                                                      child: TextFormField(
                                                        onChanged: (value) {
                                                          setState(() {
                                                            ImageLink = value;
                                                          });
                                                        },
                                                        decoration:
                                                            InputDecoration(
                                                          fillColor: Colors
                                                                  .lightBlueAccent[
                                                              400],
                                                          focusedBorder:
                                                              OutlineInputBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        20.0),
                                                            borderSide:
                                                                BorderSide(
                                                              width: 1.5,
                                                              color: Colors
                                                                  .blue[300],
                                                            ),
                                                          ),
                                                          enabledBorder:
                                                              OutlineInputBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        20.0),
                                                            borderSide:
                                                                BorderSide(
                                                              color: Colors
                                                                      .lightBlue[
                                                                  200],
                                                              width: 1.4,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    Center(
                                                      child: FlatButton(
                                                        onPressed: () {
                                                          setState(
                                                            () {
                                                              AllImages.add(
                                                                  ImageLink);
                                                            },
                                                          );
                                                        },
                                                        child: Text('Submit'),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                      );
                                    },
                                    child: ListTile(
                                      leading: SvgPicture.asset(
                                        'Icons/folder.svg',
                                        height: 40,
                                        width: 20,
                                      ),
                                      title: Text('Network Image'),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          })
                      : showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return Center(
                              child: SingleChildScrollView(
                                child: AlertDialog(
                                  title: Center(
                                    child: Text('ERROR!!'),
                                  ),
                                  content: ListBody(
                                    children: <Widget>[
                                      Center(
                                        child: Text(
                                            'SORRY , YOU CAN ADD ONLY 6 IMAGES '),
                                      ),
                                    ],
                                  ),
                                  actions: [
                                    FlatButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: Text('OK'))
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                },
                child: Icon(
                  Icons.photo,
                  color: Colors.black,
                  size: 26,
                ),
              ),
              SizedBox(
                width: 11,
              ),
              GestureDetector(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return Center(
                        child: SingleChildScrollView(
                          child: AlertDialog(
                            elevation: 0,
                            contentPadding: EdgeInsets.fromLTRB(24, 20, 24, 0),
                            backgroundColor: Colors.white,
                            title: Center(
                              child: Text('How Was The Day',
                                  style: TextStyle(color: Colors.black)),
                            ),
                            content: ListBody(
                              children: <Widget>[
                                SizedBox(
                                  height: 10,
                                ),
                                GestureDetector(
                                  child: Container(
                                      height: 75,
                                      width: 100,
                                      child: Text('Time')),
                                  onTap: () {
                                    showRoundedDatePicker(
                                      context: context,
                                      initialDate: DateTime.now(),
                                      firstDate:
                                          DateTime(DateTime.now().year - 60),
                                      lastDate:
                                          DateTime(DateTime.now().year + 60),
                                      borderRadius: 16,
                                    );
                                  },
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Center(
                                  child: RatingBar(
                                    unratedColor: Colors.grey[700],
                                    glow: false,
                                    initialRating: 0,
                                    itemCount: 5,
                                    ratingWidget: RatingWidget(
                                        full: Container(),
                                        half: Container(),
                                        empty: Container()),
                                    // itemBuilder: (context, index) {
                                    //   switch (index) {
                                    //     case 0:
                                    //       return Icon(
                                    //         Icons.sentiment_very_dissatisfied,
                                    //         color: Colors.red,
                                    //       );
                                    //     case 1:
                                    //       return Icon(
                                    //         Icons.sentiment_dissatisfied,
                                    //         color: Colors.redAccent,
                                    //       );
                                    //     case 2:
                                    //       return Icon(
                                    //         Icons.sentiment_neutral,
                                    //         color: Colors.amber,
                                    //       );
                                    //     case 3:
                                    //       return Icon(
                                    //         Icons.sentiment_satisfied,
                                    //         color: Colors.lightGreen,
                                    //       );
                                    //     case 4:
                                    //       return Icon(
                                    //         Icons.sentiment_very_satisfied,
                                    //         color: Colors.green,
                                    //       );
                                    //   }
                                    // },
                                    onRatingUpdate: (rating) {
                                      setState(() {
                                        DayRating = rating;
                                      });
                                    },
                                  ),
                                ),
                              ],
                            ),
                            actions: [
                              FlatButton(
                                  onPressed: () async {},
                                  child: Text('NEXT LOL '))
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
                child: Icon(
                  Icons.done,
                  size: 30,
                  color: Colors.black,
                ),
              ),
              SizedBox(
                width: 8,
              )
            ],
          ),
          body: SingleChildScrollView(
            child: Container(
              height: MediaQuery.of(context).size.height,
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  // Container(
                  //   width: 237,
                  //     use24HourFormat: false,
                  //     type: DateTimePickerType.dateTime,
                  //     dateMask: 'dd/mm/yy  h:mm',
                  //     controller: c1,
                  //     firstDate: DateTime(2000),
                  //     lastDate: DateTime(2051),
                  //     icon: Icon(Icons.event),
                  //     onChanged: (val) => setState(() => TimeSelected = val),
                  //     validator: (val) {
                  //       setState(() => TimeSelected = val);
                  //     },
                  //     onSaved: (val) => setState(() => TimeSelected = val),
                  //   ),
                  // ),

                  // SizedBox(height: 22),
                  Container(
                    child: TextFormField(
                      minLines: 1,
                      maxLines: 5,
                      autofocus: true,
                      controller: c2,
                      decoration: InputDecoration(
                        hintText: "Title or A Small Summary",
                        hintStyle: GoogleFonts.sansita(),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            style: BorderStyle.none,
                            width: 0,
                            color: Colors.white,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          // borderRadius: BorderRadius.circular(20.0),
                          borderSide: BorderSide(
                            color: Colors.white,
                            style: BorderStyle.none,
                            width: 0,
                          ),
                        ),
                      ),
                      onChanged: (value) {
                        setState(() {
                          Title = value;
                        });
                      },
                    ),
                  ),
                  TextField(
                    style: TextStyle(color: Colors.black, fontSize: 18),
                    maxLines: null,
                    controller: c1,
                    minLines: 20,
                    onChanged: (value) {
                      setState(() {
                        Diary = value;
                      });
                    },
                    decoration: InputDecoration(
                      hintText: 'Write Your Diary',
                      hintStyle: GoogleFonts.sansita(fontSize: 18),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          style: BorderStyle.none,
                          width: 0,
                          color: Colors.white,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        // borderRadius: BorderRadius.circular(20.0),
                        borderSide: BorderSide(
                          color: Colors.white,
                          style: BorderStyle.none,
                          width: 0,
                        ),
                      ),
                    ),
                  ),
                  // SizedBox(height: 40),
                  // Text(
                  //   'Rate Your Day!',
                  //   style: TextStyle(color: Colors.white),
                  // ),

                  AllImages.isEmpty
                      ? Container()
                      : Container(
                          child: Column(
                            children: [
                              AllImages.asMap()[0] != null
                                  ? Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        AllImages.asMap()[0] != null
                                            ? image(0)
                                            : Container(),
                                        AllImages.asMap()[1] != null
                                            ? image(1)
                                            : Container(),
                                        AllImages.asMap()[2] != null
                                            ? image(2)
                                            : Container()
                                      ],
                                    )
                                  : Container(
                                      height: 0,
                                      width: 0,
                                    ),
                              AllImages.asMap()[0] != null
                                  ? Row(
                                      children: [
                                        AllImages.asMap()[3] != null
                                            ? image(3)
                                            : Container(),
                                        AllImages.asMap()[4] != null
                                            ? image(4)
                                            : Container(),
                                        AllImages.asMap()[5] != null
                                            ? image(5)
                                            : Container()
                                      ],
                                    )
                                  : Container(
                                      height: 0,
                                      width: 0,
                                    ),
                            ],
                          ),
                        )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  UploadToFiretore() async {
    await firestore
        .collection('Users')
        .doc(UserID)
        .collection('Diaries')
        .doc()
        .set({
      'Day': 'Thursday',
      'Year': 2020,
      'Date': 12,
      'Month': 'June',
      'Rating': DayRating,
      'Diary': Diary.split(' '),
      'Title': Title,
      'Images': AllImages.asMap(),
      'Tags': {'Laptop', 'Study', 'Book'}
    });
  }
}
