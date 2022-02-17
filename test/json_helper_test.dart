import 'package:deriv_p2p_practice_project/features/core/helpers/json_helper.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('JSONHelper', () {
    test('should encode given object as stringified JSON', () {
      final Map<String, dynamic> response = <String, dynamic>{
        'userId': 1,
        'id': 1,
        'title': 'This is a test title',
      };

      const String result =
          '{"userId":1,"id":1,"title":"This is a test title"}';

      expect(JSONHelper.encode(response), result);
    });

    test('should decode given stringified JSON as object', () {
      const String response =
          '{"userId":1,"id":1,"title":"This is a test title"}';

      final Map<String, dynamic> result = <String, dynamic>{
        'userId': 1,
        'id': 1,
        'title': 'This is a test title',
      };

      expect(JSONHelper.decode(response), result);
    });

    test(
        'should decode given stringified JSON as object and '
        'normalize the given keys to array instead of object', () {
      const String response =
          '{"is_enabled":1,"method":"bank_transfer","display_name":'
          '"Bank Transfer","fields":{"account":{"display_name":"Account Number"'
          ',"required":1,"type":"text","value":"1234"},"bank_name":'
          '{"display_name":"Bank Name","required":1,"type":"text","value":'
          '"my bank"},"branch":{"display_name":"Branch","required":0,"type":'
          '"text","value":"001"}}}';

      final Map<String, dynamic> result = <String, dynamic>{
        'is_enabled': 1,
        'method': 'bank_transfer',
        'display_name': 'Bank Transfer',
        'fields': <Map<String, dynamic>>[
          <String, dynamic>{
            'display_name': 'Account Number',
            'required': 1,
            'type': 'text',
            'value': '1234',
            '_key': 'account'
          },
          <String, dynamic>{
            'display_name': 'Bank Name',
            'required': 1,
            'type': 'text',
            'value': 'my bank',
            '_key': 'bank_name'
          },
          <String, dynamic>{
            'display_name': 'Branch',
            'required': 0,
            'type': 'text',
            'value': '001',
            '_key': 'branch'
          }
        ]
      };

      expect(
        JSONHelper.decode(
          response,
          convertObjectToArrayKeys: <String>['fields'],
        ),
        result,
      );
    });

    test('Should return an empty list of object', () {
      const String response = '{}';
      final Map<String, dynamic> result = <String, dynamic>{};

      expect(JSONHelper.decode(response), result);
    });
  });
}
