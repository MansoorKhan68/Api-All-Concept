import 'dart:convert';

import 'package:api_course/models/manual_created_model_1.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Example2 extends StatefulWidget {
  const Example2({super.key});

  @override
  State<Example2> createState() => _Example2State();
}

class _Example2State extends State<Example2> {
  // created List of Photos types
  List<PhotosModel> photosList = [];
  // future function

  Future<List<PhotosModel>> getPhotos() async {
    try {
      final response = await http
          .get(Uri.parse("https://jsonplaceholder.typicode.com/photos"));
      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body.toString());
        for (var i in data) {
          PhotosModel photos = PhotosModel(title: i['title'], url: i['url']);
          photosList.add(photos);
        }
        return photosList;
      } else {
        throw Exception("Some Thing Went Wrong");
      }
    } catch (e) {
      Text("Error $e");
    }
    return [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Get Data From Manual created Model"),
      ),
      body: Column(children: [
        Expanded(child: FutureBuilder(future: getPhotos(), builder: (context , snapshot){
          return ListView.builder(
            itemCount: photosList.length,
            itemBuilder: (context , index){
            return ListTile(
              leading: CircleAvatar(backgroundImage: NetworkImage(snapshot.data![index].url.toString()),),
              title: Text(snapshot.data![index].title.toString()),
            );
          });
        }))
      ],),
    );
  }
}
