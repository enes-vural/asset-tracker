extension AssetExtension on String {
  static const mainLogo = "main_logo";

  static String toPng(String asset) {
    return "assets/image/$asset.png";
  }
}
