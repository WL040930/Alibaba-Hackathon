import 'package:flutter/material.dart';
import 'package:finance/core/widget/k_app_bar.dart';
import 'package:finance/core/widget/k_padding.dart';
import 'package:finance/core/widget/k_page.dart';
import 'package:finance/modules/common/wishlist/wishlist_details.dart';

class WishlistPage extends StatefulWidget {
  const WishlistPage({super.key});

  @override
  State<WishlistPage> createState() => _WishlistPageState();
}

class _WishlistPageState extends State<WishlistPage> {
  @override
  Widget build(BuildContext context) {
    return KPage(
      child: Scaffold(
        appBar: KAppBar(title: const Text('Your Wishlist')),
        body: Padding(
          padding: KPadding.defaultPagePadding,
          child: ListView(
            children: [
              _buildWishlistItem(context, 'New Laptop', 'Save \$100 per month'),
              const SizedBox(height: 12),
              _buildWishlistItem(
                context,
                'Vacation',
                'Trip to Bali in December',
              ),
              const SizedBox(height: 12),
              _buildWishlistItem(context, 'New Phone', 'Upgrade next year'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWishlistItem(
    BuildContext context,
    String title,
    String description,
  ) {
    return Card(
      elevation: 2,
      child: InkWell(
        onTap: () {
          // Show details about the wishlist item
          showWishlistItemDetails(
            context,
            title,
            description,
            '', // Empty icon
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            title,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.info_outline),
                          onPressed: () {
                            showWishlistItemDetails(
                              context,
                              title,
                              description,
                              '', // Empty icon
                            );
                          },
                          tooltip: 'View details',
                          constraints: const BoxConstraints(),
                          padding: EdgeInsets.zero,
                          iconSize: 20,
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
