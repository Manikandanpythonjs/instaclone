import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/Components/Resources/firestore_methods.dart';
import 'package:provider/provider.dart';

import '../Models/User.dart';
import '../Providers/user_providers.dart';
import '../Widgets/Comments_Card.dart';

class CommentsScreen extends StatefulWidget {
  final snap;
  const CommentsScreen({Key? key,required this.snap}) : super(key: key);

  @override
  State<CommentsScreen> createState() => _CommentsScreenState();
}

class _CommentsScreenState extends State<CommentsScreen> {

  final TextEditingController _commentcontroller = TextEditingController();


  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _commentcontroller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final UserModel user = Provider.of<UserProvider>(context).GetUser;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text("Comments"),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection("posts").doc(widget
            .snap['postid']).collection('comments').orderBy('createdDate',descending: true).snapshots(),

        builder:(context,AsyncSnapshot<QuerySnapshot <Map<String,dynamic>>>snapshot){

          if(snapshot.connectionState == ConnectionState.waiting){

            return const Center(
              child: CircularProgressIndicator(
                color: Colors.white,
              ),
            );

          }

          return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context,index)=> CommentsCard(
                snap: snapshot.data!.docs[index].data(),
              ));
          
        } ,

      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(5),
          child: Container(
            height: kToolbarHeight,
            margin: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            padding: const EdgeInsets.only(left: 16, right: 8),
            child: Row(
              children: [
                 CircleAvatar(
                  backgroundImage: NetworkImage(
                     user.photoURL),
                  radius: 18,
                ),
                 Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: TextField(
                      controller: _commentcontroller,
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w500),
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "Comment here ${user.username}",
                          hintStyle: const TextStyle(
                              color: Colors.grey,
                              fontSize: 16,
                              letterSpacing: 1,
                              fontWeight: FontWeight.w500)),
                    ),
                  ),
                ),
                IconButton(
                    onPressed: () async{
                      FirestoreMethods().PostComment(widget.snap['postid'],
                          _commentcontroller.text, user.uid,
                          user.username,
                          user.photoURL);

                      setState(() {
                        _commentcontroller.text = '';
                      });

                    },
                    icon: const Icon(
                      Icons.send,
                      color: Colors.white,
                    ))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
