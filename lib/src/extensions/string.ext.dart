extension StringExtensions on String {
  String get capitalizeFirstLetter =>
      isNotEmpty ? '${this[0].toUpperCase()}${substring(1).toLowerCase()}' : '';

  String get capitalizeAllFirstLetters =>
      replaceAll(RegExp(' +'), ' ').split(" ").map((str) => str.capitalizeFirstLetter).join(" ");

  String withEllipse({int maxLength = 78, bool keepExt = true}) => length > maxLength
      ? '${substring(0, maxLength - 3)}...'
          '${keepExt ? ' ' + substring(length - 4, length) : ''}'
      : this;

  String getNameFromEnum() {
    if (!contains('.')) return this;
    return replaceRange(0, indexOf('.') + 1, '');
  }
}

extension StringNullableExtensions on String? {
  bool get isNotNullAndNotEmpty {
    final string = this;
    return string != null && string.isNotEmpty;
  }

  String get getNotNullValue => this ?? '';
}
