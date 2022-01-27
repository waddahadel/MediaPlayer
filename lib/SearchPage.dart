import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:anim_search_bar/anim_search_bar.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}


class _SearchPageState extends State<SearchPage> {

  TextEditingController query = TextEditingController();

  Object? get documentlist => documentlist;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
              body: Container(
                child: Column(
                  children: [
                    SizedBox(height: 15,),
                    TextField(
                      onChanged: (query){
                        getCasesDetailList(query);
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
                    TextButton(onPressed: (){
                      print(documentlist);
                    },
                    child: Text('press me'),)
                  ],
                ),
              ),

      ),
    );
  }

}

getCasesDetailList(String query) async {
  List<DocumentSnapshot> documentList = (await FirebaseFirestore.instance
      .collection("recititions")
      .where("rec_name", arrayContains: query)
      .get())
      .docs;
}
