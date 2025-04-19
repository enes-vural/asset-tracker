///Class for deploy string
final class DefaultLocalStrings {
  //constructor of class
  DefaultLocalStrings._();

  static const emptyText = "";
  static const emptyBalance = "0.00";
  static const emptyFraction = "00";
  static const minus = "-";
  static const turkishLira = "₺";

  static const censoredText = "**********";
  //Router
  //dont localize here in future
  static const splashRoute = "/default_splash";
  static const loginRoute = "/app_login";
  static const registerRoute = "/app_register";
  static const homeRoute = "/home";
  static const dashboardRoute = "/dashboard";
  //trade route can be child path from home route.
  static const tradeRoute = "/trade/:currency";
  static const replaceInRouteName = "View,Route";

  static const currency = "currency";
  static const amount = "amount";
  static const price = "price";

  static const goldCoin = "gold_coin";
  static const chfCoin = "chf_coin";
  static const audCoin = "aud_coin";
  static const xauCoin = "xau_coin";
  static const sekCoin = "sek_coin";
  static const nokCoin = "nok_coin";
  static const jpyCoin = "jpy_coin";
  static const silverCoin = "silver_coin";
  static const xptCoin = "xpt_coin";
  static const sarCoin = "sar_coin";
  static const gbpCoin = "gbp_coin";
  static const cadCoin = "cad_coin";
  static const usdCoin = "usd_coin";
  static const euroCoin = "euro_coin";
  static const defaultCoin = "default_coin";
}
