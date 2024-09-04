import 'dart:convert';

import 'package:api_course/models/post_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Example1 extends StatefulWidget {
  const Example1({super.key});

  @override
  State<Example1> createState() => _Example1State();
}

class _Example1State extends State<Example1> {
  List<PostModel> postList = [];

  Future<List<PostModel>> getPostApi() async {
    try {
      final response = await http
          .get(Uri.parse("https://jsonplaceholder.typicode.com/posts"));
      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body.toString());

        for (var i in data) {
          postList.add(PostModel.fromJson(i));
        }
        return postList;
      } else {
        return throw Exception("Failed to load data");
      }
    } catch (e) {
      Text("Error, $e");
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Example of API"),
      ),
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder<List<PostModel>>(
              future: getPostApi(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (snapshot.hasError) {
                  return Text("error ${snapshot.error}");
                } else if (snapshot.hasData) {
                  return ListView.builder(
                    itemCount: postList.length,
                    itemBuilder: (context, index) {
                      return Card(
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                  "Title: ${postList[index].title.toString()}"),
                              Text("Description: ${postList[index].body.toString()}"),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                }
                else {
                  return const Center(child: Text('No data found.'));
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
