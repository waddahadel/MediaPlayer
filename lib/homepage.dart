import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:anim_search_bar/anim_search_bar.dart';
import 'package:quran/upload.dart';
import 'package:file_picker/file_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'recititionplayer.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  final _firestore = FirebaseFirestore.instance;


  void getRecititions() async {
    await for (var snapshot in _firestore.collection('recititions').snapshots()) {
      for (var recitition in snapshot.docs) {
        print(recitition.data());
      }
    }
  }

  final _auth = FirebaseAuth.instance;

  @override
  TextEditingController myController = TextEditingController();

  @override
  void initState(){
    super.initState();
    myController.addListener(onMyControllerChanged);
  }

  onMyControllerChanged(){
    print(myController.text);
  }

  void dispose_listener () {
    myController.removeListener(onMyControllerChanged);
    myController.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
    return  SafeArea(
      child: Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: FloatingActionButton(onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => Upload()));
        },
          child : Icon(Icons.add,color: Colors.brown,size: 45,),
          backgroundColor: Colors.white,
        ),
          backgroundColor: Colors.grey[150],


          body: Directionality(
            textDirection: TextDirection.rtl,
            child: Container(
              padding: EdgeInsets.all(20),
              alignment: Alignment.topRight,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                children:[
                  Expanded(child:
                   ListView(
                    
                    children: [
                      Text("احدث ",style: GoogleFonts.arefRuqaa(
                      fontSize: 70,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),),

                      Text("الاضافات",style: GoogleFonts.arefRuqaa(
                        fontSize: 70,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),),
                      SizedBox(height: 10,),
                      StreamBuilder<QuerySnapshot>(
                        stream: _firestore.collection('recititions').snapshots(),
                        builder: (context,snapshot){
                          if (snapshot.hasData){
                            final tilawas = snapshot.data?.docs;
                            List<GestureDetector> tilawaWidgets = [];
                            for (var tilawa in tilawas!){
                              final rec_name = tilawa.get('rec_name');
                              final rec_reader = tilawa.get('rec_reader');
                              final pic_url = tilawa.get('pic_url');
                              final song_url = tilawa.get('song_url');
                              final suraWidget =

                              GestureDetector(
                                  onTap: (){
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => RecititionPlayer(rec_name: rec_name, rec_reader: rec_reader, pic_url: pic_url, song_url: song_url)));
                                  },
                                
                                    child : Container(
                                        height: 200,
                                        width: 400,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(20),
                                          color: Colors.white,
                                          image: DecorationImage(
                                            image: NetworkImage(pic_url),
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                        child:
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            '$rec_name \n $rec_reader',
                                            style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                              ),
                                        ),
                                    ),);



                              tilawaWidgets.add(suraWidget);
                              tilawaWidgets.add(GestureDetector(child :SizedBox(height: 15,)),);
                            }

                            return Column(
                              children : tilawaWidgets,
                            );
                          }
                          else{
                            return SizedBox(height: 1,);
                          }
                        },
                      ),



                    ],
                  ),

                  ),




                ]
              ),
            ),
          ),

      ),
    );
  }
}
