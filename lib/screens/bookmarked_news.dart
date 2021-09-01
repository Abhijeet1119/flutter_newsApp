import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:newsapp/model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:newsapp/NewsView.dart';

import 'home.dart';

class Bookmark extends StatefulWidget {
  @override
  _BookmarkState createState() => _BookmarkState();
}

class _BookmarkState extends State<Bookmark>
    with AutomaticKeepAliveClientMixin<Bookmark> {

  @override
  Widget build(BuildContext context) {
    super.build(context); // reloads state when opened again
    return Scaffold(
      appBar: AppBar(
        title: Text("Bookmark News"),
        backgroundColor: Colors.black87,
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(
              Icons.keyboard_backspace,
              color: Colors.white,

            ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Home()),
                );
              }
          ),
        ],
      ),
      body: buildActivityFeed(),
    );
  }

  buildActivityFeed() {
    return Container(
      child: FutureBuilder(
          future: getFeed(),
          builder: (context, snapshot) {
            if (!snapshot.hasData)
              return Container(
                  alignment: FractionalOffset.center,
                  padding: const EdgeInsets.only(top: 10.0),
                  child: CircularProgressIndicator());
            else {
              return ListView(children: snapshot.data);
            }
          }),
    );
  }



  getFeed() async {
    List<BookmarkItem> items = [];
    var snap = await FirebaseFirestore.instance.collection('Bookmark').get();

    for (var doc in snap.docs) {
      items.add(BookmarkItem.fromDocument(doc));
    }
    return items;
  }

  // ensures state is kept when switching pages
  @override
  bool get wantKeepAlive => true;
}

class BookmarkItem extends StatelessWidget {
  User userId = FirebaseAuth.instance.currentUser;

  final String newsHead;
  final String newsDes;
  final String newsImg;
  final String newsUrl;

  BookmarkItem({
    this.newsImg,
    this.newsHead,
    this.newsUrl,
    this.newsDes,
  });

  void removeActivityFeedItem() {
    FirebaseFirestore.instance
        .collection("Bookmark")
        .doc(userId.uid)
        .delete();
  }

  factory BookmarkItem.fromDocument(DocumentSnapshot document) {
    var data = document.data();
    return BookmarkItem(
      newsDes: (data as dynamic)['newsDes'],
      newsHead: (data as dynamic)['newsHead'],
      newsUrl: (data as dynamic)['newsUrl'],
      newsImg: (data as dynamic)['newsImg'],
    );
  }

  Widget mediaPreview = Container();
  String actionText;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        Expanded(
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: InkWell(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => NewsView(newsUrl)));
              },
              child: Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                  elevation: 1.0,
                  child: Stack(
                    children: [
                      ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: Image.network(
                            newsImg,
                            fit: BoxFit.fitHeight,
                            height: 230,
                            width: double.infinity,
                          )),
                      Positioned(
                          left: 0,
                          right: 0,
                          bottom: 0,
                          child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  gradient: LinearGradient(
                                      colors: [
                                        Colors.black12.withOpacity(0),
                                        Colors.black
                                      ],
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter)),
                              padding: EdgeInsets.fromLTRB(15, 15, 10, 8),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    newsHead,
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    newsDes.length > 50
                                        ? "$newsDes.substring(0, 55)}...."
                                        : newsDes,
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 12),
                                  )
                                ],
                              )))
                    ],
                  )),
            ),
          ),
        ),
      ],
    );
  }
}
