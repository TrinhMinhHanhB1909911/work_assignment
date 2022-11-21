import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class TaskShimmer extends StatelessWidget {
  const TaskShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      direction: ShimmerDirection.ttb,
      baseColor: Colors.grey,
      highlightColor: Colors.white,
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        itemCount: 5,
        itemBuilder: (context, _) => const ShimmerTile(),
      ),
    );
  }
}

class ShimmerTile extends StatelessWidget {
  const ShimmerTile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          color: Colors.grey.shade100,
        ),
        height: 80,
      ),
    );
  }
}
