class CalculateProfitEntity {
  final String currencyCode;
  final double purchasePriceTotal;
  final double latestPriceTotal;

  CalculateProfitEntity({
    required this.currencyCode,
    required this.purchasePriceTotal,
    required this.latestPriceTotal,
  });

  double get profitPercent =>
      100 - ((latestPriceTotal * 100) / purchasePriceTotal);
  double get profit => latestPriceTotal - purchasePriceTotal;
}
