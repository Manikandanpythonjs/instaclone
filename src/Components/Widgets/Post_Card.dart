import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/Components/Models/User.dart';
import 'package:instagram_clone/Components/Providers/user_providers.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../Resources/firestore_methods.dart';
import '../Screens/CommentsScreen.dart';
import 'Animation_Save.dart';

class PostCard extends StatefulWidget {
  final snap;
  const PostCard({Key? key, required this.snap}) : super(key: key);

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {

  bool isAnimatingLikes = false;
  int commentlength = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getcomments();
  }

  void getcomments() async {
    try {
      QuerySnapshot snap = await FirebaseFirestore.instance
          .collection('posts')
          .doc(widget.snap['postid'])
          .collection('comments')
          .get();


      setState(() {
        commentlength = snap.docs.length;
      });

    } catch (err) {
      print(err.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    final UserModel user = Provider.of<UserProvider>(context).GetUser;
    return Container(
      color: Colors.black,
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(widget.snap['profileurl']),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.snap['username'],
                          style: const TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                  ),
                ),
                IconButton(
                    onPressed: () => {
                          showDialog(
                              context: context,
                              builder: (context) => Dialog(
                                    child: ListView(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 16),
                                      shrinkWrap: true,
                                      children: [
                                        'Delete',
                                      ]
                                          .map((e) => InkWell(
                                                onTap: () => {
                                                  FirestoreMethods().deletePost(
                                                      widget.snap['postid']),
                                                  Navigator.of(context).pop()
                                                },
                                                child: Container(
                                                  padding: const EdgeInsets
                                                          .symmetric(
                                                      vertical: 12,
                                                      horizontal: 16),
                                                  child: Text(e),
                                                ),
                                              ))
                                          .toList(),
                                    ),
                                  ))
                        },
                    icon: const Icon(
                      Icons.more_vert_sharp,
                      color: Colors.white,
                    ))
              ],
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          GestureDetector(
            onDoubleTap: () async {
              await FirestoreMethods().likePost(
                  widget.snap['postid'], user.uid, widget.snap['likes']);
              setState(() {
                isAnimatingLikes = true;
              });
            },
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.50,
                  width: double.infinity,
                  child: Image.network(
                    widget.snap['posturl'],
                    fit: BoxFit.fill,
                  ),
                ),
                AnimatedOpacity(
                  duration: const Duration(milliseconds: 200),
                  opacity: isAnimatingLikes ? 1 : 0,
                  child: AnimationSave(
                    child: const Icon(
                      Icons.favorite,
                      color: Colors.white,
                      size: 200,
                    ),
                    isAnimating: isAnimatingLikes,
                    onEnd: () {
                      setState(() {
                        isAnimatingLikes = false;
                      });
                    },
                  ),
                )
              ],
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            children: [
              AnimationSave(
                isAnimating: widget.snap['likes'].contains(user.uid),
                smallLike: true,
                child: IconButton(
                    onPressed: () async {
                      await FirestoreMethods().likePost(widget.snap['postid'],
                          user.uid, widget.snap['likes']);
                      setState(() {
                        isAnimatingLikes = true;
                      });
                    },
                    icon: widget.snap['likes'].contains(user.uid)
                        ? const Icon(
                            Icons.favorite,
                            color: Colors.red,
                            size: 30,
                          )
                        : const Icon(
                            Icons.favorite_border,
                            color: Colors.white,
                            size: 30,
                          )),
              ),
              IconButton(
                  onPressed: () => {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => CommentsScreen(
                                  snap: widget.snap,
                                )))
                      },
                  icon: const Icon(
                    Icons.comment_outlined,
                    color: Colors.white,
                    size: 30,
                  )),
              IconButton(
                  onPressed: () => {},
                  icon: const Icon(
                    Icons.send,
                    color: Colors.white,
                    size: 30,
                  )),
              Expanded(
                  child: Align(
                alignment: Alignment.bottomRight,
                child: IconButton(
                    onPressed: () => {},
                    icon: const Icon(
                      Icons.bookmark_border_outlined,
                      color: Colors.white,
                      size: 30,
                    )),
              ))
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${widget.snap['likes'].length} likes',
                  style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 15),
                ),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.only(top: 8),
                  child: RichText(
                    text: TextSpan(
                        style: const TextStyle(color: Colors.white),
                        children: [
                          TextSpan(
                              text: widget.snap['username'],
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold)),
                          TextSpan(
                              text: widget.snap['description'],
                              style: const TextStyle(
                                  color: Colors.grey,
                                  fontWeight: FontWeight.w600)),
                        ]),
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
                Container(
                  child:  Text(commentlength <=1 ? "View "
                      "${commentlength} comment":"View all ${commentlength} "
                      "comments",
                    style: const TextStyle(color: Colors.grey, fontSize: 16),
                  ),

                ),
                const SizedBox(
                  height: 8,
                ),
                Container(
                  child: Text(
                    DateFormat.yMMMd()
                        .format(widget.snap['datecreated'].toDate()),
                    style: const TextStyle(color: Colors.grey, fontSize: 16),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
