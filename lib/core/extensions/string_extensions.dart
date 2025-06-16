extension StringCasingExtension on String {
  String capitalizeWords() {
    final trimmed = trim();
    if (trimmed.isEmpty) return '';

    return trimmed
        .toLowerCase()
        .split(RegExp(r'\s+'))
        .where((word) => word.isNotEmpty)
        .map(
          (word) => word.length > 1
              ? word[0].toUpperCase() + word.substring(1)
              : word.toUpperCase(),
        )
        .join(' ');
  }
}
