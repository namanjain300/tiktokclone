import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'login_signup/services/authentication.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart';
import 'package:chewie/chewie.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key, this.auth, this.userId, this.logoutCallback})
      : super(key: key);

  final BaseAuth auth;
  final VoidCallback logoutCallback;
  final String userId;

  @override
  State<StatefulWidget> createState() => new _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String finalurl;
  File videoFile;
  String mypath;
  VideoPlayerController videoPlayerController;
  Future<void> _initializeVideoPlayerFuture;
  DatabaseReference databaseReference = FirebaseDatabase.instance.reference();
  FirebaseAuth auth = FirebaseAuth.instance;

  signOut() async {
    try {
      await widget.auth.signOut();
      widget.logoutCallback();
    } catch (e) {
      print(e);
    }
  }

  // void initState() {
  // _controller = VideoPlayerController.file(videoFile);
  //   _initializeVideoPlayerFuture = _controller.initialize();

  //   super.initState();
  // }

  // @override
  // void dispose() {
  //   _controller.dispose();
  //   super.dispose();
  // }}
//   final videoPlayerController = VideoPlayerController.network(
//     'https://flutter.github.io/assets-for-api-docs/videos/butterfly.mp4');

// final chewieController = ChewieController(
//   videoPlayerController: videoPlayerController,
//   aspectRatio: 3 / 2,
//   autoPlay: true,
//   looping: true,
// );

// final playerWidget = Chewie(
//   controller: chewieController,
// );

  @override
  void dispose() {
    videoPlayerController.dispose();
    // chewieController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Tiktok Clone'),
        actions: <Widget>[
          new FlatButton(
              child: new Text('Logout',
                  style: new TextStyle(fontSize: 17.0, color: Colors.white)),
              onPressed: signOut)
        ],
      ),
      bottomNavigationBar: Container(
          color: Colors.black,
          height: 50.0,
          child: IconButton(
              icon: Icon(
                FontAwesomeIcons.video,
                color: Colors.white,
                size: 35,
              ),
              onPressed: () async {
                File vid =
                    await ImagePicker.pickVideo(source: ImageSource.camera);
                if (vid != null) {
                  setState(() {
                    videoFile = vid;
                    print(videoFile);
                    videoPlayerController =
                        VideoPlayerController.file(videoFile);
                    _initializeVideoPlayerFuture =
                        videoPlayerController.initialize();
                  });
                }
              })),
      body: ListView(
        children: <Widget>[
          CupertinoAlertDialog(
            title: Text("Do you want to upload the Video?"),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: RaisedButton(
                child: Text("Upload"),
                onPressed: () async {
                  final StorageReference firebaseStorageRef = FirebaseStorage
                      .instance
                      .ref()
                      .child('my video files')
                      .child(basename(videoFile.path));
                  final StorageUploadTask task =
                      firebaseStorageRef.putFile(videoFile);
                  print(task);
                  await task.onComplete;
                  print("Uploaded");
                  final StorageTaskSnapshot downloadUrl =
                      (await task.onComplete);
                  final String url = (await downloadUrl.ref.getDownloadURL());
                  print('URL Is $url');
                  setState(() {
                    finalurl = url;
                  });
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
