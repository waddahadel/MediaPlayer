import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:anim_search_bar/anim_search_bar.dart';
import 'package:quran/recititionplayer.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}


class _SearchPageState extends State<SearchPage> {

  TextEditingController query = TextEditingController();

  Object? get documentlist => documentlist;
  String name = "";

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
              body: Container(
                child: ListView(
                  children: [
                    SizedBox(height: 15,),
                    TextField(
                      onChanged: (val) {initiateSearch(val);
                      print(val);
                      },
                      decoration: InputDecoration(
                          fillColor: Colors.grey,
                          prefixIcon: Icon(Icons.search),
                          suffixIcon: IconButton(
                            icon: Icon(Icons.clear),
                            onPressed: () {
                              /* Clear the search field */
                            },
                          ),
                          hintText: 'البحث عن التلاوات',
                          ),
                    ),
                    StreamBuilder<QuerySnapshot>(
                      stream: name != "" && name != null
                          ? FirebaseFirestore.instance
                          .collection('recititions')
                          .where("searchList", arrayContains: name)
                          .snapshots()
                          : FirebaseFirestore.instance.collection("recititions").snapshots(),
                      builder:
                          (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (snapshot.hasError) return new Text('Error: ${snapshot.error}');
                        switch (snapshot.connectionState) {
                          case ConnectionState.waiting:
                            return new CircularProgressIndicator();
                          default:
                            return new ListView(
                              shrinkWrap: true,
                              children:

                              snapshot.data!.docs.map((DocumentSnapshot document) {
                                return
                                   GestureDetector(
                                     onTap: (){
                                       Navigator.push(context, MaterialPageRoute(builder: (context) => RecititionPlayer(rec_name: document['rec_name'], rec_reader: document['rec_reader'], pic_url: document['pic_url'], song_url: document['song_url'])));
                                     },
                                     child: Directionality(
                                       textDirection: TextDirection.rtl,
                                       child: Padding(
                                         padding: const EdgeInsets.all(10.0),
                                         child: new Container(
                                           height: 200,
                                           width: 400,
                                           decoration: BoxDecoration(
                                             borderRadius: BorderRadius.circular(20),
                                             color: Colors.white,
                                             image: DecorationImage(
                                               image: NetworkImage(document['pic_url']),
                                               fit: BoxFit.cover,
                                             ),
                                           ),
                                           child:
                                           Padding(
                                             padding: const EdgeInsets.all(8.0),
                                             child: ListView(

                                               children: [
                                                 Text(
                                                   document['rec_name']  ,
                                                   style: TextStyle(
                                                     fontSize: 20,
                                                     fontWeight: FontWeight.bold,
                                                     color: Colors.white,
                                                   ),
                                                 ),
                                                 Text(
                                                   document['rec_reader']  ,
                                                   style: TextStyle(
                                                     fontSize: 20,
                                                     fontWeight: FontWeight.bold,
                                                     color: Colors.white,
                                                   ),
                                                 ),
                                               ],
                                             ),
                                           ),
                                         ),
                                       ),
                                     ),
                                   );

                              }).toList(),
                            );
                        }
                      },
                    ),
                  ],
                ),
              ),

      ),
    );
  }
  void initiateSearch(String val) {
    setState(() {
      name = val.toLowerCase().trim();
    });
  }
}


