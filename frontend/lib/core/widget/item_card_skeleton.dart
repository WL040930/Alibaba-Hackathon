import 'package:finance/core/widget/k_padding.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ItemCardSkeleton extends StatelessWidget {
  const ItemCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.grey[50],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Column(
            children: [
              SkeletonCard(),
              SkeletonCard(),
            ],
          ),
        ),
      ),
    );
  }
}

class SkeletonCard extends StatelessWidget {
  const SkeletonCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: KPadding.defaultPagePadding,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Circle avatar
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 16),
          // Text placeholders
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 16,
                  width: double.infinity,
                  color: Colors.white,
                ),
                const SizedBox(height: 8),
                Container(height: 14, width: 100, color: Colors.white),
                const SizedBox(height: 8),
                Container(height: 12, width: 80, color: Colors.white),
              ],
            ),
          ),
          const SizedBox(width: 12),
          // Amount placeholder
          Container(width: 50, height: 16, color: Colors.white),
        ],
      ),
    );
  }
}
