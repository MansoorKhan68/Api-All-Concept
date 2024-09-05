import 'dart:convert';

import 'package:api_course/models/users_model';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Example3Api extends StatefulWidget {
  const Example3Api({super.key});

  @override
  State<Example3Api> createState() => _Example3ApiState();
}

class _Example3ApiState extends State<Example3Api> {
  // empty list to store data in the future
  List<UsersModel> userList = [];
  // Future function to get data from api

  Future<List<UsersModel>> getUserData() async {
    try {
      final response = await http
          .get(Uri.parse("https://jsonplaceholder.typicode.com/users"));
      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body.toString());
        for (var i in data) {
          userList.add(UsersModel.fromJson(i));
        }
        return userList;
      } else {
        throw Exception("Some thing went wrong");
      }
    } catch (e) {
      Text("Error: $e");
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Example 3 complex json'),
      ),
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder(
                future: getUserData(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text("Error ${snapshot.error}"),
                    );
                  } else if (snapshot.hasData) {
                    List<UsersModel> userList = snapshot.data!;
                    return ListView.builder(
                        itemCount: userList.length,
                        itemBuilder: (contex, index) {
                          return Card(
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Column(
                                children: [
                                  ReUsableRow(
                                    title: "Name",
                                    value:
                                        snapshot.data![index].name.toString(),
                                  ),
                                  ReUsableRow(
                                    title: "UserName",
                                    value: snapshot.data![index].username
                                        .toString(),
                                  ),
                                  ReUsableRow(
                                    title: "Address",
                                    value: snapshot
                                        .data![index].address!.geo!.lat
                                        .toString(),
                                  ),
                                ],
                              ),
                            ),
                          );
                        });
                  }
                  // If the Future is complete but has no data
                  else {
                    return const Center(child: Text('No data found.'));
                  }
                }),
          ),
        ],
      ),
    );
  }
}

class ReUsableRow extends StatelessWidget {
  final String title;
  final value;
  ReUsableRow({super.key, required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title),
        Text(value),
      ],
    );
  }
}
