import 'package:Kahani_App/Login/UpdateProfile.dart';
import 'package:Kahani_App/Story/Story/StoryPosts.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import '../main.dart';

final FirebaseAuth auth = FirebaseAuth.instance;
final GoogleSignIn googleSignIn = GoogleSignIn();

class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  String UserEmail;
  String UserID;
  String UserName;
  String UserNameFromFirestore;
  String UserPhoto;
  String UserPhotoFromFirestore;
  List ArticleInterests;
  bool DiaryHasPassword;
  bool AskToSetPassword;
  bool ArticleInterestsSelected;

  UserData() async {
    var UserData = await firestore.collection('Users').doc(UserID).get();
    UserNameFromFirestore = UserData.data()['UserName'];
    UserPhotoFromFirestore = UserData.data()['UserPhoto'];
  }

  LoginIcons(String LoginCompany, double font) {
    return Row(
      children: [
        SizedBox(
          width: 6,
        ),
        SvgPicture.asset(
          'Icons/$LoginCompany.svg',
          height: font,
        ),
        SizedBox(
          width: 6,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      height: double.infinity,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          SizedBox(
            height: 35,
          ),
          SvgPicture.asset(
            'Icons/Google.svg',
            height: 160,
          ),
          Container(
            padding: EdgeInsets.all(0),
            alignment: Alignment.center,
            child: Text(
              "Login To The StoryART",
              style:
                  GoogleFonts.mukta(fontSize: 36, fontWeight: FontWeight.w600),
            ),
          ),
          Container(
            padding: EdgeInsets.all(0),
            alignment: Alignment.center,
            child: Text(
              "Explore the Writing World",
              style: GoogleFonts.mukta(fontSize: 25),
            ),
          ),
          SizedBox(
            height: 156,
          ),
          GestureDetector(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  LoginIcons('Google', 40),
                  SizedBox(
                    width: 26,
                  ),
                  Text(
                    'Login With Google',
                    style: GoogleFonts.yanoneKaffeesatz(fontSize: 36),
                  )
                ],
              ),
              onTap: () async {
                await Firebase.initializeApp();
                print('Process 1 Completed');
                GoogleSignInAccount googleSignInAccount =
                    await googleSignIn.signIn();
                print('Process 2 Completed');
                GoogleSignInAuthentication googleSignInAuthentication =
                    await googleSignInAccount.authentication;
                print('Process 3 Completed');
                AuthCredential credential = GoogleAuthProvider.credential(
                    idToken: googleSignInAuthentication.idToken,
                    accessToken: googleSignInAuthentication.accessToken);
                print('Process 4 Completed');
                print(credential);
                final authResult = await auth.signInWithCredential(credential);
                print('Process 5 Completed');
                final User user = authResult.user;
                print('Process 6 Completed');
                assert(!user.isAnonymous);
                print('Process 7 Completed');
                assert(await user.getIdToken() != null);
                print('Process 8 Completed');

                final User currentUser = auth.currentUser;
                print('Process 9 Completed');
                assert(currentUser.uid == user.uid);
                print('Process 10 Completed');
                UserID = user.uid;
                print(UserID);
                UserName = user.displayName;
                UserPhoto = user.photoURL;
                UserEmail = user.email;
                UserData();
                // * FOR Password Less Logins
                Box GoogleLogins = Hive.box('AllGoogleLogins');
                List data = GoogleLogins.get(UserID);
                if (data == null) {
                  GoogleLogins.put(UserID, UserEmail);
                }
                //  *TILL HERE
                if (UserNameFromFirestore == null) {
                  Box UserData = Hive.box('UserData');

                  UserData.put('UserID', UserID);
                  UserData.put('UserName', UserName);
                  UserData.put('UserEmail', UserEmail);
                  UserData.put('UserPhoto', UserPhoto);
                  UserData.put('DiaryHasPassword', false);
                  UserData.put('AskToSetPassword', true);
                  UserData.put('ArticleInterestsSelected', false);

                  await firestore.collection('Users').doc(UserID).set({
                    'UserEmail': UserEmail,
                    'UserName': UserName,
                    'UserID': UserID,
                    'UserPhoto': UserPhoto,
                    'MonthlyViews': 0,
                    'TotalViews': 0,
                    'TimeCreated': DateTime.now(),
                    'LessAds': false,
                    '50%AdFree': false,
                    'TotalAdFree': false,
                    'ChatEnabled': false,
                    'ArticleInterestsSelected': false
                  }).then(
                    (user) => Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => UpdateProfile(),
                      ),
                    ),
                  );
                } else {
                  Box UserData = Hive.box('UserData');

                  UserData.put('UserID', UserID);
                  UserData.put('UserName', UserNameFromFirestore);
                  UserData.put('UserEmail', UserEmail);
                  UserData.put('UserPhoto', UserPhotoFromFirestore);
                  if (ArticleInterests == null) {
                    UserData.put('ArticleInterests', ArticleInterests);
                  }
                  UserData.put('DiaryHasPassword',
                      DiaryHasPassword == true ? true : false);
                  UserData.put('AskToSetPassword',
                      AskToSetPassword == true ? true : false);
                  UserData.put('ArticleInterestsSelected',
                      ArticleInterestsSelected == true ? true : false);

                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => StoryPosts(),
                    ),
                  );
                }
              }),
          Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              LoginIcons('Email', 42),
              GestureDetector(
                child: LoginIcons('Facebook', 49),
                onTap: () async {},
              ),
              // LoginIcons('Facebook', 49),
              LoginIcons('Microsoft', 45),
            ],
          ),
          SizedBox(
            height: 50,
          )
        ],
      ),
    ));
  }
}
