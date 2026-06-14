class SearchUtils {
  static String stripAccents(String text) {
    return text
        .toLowerCase()
        .replaceAll(RegExp(r'[áàäâã]'), 'a')
        .replaceAll(RegExp(r'[éèëê]'), 'e')
        .replaceAll(RegExp(r'[íìïî]'), 'i')
        .replaceAll(RegExp(r'[óòöôõ]'), 'o')
        .replaceAll(RegExp(r'[úùüû]'), 'u')
        .replaceAll('ñ', 'n');
  }

  static bool match(String source, String query) {
    if (query.trim().isEmpty) return true;
    return stripAccents(source).contains(stripAccents(query));
  }
}
