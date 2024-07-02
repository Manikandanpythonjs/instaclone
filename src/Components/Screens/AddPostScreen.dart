import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram_clone/Components/Models/User.dart';
import 'package:instagram_clone/Components/Resources/Utils/snackbarCustom.dart';
import 'package:instagram_clone/Components/Resources/firestore_methods.dart';
import 'package:provider/provider.dart';

import '../Providers/user_providers.dart';
import '../Resources/Utils/Image_Picker_utils.dart';

class AddPostScreen extends StatefulWidget {
  const AddPostScreen({Key? key}) : super(key: key);

  @override
  State<AddPostScreen> createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  Uint8List? _file;

  final TextEditingController _description = TextEditingController();

  bool _isloading = false;

 void postImage(String uid, String username, String profile) async {

   setState(() {

     _isloading = true;

   });

    try{

      String res = await FirestoreMethods().uploadPost(_description.text,
          _file!, uid, username, profile);

      if(res =='Success'){

        setState(() {

          _isloading = false;

        });

        ShowSnackbar("Posted!!", context);
        clearimage();

      }else{
        ShowSnackbar(res, context);

      }
      
    }catch(err){

      ShowSnackbar(err.toString(), context);

    }


  }

  _selectedImage(BuildContext context) async {
    showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            title: const Text('Create a Post'),
            children: [
              SimpleDialogOption(
                  padding: const EdgeInsets.all(20),
                  child: const Text('Take a Photo'),
                  onPressed: () async {
                    Navigator.of(context).pop();
                    Uint8List file = await pickimage(ImageSource.camera);
                    setState(() {
                      _file = file;
                    });
                  }),
              SimpleDialogOption(
                  padding: const EdgeInsets.all(20),
                  child: const Text('Choose from gallery'),
                  onPressed: () async {
                    Navigator.of(context).pop();
                    Uint8List file = await pickimage(ImageSource.gallery);
                    setState(() {
                      _file = file;
                    });
                  }),
              SimpleDialogOption(
                  padding: const EdgeInsets.all(20),
                  child: const Text('Cancel'),
                  onPressed: () async {
                    Navigator.of(context).pop();
                    //   Uint8List file = await pickimage(ImageSource.camera);
                    //   setState(() {
                    //     _file = file;
                    //   });
                    //
                  })
            ],
          );
        });

    // return Show(context:context,builder:(context){
    //
    //
    // });
  }


  void clearimage(){

   setState(() {
     _file=null;
   });

  }


  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _description.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final UserModel user = Provider.of<UserProvider>(context).GetUser;

    return _file == null
        ? Center(
            child: IconButton(
              onPressed: () => {_selectedImage(context)},
              icon: const Icon(
                Icons.upload,
                color: Colors.white,
              ),
            ),
          )
        : Scaffold(
            appBar: AppBar(
              title: const Text(
                "Post to",
                style: TextStyle(color: Colors.white),
              ),
              backgroundColor: Colors.black,
              elevation: 0,
              leading: IconButton(
                onPressed: () => {
                  clearimage()
                },
                icon: const Icon(
                  Icons.arrow_back_sharp,
                  color: Colors.grey,
                ),
              ),
              actions: [
                TextButton(
                    onPressed: () => {
                      postImage(user.uid, user.username, user.photoURL)
                    },
                    child: const Text(
                      "Post",
                      style: TextStyle(
                          color: Colors.blueAccent,
                          fontSize: 16,
                          fontWeight: FontWeight.w600),
                    ))
              ],
            ),
            backgroundColor: Colors.black,
            body: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: Column(
                children: [
                  _isloading ? const LinearProgressIndicator(
                    color: Colors.blue,
                  ):Padding(padding:const EdgeInsets.only(top:0)),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        backgroundImage: NetworkImage(user.photoURL),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.5,
                        child:  TextField(
                          controller: _description,
                          style: const TextStyle(color: Colors.white),
                          decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: "Write a Story....",
                              hintStyle: TextStyle(color: Colors.blueAccent)),
                        ),
                      ),
                      SizedBox(
                        height: 45,
                        width: 45,
                        child: AspectRatio(
                          aspectRatio: 487 / 451,
                          child: Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: MemoryImage(_file!),
                                    alignment: FractionalOffset.topCenter,
                                    fit: BoxFit.fill)),
                          ),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          );
  }
}
