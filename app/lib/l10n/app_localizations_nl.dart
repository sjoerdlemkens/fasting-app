// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Dutch Flemish (`nl`).
class AppLocalizationsNl extends AppLocalizations {
  AppLocalizationsNl([String locale = 'nl']) : super(locale);

  @override
  String get helloWorld => 'Hallo Wereld!';

  @override
  String get fastingEndNotificationTitle => 'Vasten Voltooid';

  @override
  String get fastingEndNotificationBody =>
      'Je hebt je doel bereikt. Goed gedaan!';
}
