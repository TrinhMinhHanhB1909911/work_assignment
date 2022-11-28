import 'package:flutter/material.dart';

import '../../models/task.dart';
import 'task_tile.dart';

class SearchScreen extends SearchDelegate {
  SearchScreen(this.tasks);
  final List<Task> tasks;
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          query = '';
        },
        icon: const Icon(Icons.clear),
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        FocusScope.of(context).requestFocus();
        close(context, null);
      },
      icon: const Icon(Icons.arrow_back),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    List<Task> matchQuery = [];
    for (var task in tasks) {
      if (task.title.toLowerCase().contains(query.toLowerCase())) {
        matchQuery.add(task);
      }
    }
    return query.isNotEmpty
        ? CustomScrollView(
            slivers: [
              SliverAppBar(
                toolbarHeight: 40.0,
                leadingWidth: double.infinity,
                pinned: true,
                automaticallyImplyLeading: false,
                leading: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    SizedBox(height: 8.0),
                    Padding(
                      padding: EdgeInsets.only(left: 8.0),
                      child: Text(
                        'Kết quả',
                        style: TextStyle(
                          fontSize: 24.0,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // SliverGrid(
              //   delegate: SliverChildBuilderDelegate(
              //     childCount: matchQuery.length,
              //     (context, index) => ProductWidget(product: matchQuery[index]),
              //   ),
              //   gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              //       crossAxisCount: 2, mainAxisExtent: 240.0),
              // ),
              SliverList(
                delegate: SliverChildListDelegate([
                  for (var task in matchQuery) TaskTile(task: task),
                  Visibility(
                    visible: matchQuery.isEmpty,
                    child: const Center(
                      child: Text(
                        'không tìm thấy Lịch công tác nào',
                        style: TextStyle(color: Colors.red, fontSize: 16.0),
                      ),
                    ),
                  ),
                ]),
              ),
            ],
          )
        : const SizedBox();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final matchQuery = <String>[];
    for (var task in tasks) {
      if (task.title.toLowerCase().contains(query.toLowerCase())) {
        matchQuery.add(task.title.toLowerCase());
      }
    }
    return ListView.builder(
      itemCount: matchQuery.length,
      itemBuilder: (context, index) {
        return ListTile(
          onTap: () {
            // FocusScope.of(context).requestFocus(FocusNode());
            query = matchQuery[index];
            showResults(context);
          },
          title: Text(matchQuery[index]),
        );
      },
    );
  }
}
