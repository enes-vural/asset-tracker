class RegExpConstant {
  static final RegExp emailCheckRegExp = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
  static final RegExp onlyNumbersAndDot = RegExp(r'^\d+(\.\d+)?$');
  static final RegExp divideBalance = RegExp(r'(\d)(?=(\d{3})+(?!\d))');
}
