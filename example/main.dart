import 'package:text_translator/text_translator.dart';

void main() async {
  String source;
  Translation translation;

  source = "Здравствуйте. Ты в порядке?";
  translation = await Translator().translate(source, to: 'en');
  print('Source: $source\nTranslated: $translation\n');

  source = "I would buy a car, if I had money.";
  translation = await Translator().translate(source, from: 'en', to: 'it');
  print('Source: $source\nTranslated: $translation\n');

  // For countries that default base URL doesn't work
  source = "This means 'testing' in chinese";
  translation = await Translator().translate(source, to: 'zh-cn', baseUrl: "translate.google.cn");
  print('Source: $source\nTranslated: $translation\n');

  source = "merhaba";
  translation = await Translator().translate(source, from: 'tr', to: 'ar');
  print('Source: $source\nTranslated: $translation\n');

  // Using String extension "string".translate() or "string".t()
  source = "hello";
  translation = await source.translate(to: 'ar');
  print('Source: $source\nTranslated: $translation');
}
