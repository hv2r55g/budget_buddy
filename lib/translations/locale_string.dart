import 'package:get/get.dart';

class LocaleString extends Translations {
  @override
  // TODO: implement keys
  Map<String, Map<String, String>> get keys => {
        //ENGLISH LANGUAGE
        'en': {
          'hello': 'Hello World',
          'message': 'Welcome to Proto Coders Point',
          'title': 'Flutter Language - Localization',
          'sub': 'Subscribe Now',
          'changelang': 'Change Language'
        },
        //HINDI LANGUAGE
        'nl': {
          'hello': 'hallokes',
          'message': 'bericht',
          'title': 'titel',
        },
      };
}
