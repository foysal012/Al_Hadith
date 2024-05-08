
import 'dart:io';
import 'dart:typed_data';

import 'package:al_hadit/model/model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:hexagon/hexagon.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  Database? _database;
  List<Section> _section = [];
  List<Hadith> _hadith = [];
  List<Section> _list = [];

  @override
  void initState() {
    super.initState();
    _openDatabase();
  }

  Future<void> _openDatabase() async {

    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "hadith_db.db");


    bool exists = await databaseExists(path);
    if (!exists) {
      ByteData data = await rootBundle.load("assets/hadith_db.db");
      List<int> bytes = data.buffer.asUint8List();
      await File(path).writeAsBytes(bytes);
    }

    _database = await openDatabase(path);
    _loadDataFromDatabase();
  }

  Future<void> _loadDataFromDatabase() async {
      List<Map<String, dynamic>> result2 = await _database!.rawQuery('''
      SELECT s.id, s.book_id, s.book_name, s.chapter_id, s.section_id, s.title, s.preface, s.number, h.book_id, h.hadith_id, h.book_name, h.chapter_id, h.section_id, h.narrator, h.bn, h.ar, h.ar_diacless, h.note, h.grade_id, h.grade, h.grade_color
      FROM Section s
      INNER JOIN Hadith h ON s.section_id = h.section_id
    ''');

      _list = result2.map((map) {
        return Section(
          id: map['id'],
          book_id: map['book_id'],
          book_name: map['book_name'],
          chapter_id: map['chapter_id'],
          section_id: map['section_id'],
          title: map['title'],
          preface: map['preface'],
          number: map['number'],
          hadith: Hadith(
            hadith_id: map['hadith_id'],
            book_id: map['book_id'],
            book_name: map['book_name'],
            chapter_id: map['chapter_id'],
            section_id: map['section_id'],
            narrator: map['narrator'],
            bn: map['bn'],
            ar: map['ar'],
            ar_diacless: map['ar_diacless'],
            note: map['note'],
            grade_id: map['grade_id'],
            grade: map['grade'],
            grade_color: map['grade_color'],
          ),
        );
      }).toList();
    setState(() {}); // Update the UI after loading data.
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
      Container(
        height: double.infinity,
        width: double.infinity,
        child: Stack(
          children: [
                Container(
                  height: MediaQuery.of(context).size.height * 0.16,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Color(0xff46b891),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 12.0,
                    top: 20,
                    ),
                    child: ListTile(
                      leading: Icon(Icons.arrow_back_ios, color: Colors.white,),
                      title: Text("সহীহ বুখারী",
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.white
                      ),
                      ),
                      subtitle: Text("ওহীর সূচনা অধ্যায়",
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                        ),
                      ),
                      
                      trailing: Icon(Icons.signpost_outlined,
                      color: Colors.white,
                      ),
                    ),
                  ),
                ),
            Positioned(
                  bottom: 0,
                left: 0,
                right: 0,
                child:
                  Container(
                    height: MediaQuery.of(context).size.height * 0.88,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                      )
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 10.0,
                      top: 12,
                      ),
                        child: _list.isEmpty
                            ? Text('No data available')
                            : ListView.builder(
                          physics: ScrollPhysics(),
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          reverse: false,
                          itemCount: _list.length,
                          itemBuilder: (context, index) {
                            final data = _list[index];
                            return Column(
                              children: [
                                ConstrainedBox(
                                  constraints: BoxConstraints(
                                  maxHeight: 170,
                                  minHeight: 40,
                                ),
                                child: Container(
                                  height: data.preface != null ? 200 : 50,
                                  width: double.infinity ,
                                  padding: EdgeInsets.only(
                                    left: 10,
                                    top: 10,
                                    right: 10,
                                  ),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      color: Colors.white
                                  ),
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          Flexible(
                                            child: RichText(
                                              text: TextSpan(
                                                style: TextStyle(color: Colors.black),
                                                children: [
                                                  TextSpan(text: '${data.number}',
                                                      style: TextStyle(
                                                        fontWeight: FontWeight.w500,
                                                        color: Color(0xff46b891,
                                                        ),
                                                        fontSize: 14,
                                                      )
                                                  ),
                                                  TextSpan(
                                                    text: ' ${data.title}',
                                                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16,),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          )
                                        ],
                                      ),

                                      SizedBox(
                                        height: 10,
                                      ),

                                      Divider(
                                        height: 1,
                                        color: Colors.grey[100],
                                        thickness: 2,
                                        indent: 2,
                                        endIndent: 2,
                                      ),

                                      SizedBox(
                                        height: 10,
                                      ),

                                      Flexible(
                                          child: Text("${data.preface}",
                                            style: TextStyle(
                                                fontSize: 15,
                                                color: Colors.black45
                                            ),
                                          )
                                      )
                                    ],
                                  ),
                                ),
                                ),
                                Container(
                                  height: MediaQuery.of(context).size.height * 0.5,
                                  width: MediaQuery.of(context).size.width ,
                                  padding: EdgeInsets.only(
                                    left: 10,
                                    right: 10,
                                    top: 10,
                                  ),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      color: Colors.grey.withOpacity(.8)
                                  ),
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            children: [
                                              HexagonWidget.pointy(
                                                width: 45,
                                                color: Colors.green,
                                                elevation: 8,
                                                child: Text('B',
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                                ),
                                              ),

                                              SizedBox(width: 10,),

                                              Column(
                                                 crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text("সহীহ বুখারী",
                                                    style: TextStyle(
                                                      color: Colors.black87,
                                                      fontSize: 14,
                                                    ),
                                                  ),
                                                  Text("হাদিস: ${data.hadith.hadith_id}",
                                                  style: TextStyle(
                                                    color: Color(0xff46b891),
                                                    fontSize: 12,
                                                  ),
                                                  ),
                                                ],
                                              )
                                            ],
                                          ),
                                          
                                          Row(
                                            children: [
                                              Container(
                                                height: 37,
                                                width: 90,
                                                decoration: BoxDecoration(
                                                    color: Color(0xff46b891),
                                                    borderRadius: BorderRadius.circular(20)
                                                ),
                                                child: Center(child: Text("${data.hadith.grade}",
                                                style: TextStyle(
                                                  color: Colors.white
                                                ),
                                                )),
                                              ),
                                              Icon(Icons.more_vert)
                                            ],
                                          )
                                        ],
                                      ),

                                      SizedBox(height: 10,),

                                      Flexible(child: Text("${data.hadith.ar}")),

                                      SizedBox(height: 10,),

                                      Flexible(child: Text("${data.hadith.narrator}")),

                                      SizedBox(height: 10,),

                                      Flexible(child: Text("${data.hadith.bn}")),

                                    ],
                                  ),
                                )
                              ],
                            );
                          },
                        ),
                      ),
                    ),
                  ),

          ],
        ),
      )
    );
  }

  @override
  void dispose() {
    _database?.close(); // Close the database when the widget is disposed.
    super.dispose();
  }
}

