import 'package:Kahani_App/Story/Story/StoryWorkspace.dart';
import 'package:Kahani_App/Widgets/FBuilder.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

void WriteStory(BuildContext context, String UserID) {
  showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return Container(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
        GestureDetector(
                
                onTap: () {
                  pushNewScreen(context,
                      screen: StoryWorkspace(), withNavBar: false);
                },
                child: Row(
                  children: [
                    Icon(Icons.add),
                    SizedBox(width: 10),
                    Text('Or Write A Brand New Story')
                  ],
                ),
              ),      Container(
                height: 120,
                child: LoadStoryDrafts(LoadDraft(UserID)),
              ),
              
            ],
          ),
        );
      });
}

Future<QuerySnapshot> LoadDraft(String UserID) async {
  return await FirebaseFirestore.instance
      .collection('Users')
      .doc(UserID)
      .collection('StoriesDraft')
      .limit(6)
      .get();
}
