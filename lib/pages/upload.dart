import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:instaapp/widgets/progress.dart';
import 'package:flutter_native_image/flutter_native_image.dart';

class Upload extends StatefulWidget {
  @override
  _UploadState createState() => _UploadState();
}

class _UploadState extends State<Upload> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Reference _firebaseStorage = FirebaseStorage.instance.ref();
  final _firebase = FirebaseFirestore.instance;

  TextEditingController captionConntroller = TextEditingController();
  TextEditingController locationConntroller = TextEditingController();

  ScaffoldFeatureController message({String message}) {
    final messenger = ScaffoldMessenger.of(context);
    return messenger.showSnackBar(SnackBar(content: Text(message)));
  }

  User _user;
  bool isUpload = false;

  @override
  void initState() {
    _user = _auth.currentUser;

    super.initState();
  }

  final picker = ImagePicker();
  File _image1;

  cameraUpload() async {
    Navigator.pop(context);
    final pickedFile = await picker.getImage(source: ImageSource.camera);

    setState(() {
      if (pickedFile != null) {
        _image1 = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  uploadimages() async {
    Navigator.pop(context);
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image1 = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  Widget slashUpload() {
    return Scaffold(
      backgroundColor: Theme.of(context).accentColor.withOpacity(0.1),
      body: SafeArea(
        child: Container(
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      scrollable: true,
                      title: Text('Create Post'),
                      content: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          TextButton.icon(
                            onPressed: cameraUpload,
                            icon: Icon(Icons.camera),
                            label: Text('Upload from Camera'),
                          ),
                          TextButton.icon(
                            onPressed: uploadimages,
                            icon: Icon(Icons.photo),
                            label: Text('Upload from Images'),
                          ),
                        ],
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text('Cancel'),
                        )
                      ],
                    ),
                  );
                },
                child: Text('Upload Image'),
                style: TextButton.styleFrom(
                  onSurface: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

// * to compress the file
  Future<File> compressImage({File file}) async {
    File compressedFile = await FlutterNativeImage.compressImage(
      file.path,
      quality: 50,
    );
    return compressedFile;
  }

  // * end of compressing of the file
//! uploading file to firebase storage
  Future<String> uploadingFile({File uploadFile}) async {
    UploadTask _uploadededFile =
        _firebaseStorage.child('Images').putFile(uploadFile);
    TaskSnapshot get = await _uploadededFile.whenComplete(() => null);
    return get.ref.getDownloadURL();
  }

  //! uploading code ends here
  //--------------------------------
  createStorage({String url, String location, String caption}) {
    DocumentReference docRef = _firebase
        .collection('Posts')
        .doc(_user.uid)
        .collection('userPost')
        .doc();
    docRef.set({
      'postId': docRef.id,
      'ownerId': _user.uid.toString(),
      'username': _user.displayName,
      'mediaUrl': url,
      'description': caption,
      'location': location,
      'timeStamp': Timestamp.now(),
      'likes': {},
    });
  }
  //-----------------------

// * Uploading command
  void uploading() async {
    setState(() {
      isUpload = true;
    });
    File newImageFile = await compressImage(file: _image1);
    String uploadurl = await uploadingFile(uploadFile: newImageFile);
    createStorage(
      url: uploadurl,
      caption: captionConntroller.text,
      location: locationConntroller.text,
    );
    captionConntroller.clear();
    locationConntroller.clear();

    setState(() {
      isUpload = false;
      _image1 = null;
    });
  }
  // * Uploading commnad ends

  Widget uploadScreen() {
    return Scaffold(
      backgroundColor: Colors.white70,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            setState(() {
              _image1 = null;
            });
          },
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextButton(
              onPressed: isUpload ? null : () => uploading(),
              child: Text(
                'Upload',
                style: TextStyle(
                  fontSize: 20.0,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
      body: Container(
        child: ListView(
          children: [
            Column(
              children: [
                isUpload ? linearProgress() : Divider(),
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: 350,
                  child: Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: FileImage(_image1),
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20.0,
                ),
                ListTile(
                  leading: CircleAvatar(
                    child: Image.network(_user.photoURL),
                  ),
                  title: TextFormField(
                    controller: captionConntroller,
                    keyboardType: TextInputType.multiline,
                    minLines: null,
                    maxLines: null,
                    decoration: InputDecoration(
                      hintText: 'Write your Caption.....',
                      border: InputBorder.none,
                      filled: true,
                    ),
                  ),
                ),
                Divider(),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18.0),
                  child: Container(
                    decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        borderRadius: BorderRadius.circular(10.0)),
                    child: ListTile(
                      leading: Icon(
                        Icons.location_on,
                        color: Colors.white,
                      ),
                      title: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        child: TextFormField(
                          controller: locationConntroller,
                          style: TextStyle(color: Colors.black),
                          keyboardType: TextInputType.multiline,
                          decoration: InputDecoration(
                            hintText: 'inpute your location.....',
                            border: InputBorder.none,
                            filled: true,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Divider(),
                    Text('or'),
                    Divider(),
                  ],
                ),
                ElevatedButton.icon(
                  onPressed: getLocation,
                  icon: Icon(
                    Icons.my_location,
                  ),
                  label: Text('select your location'),
                  style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  )),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

//! this is the geolocation with geocoder
  void getLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    final coordinates = new Coordinates(position.latitude, position.longitude);
    List addresses =
        await Geocoder.local.findAddressesFromCoordinates(coordinates);
    var first = addresses.first;
    locationConntroller.text = first.featureName;
    print("${first.featureName} : ${first.addressLine}");
  }

//! the End of geolocation with geocoder
  @override
  Widget build(BuildContext context) {
    return _image1 == null ? slashUpload() : uploadScreen();
  }
}
