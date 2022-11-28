import 'package:flutter/material.dart';
import 'package:work_assignment/models/staff.dart';
import 'package:work_assignment/views/widgets/staff_tile.dart';

class SearchStaffScreen extends SearchDelegate {
  SearchStaffScreen(this.staffs);
  final List<Staff> staffs;
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
    List<Staff> matchQuery = [];
    for (var staff in staffs) {
      if (staff.name.toLowerCase().contains(query.toLowerCase())) {
        matchQuery.add(staff);
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
                delegate: SliverChildListDelegate(
                  [
                    for (var staff in matchQuery) StaffTile(staff),
                    Visibility(
                      visible: matchQuery.isEmpty,
                      child: const Center(
                        child: Text(
                          'không tìm thấy nhân viên nào',
                          style: TextStyle(color: Colors.red, fontSize: 16.0),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          )
        : const SizedBox();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final matchQuery = <String>[];
    for (var staff in staffs) {
      if (staff.name.toLowerCase().contains(query.toLowerCase())) {
        matchQuery.add(staff.name.toLowerCase());
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
