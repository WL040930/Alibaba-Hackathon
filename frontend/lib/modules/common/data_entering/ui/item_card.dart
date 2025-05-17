import 'package:finance/modules/common/data_entering/model/item.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ItemCard extends StatelessWidget {
  final Item item;
  final VoidCallback? onEdit;
  final bool showEditIcon;

  const ItemCard({
    required this.item,
    this.onEdit,
    this.showEditIcon = true,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final formattedDate = DateFormat(
      'yyyy-MM-dd',
    ).format(item.date != null ? DateTime.parse(item.date!) : DateTime.now());

    return Card(
      color: Colors.grey[50], 
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Stack(
          children: [
            // Main content
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Category Icon
                CircleAvatar(
                  backgroundColor: Colors.grey[200],
                  radius: 24,
                  child: Icon(
                    item.getCategoryEnum().icon,
                    color: Colors.grey[700],
                  ),
                ),
                const SizedBox(width: 16),

                // Transaction Details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.transactionName ?? "Transaction",
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        item.category ?? "Others",
                        style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        formattedDate,
                        style: TextStyle(fontSize: 13, color: Colors.grey[500]),
                      ),
                    ],
                  ),
                ),

                // Amount
                Text(
                  '\$${item.amount?.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.redAccent,
                  ),
                ),
              ],
            ),

            // Edit Button
            if (showEditIcon)
              Positioned(
                top: 30,
                right: 0,
                child: IconButton(
                  icon: const Icon(
                    Icons.edit,
                    size: 20,
                    color: Colors.blueGrey,
                  ),
                  onPressed: onEdit ?? () {},
                  tooltip: 'Edit',
                ),
              ),
          ],
        ),
      ),
    );
  }
}
