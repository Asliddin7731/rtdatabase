import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:rtdatabase/pages/create_page.dart';
import 'package:rtdatabase/service/rtd_service.dart';
import '../model/post_model.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  bool isLoading = false;
  List<Post> items = [];
  Future _callCreatePage()async {
    Map result = await Navigator.push(context, MaterialPageRoute(builder: (BuildContext context){
      return const CreatePage();
    }));
    if (result.containsKey('data')){
      getPosts();
    }
  }

  void getPosts() async {
    setState(() {
      isLoading = true;
    });
    items = await RTDService.getPosts();
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    getPosts();
    // items.add(Post(id: 1, body: 'body1', title: 'title'));
    // items.add(Post(id: 1, body: 'body2', title: 'title'));
    // items.add(Post(id: 1, body: 'body3', title: 'title'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          ListView.builder(
            itemCount: items.length,
            itemBuilder: (ctx, index){
              return itemOfPost(items[index]);
            },
          ),
          Center(
            // child: CircularProgressIndicator(),
          ),
          isLoading?  Center(
            child: CircularProgressIndicator(),
          )
              :  SizedBox.shrink(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
        onPressed: (){
          _callCreatePage();
        },
        child: const Icon(Icons.add),
      ),
    );
  }
  /// Item
  Widget itemOfPost(Post post) {
    return Slidable(
      key: const ValueKey(0),
      startActionPane: ActionPane(
        dragDismissible: false,
        motion: const ScrollMotion(),
        dismissible: DismissiblePane(onDismissed: () {}),
        children: [
          SlidableAction(
            onPressed: (BuildContext context) {

            },
            backgroundColor: Colors.green,
            foregroundColor: Colors.white,
            icon: Icons.edit,
            label: 'Update',
          )
        ],
      ),
      endActionPane: ActionPane(
        dragDismissible: false,
        motion: const ScrollMotion(),
        dismissible: DismissiblePane(onDismissed: () {}),
        children: [
          SlidableAction(
            onPressed: (BuildContext context) {

            },
            backgroundColor: Colors.redAccent,
            foregroundColor: Colors.white,
            icon: Icons.delete,
            label: 'Delete',
          )
        ],
      ),
      child: Container(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(post.title!, style: const TextStyle(
                    color: Colors.black, fontWeight: FontWeight.bold),
                ),
                Text(post.body!, style: const TextStyle(
                    color: Colors.black, fontWeight: FontWeight.bold),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
