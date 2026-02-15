/// Localized messages for each supported language.
///
/// Keys are BCP-47 language codes that match what FlutterTts expects.
class AppTranslations {
  static const Map<String, _LangPack> _packs = {
    'en-US': _LangPack(
      name: 'English',
      flag: '🇺🇸',
      intro:
          'Please point the camera to the banknote and capture it by pressing the capture button or volume keys.',
      result: 'This is {label} Ethiopian birr.',
      scanning: 'Scanning for banknotes...',
      detected: 'Banknote detected!',
      noDetection: 'No banknote detected. Please try again.',
      autoModeOn: 'Auto detect mode is on.',
      autoModeOff: 'Auto detect mode is off.',
    ),
    'am-ET': _LangPack(
      name: 'አማርኛ',
      flag: '🇪🇹',
      intro: 'እባክዎ ካሜራውን ወደ ገንዘቡ ያነሱ እና የመያዝ ቁልፍን ወይም የድምጽ ቁልፎችን ይጫኑ።',
      result: 'ይህ {label} የኢትዮጵያ ብር ነው።',
      scanning: 'ገንዘብ በመፈለግ ላይ...',
      detected: 'ገንዘብ ተገኝቷል!',
      noDetection: 'ገንዘብ አልተገኘም። እባክዎ እንደገና ይሞክሩ።',
      autoModeOn: 'ራስ-ሰር የመለየት ሁነታ በርቷል።',
      autoModeOff: 'ራስ-ሰር የመለየት ሁነታ ጠፍቷል።',
    ),
    'om-ET': _LangPack(
      name: 'Afaan Oromoo',
      flag: '🇪🇹',
      intro:
          'Maaloo kaameraa gara maallaqa sanduuqaatti qajeelchaa qabduu qabachuu ykn furtuu sagalee dhiibaa.',
      result: 'Kun birrii {label} Itoophiyaati.',
      scanning: 'Maallaqaa barbaadaa jira...',
      detected: 'Maallaqni argame!',
      noDetection: 'Maallaqni hin argamne. Maaloo irra deebi\'aa yaali.',
      autoModeOn: 'Haalli ofumaan adda baasuu banameera.',
      autoModeOff: 'Haalli ofumaan adda baasuu cufameera.',
    ),
    'ti-ET': _LangPack(
      name: 'ትግርኛ',
      flag: '🇪🇹',
      intro: 'በጃኹም ካሜራ ናብ ገንዘብ ኣቕንዑ እሞ ናይ ምሓዝ መፋትሕ ወይ ናይ ድምጺ መፋትሕ ጠውቑ።',
      result: 'እዚ {label} ናይ ኢትዮጵያ ብር እዩ።',
      scanning: 'ገንዘብ ይደሊ ኣሎ...',
      detected: 'ገንዘብ ተረኺቡ!',
      noDetection: 'ገንዘብ ኣይተረኽበን። በጃኹም ደጊምኩም ፈትኑ።',
      autoModeOn: 'ባዕሉ ዝለሊ ኣገባብ ተኸፊቱ ኣሎ።',
      autoModeOff: 'ባዕሉ ዝለሊ ኣገባብ ተዓጽዩ ኣሎ።',
    ),
  };

  /// Returns the pack for a given language code, falls back to English.
  static _LangPack _pack(String code) => _packs[code] ?? _packs['en-US']!;

  static String name(String code) => _pack(code).name;
  static String flag(String code) => _pack(code).flag;
  static String intro(String code) => _pack(code).intro;
  static String scanning(String code) => _pack(code).scanning;
  static String detected(String code) => _pack(code).detected;
  static String noDetection(String code) => _pack(code).noDetection;
  static String autoModeOn(String code) => _pack(code).autoModeOn;
  static String autoModeOff(String code) => _pack(code).autoModeOff;

  static String result(String code, String label) =>
      _pack(code).result.replaceAll('{label}', label);

  static List<String> get supportedCodes => _packs.keys.toList();
}

class _LangPack {
  final String name;
  final String flag;
  final String intro;
  final String result;
  final String scanning;
  final String detected;
  final String noDetection;
  final String autoModeOn;
  final String autoModeOff;

  const _LangPack({
    required this.name,
    required this.flag,
    required this.intro,
    required this.result,
    required this.scanning,
    required this.detected,
    required this.noDetection,
    required this.autoModeOn,
    required this.autoModeOff,
  });
}
