import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rtdatabase/model/post_model.dart';
import 'package:rtdatabase/service/rtd_service.dart';

class CreatePage extends StatefulWidget {
  const CreatePage({super.key});

  @override
  State<CreatePage> createState() => _CreatePageState();
}

class _CreatePageState extends State<CreatePage> {

  bool isLoading = false;
  var titleController = TextEditingController();
  var contentController = TextEditingController();

  XFile? _image;
  final picker = ImagePicker();

  void _createPost () {
    setState(() {
      isLoading = true;
    });
    String title = titleController.text.toString();
    String body = contentController.text.toString();
    if (title.isEmpty || body.isEmpty) return;
    var post = Post( title: title, body: body);
    RTDService.addPost(post).then((_) {
      Navigator.pop(context, {'data': 'done'});
      setState(() {
        isLoading = false;
      });
    });
  }
  Future _gatImage() async{
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null ){
        _image = pickedFile;
      }else{
        print('error picked file');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: const Text('Create a post'),
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: (){
                    _gatImage();
                  },
                  child: SizedBox(
                    height: 100,
                    width: 100,
                    child: _image != null ? Image.file(_image, fit: BoxFit.cover,)
                    : Image.asset('assets/images/img.png'),
                  ),
                ),

                const SizedBox (height: 10,),

                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(
                    hintText: 'Title'
                  ),
                ),
                const SizedBox (height: 10,),
                TextField(
                  controller: contentController,
                  decoration: const InputDecoration(
                    hintText: 'Body'

                  ),
                ),
                const SizedBox (height: 10,),
                MaterialButton(
                  onPressed: (){
                    _createPost();
                  },
                  color: Colors.blueAccent,
                  child: const Text('Create', style: TextStyle(color: Colors.white),),
                )
              ],
            ),
            isLoading? const Center(
              child: CircularProgressIndicator(),
            ) : const SizedBox.shrink()
          ],
        ),
      ),
    );
  }
}
