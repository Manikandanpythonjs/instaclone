import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CommentsCard extends StatefulWidget {
  final snap;
  const CommentsCard({Key? key,required this.snap}) : super(key: key);

  @override
  State<CommentsCard> createState() => _CommentsCardState();
}

class _CommentsCardState extends State<CommentsCard> {
  @override
  Widget build(BuildContext context) {

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16,vertical:18 ),
      child: Row(
        children: [
           CircleAvatar(
            backgroundImage: NetworkImage(widget.snap['profileurl']),
          ),
          Expanded(
            child: Padding(
                padding: const EdgeInsets.only(left:16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  RichText(text:  TextSpan(
                    children: [

                      TextSpan(
                        text:widget.snap['username'],
                        style: TextStyle(fontWeight: FontWeight.bold)
                      ),
                      TextSpan(
                          text: widget.snap['comment'],

                      ),

                    ]
                  )
                  ),
                   Padding(padding: EdgeInsets.only(top: 4),
                    child: Text( DateFormat.yMMMd().format(widget
                        .snap['createdDate'].toDate()),style: const TextStyle
                      (fontSize: 12,
                        fontWeight: FontWeight.w400,color: Colors.white),),
                  )

                ],
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.all(8),
            child:Icon(Icons.favorite_border,size: 20,color: Colors.white,) ,
          )
        ],
      ),
    );
  }
}
