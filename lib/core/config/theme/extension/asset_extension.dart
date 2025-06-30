extension AssetExtension on String {
  String toPng() => "assets/image/$this.png";
  String toCurrencyPng() => "assets/image/currency/$this.png";
  String toSvg() => "assets/image/$this.svg";
  String toJpeg() => "assets/image$this.jpeg";
  String toJpg() => "assets/image$this.jpg";
}
