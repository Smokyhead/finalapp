// ignore_for_file: unnecessary_null_comparison, use_build_context_synchronously, library_prefixes, avoid_print

import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finalapp/Screens/Welcome/Components/background_welc.dart';
import 'package:finalapp/constants.dart';
import 'package:finalapp/models/users.dart';
import 'package:finalapp/screens/patient_home/patient_home.dart';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as fStorage;

class PPicSelectBody extends StatefulWidget {
  const PPicSelectBody({super.key});

  @override
  State<PPicSelectBody> createState() => _PPicSelectBodyState();
}

class _PPicSelectBodyState extends State<PPicSelectBody> {
  final ImagePicker _picker = ImagePicker();
  XFile? _imageFile;
  String imageUrl = "";

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Background(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
          Container(
            margin: const EdgeInsets.only(top: 120),
            child: const Text(
              "Sélectionner votre photo",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 28,
                  color: kPrimaryColor),
            ),
          ),
          const SizedBox(
            height: 85,
          ),
          Stack(children: [
            CircleAvatar(
              radius: 150,
              backgroundImage: const AssetImage("assets/images/avatar.jpg"),
              foregroundImage:
                  _imageFile == null ? null : FileImage(File(_imageFile!.path)),
            ),
            const Positioned(
                bottom: 5,
                right: 5,
                child: CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: 40,
                )),
            Positioned(
                bottom: 27,
                right: 27,
                child: IconButton(
                    onPressed: () {
                      showModalBottomSheet(
                        context: context,
                        builder: ((builder) => bottomSheet()),
                      );
                    },
                    icon: const Icon(
                      IconlyBold.camera,
                      size: 35,
                    )))
          ]),
          const SizedBox(
            height: 200,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              const SizedBox(
                width: 50,
              ),
              Container(
                  decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(30)),
                      border: Border.all(color: kPrimaryColor, width: 2)),
                  height: 70,
                  width: 100,
                  margin: const EdgeInsets.only(right: 10),
                  child: TextButton(
                    style: ButtonStyle(
                      elevation: MaterialStateProperty.all(6),
                      backgroundColor:
                          MaterialStateProperty.all(kPrimaryLightColor),
                      foregroundColor: MaterialStateProperty.all(kPrimaryColor),
                      shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30)),
                      ),
                    ),
                    onPressed: () {
                      if (_imageFile != null) {
                        uploadImage();
                        checkUrl();
                      } else {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const PatientHome()));
                      }
                    },
                    child: const Text(
                      "OK",
                      style: TextStyle(fontSize: 30),
                    ),
                  )),
              Container(
                margin: const EdgeInsets.only(right: 10),
                child: const Icon(
                  IconlyBold.arrow_right_circle,
                  color: kPrimaryColor,
                  size: 30,
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 30,
          ),
          const Text(
            "Vous pouvez modifier votre photo ulterierement",
            style: TextStyle(fontWeight: FontWeight.bold),
          )
        ]));
  }

  Widget bottomSheet() {
    return Container(
      height: 100.0,
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 20,
      ),
      child: Column(
        children: <Widget>[
          const Text(
            "Sélectionner votre photo",
            style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                SizedBox(
                  height: 50,
                  child: ElevatedButton.icon(
                    style: ButtonStyle(
                      elevation: MaterialStateProperty.all(6),
                      backgroundColor: MaterialStateProperty.all(kPrimaryColor),
                      foregroundColor: MaterialStateProperty.all(Colors.white),
                      shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30)),
                      ),
                    ),
                    icon: const Icon(Icons.camera),
                    onPressed: () {
                      takePhoto(ImageSource.camera);
                    },
                    label: const Text("Camera"),
                  ),
                ),
                SizedBox(
                  height: 50,
                  child: ElevatedButton.icon(
                    style: ButtonStyle(
                      elevation: MaterialStateProperty.all(6),
                      backgroundColor: MaterialStateProperty.all(kPrimaryColor),
                      foregroundColor: MaterialStateProperty.all(Colors.white),
                      shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30)),
                      ),
                    ),
                    icon: const Icon(Icons.image),
                    onPressed: () {
                      takePhoto(ImageSource.gallery);
                    },
                    label: const Text("Gallerie"),
                  ),
                ),
              ])
        ],
      ),
    );
  }

  void takePhoto(ImageSource source) async {
    _imageFile = await _picker.pickImage(
      source: source,
    );
    setState(() {
      _imageFile;
    });
    Navigator.pop(context);
  }

  void uploadImage() async {
    String fileName = DateTime.now().millisecondsSinceEpoch.toString();

    fStorage.Reference reference = fStorage.FirebaseStorage.instance
        .ref()
        .child("Patients")
        .child(fileName);
    fStorage.UploadTask uploadTask = reference.putFile(File(_imageFile!.path));
    fStorage.TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() {});
    await taskSnapshot.ref.getDownloadURL().then((url) {
      imageUrl = url;
      Patient.imageUrl = imageUrl;
    });
    FirebaseFirestore.instance
        .collection("Patients")
        .doc(Patient.uid)
        .update({"imageUrl": imageUrl});
    print("image URL: $imageUrl");
    print("PATIENT IMAGE URL: ${Patient.imageUrl}");
  }

  void checkUrl() {
    if (Patient.imageUrl == "") {
      showDialog(
          context: (context),
          builder: (BuildContext context) {
            return const Center(
              child: CircularProgressIndicator(
                color: kPrimaryColor,
              ),
            );
          });
      Timer(const Duration(seconds: 4), () {
        Navigator.pop(context);
        checkUrl();
      });
    } else {
      Timer(const Duration(seconds: 1), () {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const PatientHome()));
      });
    }
  }
}
//assets/images/avatar.jpg