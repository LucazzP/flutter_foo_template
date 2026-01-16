import 'package:flutter/widgets.dart';
import 'generated/app_localizations.dart' as l;

extension AppLocalizations on l.AppLocalizations {
  static late l.AppLocalizations current;

  static l.AppLocalizations of(BuildContext context) => l.AppLocalizations.of(context) ?? current;

  static const LocalizationsDelegate<l.AppLocalizations> delegate = l.AppLocalizations.delegate;
  static const List<Locale> supportedLocales = l.AppLocalizations.supportedLocales;

  static Future<void> initialize(BuildContext context) async {
    final locale = Localizations.of<l.AppLocalizations>(context, l.AppLocalizations);
    if (locale == null) {
      current = await l.AppLocalizations.delegate.load(Locale('en'));
    } else {
      current = locale;
    }
  }

  Locale get locale {
    final splitedLocale = localeName.split('_');
    final languageCode = splitedLocale[0];
    final countryCode = splitedLocale.length > 1 ? splitedLocale[1] : '';
    return Locale(languageCode, countryCode);
  }
}
