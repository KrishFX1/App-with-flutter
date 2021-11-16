import 'package:Kahani_App/Story/Story/StoryPosts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import '../main.dart';

FirebaseAuth auth = FirebaseAuth.instance;
TextEditingController textEditingController = TextEditingController();

class UpdateProfile extends StatefulWidget {
  _UpdateProfileState createState() => _UpdateProfileState();
}

class _UpdateProfileState extends State<UpdateProfile> {
  String UserName;
  String UserID;
  String UserPhoto;
  String UserEmail;

  @override
  void initState() {
    GetUserData();
    super.initState();
  }

  String Name, AboutMe;
  Color red = Colors.black;
  Color red2 = Colors.red;
  String validate = '        Your Bio should Have atleast 10 letters';
  String validate1 = "         !! Your Bio Should be Atleast 15 letter long ";
  TextEditingController c1 = TextEditingController();

  @override
  Widget build(BuildContext context) {
    String helperText = validate;
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Center(child: Text('Complete Profile')),
        ),
        body: SingleChildScrollView(
          child: Container(
            child: Column(
              children: [
                SizedBox(
                  height: 39,
                ),
                TextField(
                  onChanged: (value) {
                    setState(() {
                      Name = value;
                    });
                  },
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.account_circle),
                    labelText: "     Enter Your Name",
                    fillColor: Colors.white,
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0),
                      borderSide: BorderSide(
                        width: 1.3,
                        color: Colors.blue[300],
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0),
                      borderSide: BorderSide(
                        color: Colors.lightBlue[200],
                        width: 2,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: c1,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.account_circle),
                    suffixText: c1.text.length.toString(),
                    suffixStyle: TextStyle(color: red2),
                    labelText: "     About Me",
                    labelStyle: TextStyle(color: red2),
                    fillColor: Colors.white,
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0),
                      borderSide: BorderSide(
                        width: 1.3,
                        color: Colors.blue[300],
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0),
                      borderSide: BorderSide(
                        color: Colors.lightBlue[200],
                        width: 2,
                      ),
                    ),
                  ),
                  onChanged: (value) {
                    setState(() {
                      AboutMe = value;

                      if (c1.text.length >= 10) {
                        red2 = Colors.black;
                      } else {
                        red2 = Colors.red;
                      }
                    });
                  },
                ),
                Text(
                  helperText,
                  style: GoogleFonts.almarai(fontSize: 19, color: red),
                ),
                SizedBox(height: 30),
                Container(
                  color: Colors.yellow[200],
                  height: 50,
                  width: 175,
                  child: FlatButton(
                    onPressed: () async {
                      if (c1.text.isEmpty) {
                        setState(() {
                          red = Colors.red;
                          helperText = "Your Bio Can't Be Empty";
                        });
                      } else if (AboutMe.length >= 10) {
                        Box UserData = Hive.box('UserData');
                        await Firebase.initializeApp();
                        firestore
                            .collection('Users')
                            .doc('$UserID')
                            .update({'name': Name, 'bio': AboutMe})
                            .then(
                              (value) => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => StoryPosts(
                                    UserName: Name,
                                    UserPhoto: UserPhoto,
                                    UserEmail: UserEmail,
                                    UserID: UserID,
                                  ),
                                ),
                              ),
                            )
                            .then((value) => UserData.put('Username', Name));
                      } else {
                        setState(() {
                          red = Colors.red;
                        });
                      }
                    },
                    child: Text(
                      'Submit',
                      style: TextStyle(fontSize: 17),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Center(
                  child: Text(
                    '-- OR --',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
                SizedBox(height: 17),
                Container(
                  color: Colors.lightBlueAccent[100],
                  width: 350,
                  child: GestureDetector(
                    onTap: () async {
                      if (c1.text.isEmpty) {
                        setState(() {
                          red = Colors.red;
                          helperText = "Your Bio Can't Be Empty";
                        });
                      } else if (AboutMe.length >= 10) {
                        await Firebase.initializeApp();
                        firestore
                            .collection('Users')
                            .doc('$UserID')
                            .update({'bio': AboutMe}).then(
                          (value) => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => StoryApp(),
                            ),
                          ),
                        );
                      } else {
                        setState(() {
                          red = Colors.red;
                        });
                      }
                    },
                    child: Center(
                      child: Container(
                        child: Column(
                          children: [
                            Center(
                                child: Text('Or Continue With LoggedIn Name')),
                            Center(child: Text('$UserName'))
                          ],
                        ),
                      ),
                    ),
                    // TO DO : NAME OF USER
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ignore: non_constant_identifier_names
  GetUserData() async {
    Box UserData = Hive.box('UserData');

    UserEmail = UserData.get('UserEmail');
    UserPhoto = UserData.get('UserPhoto');
    UserName = UserData.get('UserName');
    UserID = UserData.get('UserID');
  }
}
