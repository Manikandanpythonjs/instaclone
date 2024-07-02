import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/Components/Widgets/Post_Card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,

      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        title: Image.asset(
          'assets/logo-text.png',
          color: Colors.white,

          height: 40,
        ),
        actions: [
          IconButton(onPressed: ()=>{

          }, icon:Icon(Icons.messenger_outline_outlined,
            color: Colors.white,size: 30,))
        ],
      ),

      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('posts')
            .orderBy('datecreated',descending: true)
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot <Map<String,dynamic>>>snapshot){

          if(snapshot.connectionState ==ConnectionState.waiting){
            return const Center(
              child: CircularProgressIndicator(color: Colors.pink,),
            );
          }

          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
              itemBuilder: (context,index)=> PostCard(
                snap: snapshot.data!.docs[index].data(),
              ));

        },
      )
    );
  }
}
