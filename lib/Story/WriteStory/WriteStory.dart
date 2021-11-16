// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:quill_delta/quill_delta.dart';
// import 'package:zefyr/zefyr.dart';
// import '../../main.dart';

// ImagePicker imagePicker = ImagePicker();
// CollectionReference stories = firestore.collection('Stories');

// class WriteStory extends StatefulWidget {
// String Story;
// String Description;
// String Title;
// String TitleImage;
// String doc;
//   WriteStory({
//     this.Description,
//     this.Story,
//     this.Title,
//     this.TitleImage,
//     this.doc
//   })
//   @override
//   _WriteStoryState createState() => _WriteStoryState();
// }



// class _WriteStoryState extends State<WriteStory> {

//   ZefyrController zefyrController ;

//   @override
//   void initState() { 
//     super.initState();
//     Delta delta = Delta()..insert('\n');
//     zefyrController = ZefyrController(NotusDocument.fromDelta(delta));
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       resizeToAvoidBottomInset: false,
//       appBar: AppBar(
//          elevation: 0,
//         bottomOpacity: 0,
//         toolbarOpacity: 0,
//         actions: [
//           TextButton(onPressed: (){},child: Text('Images')),
//           Spacer(),
//           TextButton(onPressed: (){},child: Text('Next')),
//         ],
//       ),
//       body: SafeArea(),
//     )
//   }
// }