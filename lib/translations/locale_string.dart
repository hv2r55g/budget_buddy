import 'package:get/get.dart';

class LocaleString extends Translations {
  @override
  // TODO: implement keys
  Map<String, Map<String, String>> get keys => {
        //ENGLISH LANGUAGE
        'en': {
          'hello': 'Hello World',
          'Food': 'food',
          'Rent': 'Rent',
          'Utilities': 'Utilities',
          'message': 'Welcome to Proto Coders Point',
          'title': 'Flutter Language - Localization',
          'sub': 'Subscribe Now',
          'changelang': 'Change Language'
        },
        //HINDI LANGUAGE
        'nl': {
          'hello': 'hallokes',
          'Food': 'eten',
          'Utilities': 'water enzo',
          'Rent': 'Huur',
          'message': 'bericht',
          'title': 'titel',
        },
      };
}
