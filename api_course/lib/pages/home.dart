import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:api_course/models/post_model.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  // Future function to fetch data from API
  
    // this function will return the Future
    // containing the list of models
    // http.get: This method sends a GET request to the specified URL.
    // Uri.parse: Converts the string URL into a Uri object that http.get can use
    // create variable named response to store the data come from api
    // response.body: Contains the raw JSON string returned from the API
    // jsonDecode: Converts the JSON string into a Dart object
    //(in this case, a List of Map<String, dynamic>
    // because the API returns a list of posts).
    // response.statusCode: Contains the HTTP status code of the response
    //(e.g., 200 for success, 404 for not found).
    // 200: HTTP status code indicating that the request was successful
    // Map<String, dynamic> i:
    //Each item in the JSON data is a map representing a single post.
  Future<List<PostModel>> getPostApi() async {
    try {
      final response = await http.get(Uri.parse("https://jsonplaceholder.typicode.com/posts"));

      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body.toString());

        // Initialize an empty list of PostModel
        List<PostModel> postList = [];

        // Iterate through each item in the JSON data
        for (var json in data) {
          // Convert each JSON object to a PostModel and add it to the list
          postList.add(PostModel.fromJson(json));
        }

        return postList; // Return the populated list of PostModel
      } else {
        throw Exception('Failed to load posts');
      }
    } catch (e) {
      print('Error: $e');
      return []; // Return an empty list in case of an error
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("API COURSE"),
      ),
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder<List<PostModel>>(
              future: getPostApi(),
              builder: (context, snapshot) {
                // Check if the Future is still loading
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                // Check if there was an error
                else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }
                // If the data is loaded
                else if (snapshot.hasData) {
                  List<PostModel> postList = snapshot.data!; // Use the data from the FutureBuilder snapshot
                  return ListView.builder(
                    itemCount: postList.length,
                    itemBuilder: (context, index) {
                      return Card(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                            Text('Title:\n${postList[index].title}'),
                            Text('Descreption:\n${postList[index].body}'),
                          ],),
                        ),
                      );
                    },
                  );
                }
                // If the Future is complete but has no data
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
