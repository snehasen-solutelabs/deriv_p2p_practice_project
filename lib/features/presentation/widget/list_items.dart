import 'package:deriv_p2p_practice_project/api/models/advert.dart';
import 'package:flutter/material.dart';

/// Advert list items
class ListItems extends StatelessWidget {
  /// Init Widget
  const ListItems({required this.item, Key? key}) : super(key: key);

  /// advert item
  final Advert item;

  @override
  Widget build(BuildContext context) => Container(
        color: Colors.grey[800],
        padding: const EdgeInsets.all(8),
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        // padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text(
              'Name : ${item.advertiserDetails?.name ?? ''}',
              style: const TextStyle(color: Colors.white),
            ),
            const SizedBox(height: 8),
            Text(
              'ID : ${item.id ?? ''}',
              style: const TextStyle(color: Colors.white),
            ),
            const SizedBox(height: 8),
            Text(
              'Amount : ${item.priceDisplay}',
              style: const TextStyle(color: Colors.white),
            ),
            const SizedBox(height: 8),
            Text(
              'Description : ${item.description ?? ''}',
              style: const TextStyle(color: Colors.white),
            ),
          ],
        ),
      );
}
