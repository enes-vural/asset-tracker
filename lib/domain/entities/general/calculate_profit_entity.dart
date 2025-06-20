class CalculateProfitEntity {
  final String currencyCode;
  final double amount;
  final double purchasePriceTotal;
  final double latestPriceTotal;

  CalculateProfitEntity({
    this.amount = 1.0,
    required this.currencyCode,
    required this.purchasePriceTotal,
    required this.latestPriceTotal,
  });

  double get profitPercent =>
      100 - ((latestPriceTotal * 100) / purchasePriceTotal);
  double get profit => (latestPriceTotal - purchasePriceTotal) * (amount);
}
