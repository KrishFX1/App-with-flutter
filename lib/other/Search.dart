import 'package:Kahani_App/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

String SearchText = '';

class Search extends StatefulWidget {
  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  @override
  void initState() {
    // prefs.setStringList('SearchTexts', ['KahaniApp']);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController c1 = TextEditingController();

    bool Searched = false;
    return Scaffold(
      body: SafeArea(
        child: Container(
          child: Column(
            children: [
              Row(
                children: [
                  Icon(Icons.arrow_back),
                  Expanded(
                    child: TextFormField(
                      // controller: c1,
                      textInputAction: TextInputAction.search,
                      onSaved: (value) {},
                      // onEditingComplete: () {

                      // if (SearchText.trim().isEmpty) {
                      // } else {

                      // print('hgsj');
                      // List a = prefs.getStringList('SearchTexts');
                      // a.add(SearchText);
                      // print(SearchText);
                      // print('hgsj22');
                      // print(prefs.getStringList('SearchTexts'));
                      // }
                      // },
                      keyboardType: TextInputType.name,
                      onChanged: (value) {
                        setState(() {
                          print(value);
                          SearchText = value;
                        });
                      },
                      decoration: InputDecoration(
                        suffix: IconButton(
                          icon: Icon(Icons.search),
                          onPressed: () {
                            setState(() {
                              Searched = true;
                            });
                            print(Searched);
                          },
                        ),
                        fillColor: Colors.grey[400],
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            width: 0.9,
                            color: Colors.black,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          // borderRadius:
                          //     BorderRadius.circular(20.0),
                          borderSide: BorderSide(
                            color: Colors.black,
                            width: 0.9,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Searched == false
                  ? Expanded(child: ListView.builder(
                      itemBuilder: (context, index) {
                        // return prefs.getStringList('SearchTexts').isNotEmpty  ?
                        //     Text(prefs.getStringList('SearchTexts')[index])
                        //     : Container();
                      },
                      // itemCount: prefs.getStringList('SearchTexts').length,
                    ))
                  : FutureBuilder(
                      future: GetSearchResults(),
                      builder:
                          (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                        return Expanded(
                          child: ListView.builder(
                            itemCount: snapshot.data.docs.length,
                            itemBuilder: (BuildContext context, int index) {
                              return Text(
                                  snapshot.data.docs[index].data()['UserName']);
                            },
                          ),
                        );
                      },
                    ),
            ],
          ),
        ),
      ),
    );
  }

  GetSearchResults() async {
    return await FirebaseFirestore.instance
        .collection('Stories')
        .where('Description', arrayContains: SearchText)
        .limit(50)
        .get();
  }
}
