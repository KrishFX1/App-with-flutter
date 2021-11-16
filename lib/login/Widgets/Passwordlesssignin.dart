import 'package:Kahani_App/other/Constantcolors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';

ConstantColors colors = ConstantColors();
Box GoogleLogins = Hive.box('AllGoogleLogins');
int BoxLength;  

PasswordLessSignIn(BuildContext context) {
  print(GoogleLogins.length);
  Map a = GoogleLogins.toMap();
  print(a);
  showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return Container(
          height: 300,
          color: colors.darkColor,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(height: 12),
              Text('One Tap Login',
                  style: GoogleFonts.roboto(fontSize: 26, color: Colors.white)),
              SizedBox(height: 25),
              Card(
                child: Column(
                  children: [
                    Text('Google Accounts'),
                    SizedBox(
                      height: 15,
                    ),

                    Container(
                      height: 200,
                      child: ListView.builder(
                          itemCount: BoxLength,
                          itemBuilder: (BuildContext context, int BoxLength) {
                            return Container();
                          }),
                    ),

                    // GestureDetector(
                    //   child: Text('Email : rajkrishna8060@gmail.com',
                    //       style: GoogleFonts.robotoSlab(
                    //           fontSize: 26, color: Colors.white)),
                    //   onTap: () {},
                    // ),
                  ],
                ),
              ),
              SizedBox(
                height: 35,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  RichText(
                    text: TextSpan(
                      children: <TextSpan>[
                        TextSpan(
                          text: 'Do You Want To Enable',
                          style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'AkayaTelivigala',
                              fontSize: 30),
                        ),
                        TextSpan(
                          text: ' Password Less Sign-In',
                          style: TextStyle(
                              fontFamily: 'AkayaTelivigala',
                              fontWeight: FontWeight.w700,
                              fontSize: 30,
                              color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 35,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    child: SvgPicture.asset('Icons/check.svg', height: 65),
                    onTap: () {},
                  ),
                  SizedBox(
                    width: 50,
                  ),
                  GestureDetector(
                    child: SvgPicture.asset('Icons/cross.svg', height: 65),
                    onTap: () {
                      Hive.box('AllUsersLoggedIn').close();
                    },
                  ),
                ],
              )
            ],
          ),
        );
      });
}
