import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

class KSkeletonList extends StatelessWidget {
  final int itemCount;

  const KSkeletonList({super.key, this.itemCount = 5});

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      enabled: true,
      child: ListView.builder(
        itemCount: itemCount,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Icon skeleton
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 12),

                // Text lines skeleton
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: double.infinity,
                        height: 16,
                        color: Colors.grey,
                      ),
                      const SizedBox(height: 6),
                      Container(width: 100, height: 14, color: Colors.grey),
                    ],
                  ),
                ),

                // Amount skeleton
                Container(
                  width: 50,
                  height: 16,
                  color: Colors.grey,
                  margin: const EdgeInsets.only(left: 10),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
