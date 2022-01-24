import 'dart:io';
import 'firebase_api.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'homepage.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:file_picker/file_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Upload extends StatefulWidget {
  UploadTask ? task;
  UploadTask ? sec_task;
  File ? file;
  File ? pic_file;
  final _firestoreinstance = FirebaseFirestore.instance;

  TextEditingController recitition_name = TextEditingController();
  TextEditingController reader_name = TextEditingController();


  Upload({Key? key}) : super(key: key);

  @override
  _UploadState createState() => _UploadState();
}

class _UploadState extends State<Upload> {

  UploadTask ? task;
  UploadTask ? sec_task;
  File ? file;
  File ? pic_file;
  final _firestoreinstance = FirebaseFirestore.instance;

  TextEditingController recitition_name = TextEditingController();
  TextEditingController reader_name = TextEditingController();


  @override

  Widget build(BuildContext context) {



    final fileName = file != null ? file?.path.split('/').last : 'No File Selected';
    final picName = pic_file != null ? pic_file?.path.split('/').last : 'No File Selected';



    return  SafeArea(child: Scaffold(

      backgroundColor: Colors.grey[150],
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: Center(
          child: ListView(
              children:[ Column(
                children: [
                  SizedBox(height: 20,),
                  Text("إضافة تلاوة",style: GoogleFonts.arefRuqaa(fontSize: 50),),
                  Image.asset('assets/quran_auth.png'),
                  SizedBox(height: 20,),
                  //User Name Field
                  Container(
                    width: 350,

                    child: TextFormField(

                      validator: (value){
                        if (value == null){
                          return 'الرجاء إدخال عنوان التلاوة';
                        }
                        return null;
                      },

                      controller: recitition_name,
                      style: TextStyle(color: Colors.black38),
                      keyboardType: TextInputType.emailAddress,
                      autofocus: false,
                      decoration: InputDecoration(
                        labelText: 'عنوان التلاوة',
                        focusedBorder:OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.black38, width: 2.0),
                          borderRadius: BorderRadius.circular(25.0),
                        ),
                        contentPadding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(32),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20,),
                  // Email Box
                  Container(
                    width: 350,
                    child: TextFormField(


                      validator: (value){
                        if (value == null){
                          return 'الرجاء إدخال اسم القارئ';
                        }
                        return null;
                      },

                      controller: reader_name,
                      onChanged: (value){
                        null;
                      },
                      style: TextStyle(color: Colors.black38),
                      keyboardType: TextInputType.emailAddress,
                      autofocus: false,
                      decoration: InputDecoration(
                        labelText: 'اسم القارئ',
                        focusedBorder:OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.black38, width: 2.0),
                          borderRadius: BorderRadius.circular(25.0),
                        ),
                        contentPadding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(32),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 15,),
                  // Sign Up Button

                  OutlineButton.icon(onPressed: () async {
                    final pic = await FilePicker.platform.pickFiles(allowMultiple: false);
                    if (pic == null) return;
                    final path = pic.files.single.path!;
                    setState(() {
                      pic_file = File(path);
                    });
                  },
                    shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
                    label: Text('صورة الغلاف',style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold),),
                    icon: Icon(Icons.image),
                  ),

                  SizedBox(height: 5,),
                  Text(
                    picName!,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),

                  ),

                    SizedBox(height: 6,),

                    OutlineButton.icon(onPressed: () async {
                          final song = await FilePicker.platform.pickFiles(allowMultiple: false);
                          if (song == null) return;
                          final path = song.files.single.path!;
                          setState(() {
                            file = File(path);
                          });
                    },
                      shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
                      label: Text('التسجيل',style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold),),
                      icon: Icon(Icons.headphones),
                    ),

                  SizedBox(height: 5,),
                  Text(
                    fileName!,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),

                  ),

                  SizedBox(height: 10,),
                  OutlineButton.icon(onPressed: () async{
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>HomePage()));
                        if (file == null) return;
                        final destination = 'files/$fileName';
                        task = FirebasseApi.uploadFile(destination, file!);


                        if (pic_file == null) return;
                        final pic_destination = 'files/$picName';
                        sec_task = FirebasseApi2.uploadFile(pic_destination, pic_file!);

                        if (sec_task == null) return;
                        final pic_snapshot = await sec_task!.whenComplete(() {});
                        final pic_urlDownload = await pic_snapshot.ref.getDownloadURL();

                        if (task == null) return;
                        final snapshot = await task!.whenComplete(() {});
                        final urlDownload = await snapshot.ref.getDownloadURL();
                        var data = {
                          'rec_name' : recitition_name.text,
                          'rec_reader' : reader_name.text,
                          'song_url' : urlDownload.toString(),
                          'pic_url' : pic_urlDownload.toString(),

                        };

                        _firestoreinstance.collection('recititions').doc().set(data);

                  },
                      shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
                      label: Text(
                        'إضافة',
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    icon: Icon(Icons.cloud_upload),

                  ),

                ],
              ),]
          ),
        ),
      ),
    ));
  }
}


