enum SocketStateEnum {
  INIT,
  CONNECTED,
  DISCONNECTED,
  ERROR,
}

//enumlar ortak dosyaya taşınabilir.
enum SocketActionEnum {
  REQUEST('40'),
  RESEND('42'),
  REFRESH('2'),
  INIT_DATA('0'),
  DISCONNECT('-1'),
  NOT_IN_LIST('-1');

  final String value;
  const SocketActionEnum(this.value);
}
