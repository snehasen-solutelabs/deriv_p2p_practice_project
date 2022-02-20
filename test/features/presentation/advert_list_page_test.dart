import 'package:deriv_p2p_practice_project/api/models/advert.dart';
import 'package:flutter/material.dart';

import 'package:flutter_test/flutter_test.dart';

import 'advert_list_data.dart';

void main() {
  group('Advert list page widget list tests =>', () {
    testWidgets('Widget exists', (WidgetTester tester) async {
      final List<Advert> advertsList = adverts;

      await tester
          .pumpWidget(_TestList(adverts: advertsList, hasRemaining: true));

      await tester.idle();
      await tester.pumpAndSettle();

      expect(find.byType(ListView), findsOneWidget);
      expect(find.byType(Scrollable), findsOneWidget);

      final Finder listFinder = find.byType(Scrollable);
      final Finder itemFinder = find.byKey(const Key('adverts4'));

      // Scroll until the item to be found appears.
      await tester.scrollUntilVisible(itemFinder, 25, scrollable: listFinder);
      expect(itemFinder, findsOneWidget);
    });
  });
}

/// _Test App Scaffold
class _TestList extends StatefulWidget {
  /// Init State
  const _TestList({required this.adverts, required this.hasRemaining});

  /// adverts list
  final List<Advert> adverts;

  /// hasRemaining
  final bool hasRemaining;

  @override
  State<_TestList> createState() => _TestListAppState();
}

class _TestListAppState extends State<_TestList>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) => MaterialApp(
      home: Scaffold(
          body: ListView.builder(
              shrinkWrap: true,
              physics: const BouncingScrollPhysics(),
              itemCount: widget.hasRemaining
                  ? widget.adverts.length + 1
                  : widget.adverts.length,
              itemBuilder: (BuildContext context, int index) {
                if (index >= widget.adverts.length) {
                  return const Center(child: CircularProgressIndicator());
                } else {
                  final Advert item = widget.adverts[index];

                  return Container(
                      key: Key('adverts$index'),
                      margin: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text('Name : ${item.advertiserDetails?.name ?? ''}'),
                          const SizedBox(height: 8),
                          Text('ID : ${item.id ?? ''}'),
                          const SizedBox(height: 8),
                          Text('Amount : ${item.priceDisplay}'),
                          const SizedBox(height: 8),
                          Text('Description : ${item.description ?? ''}'),
                          const SizedBox(height: 8),
                          Text(
                            'Counter Party Type : ${item.counterPartyType ?? ''}',
                            style: const TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(4),
                          boxShadow: const <BoxShadow>[
                            BoxShadow(
                                color: Colors.grey,
                                blurRadius: 6,
                                spreadRadius: 2)
                          ]));
                }
              })));
}
