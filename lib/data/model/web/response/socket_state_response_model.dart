enum SocketStateEnum {
  INIT,
  CONNECTED,
  DISCONNECTED,
  ERROR,
}

class SocketStateResponseModel {
  final String message;
  final SocketStateEnum state;

  const SocketStateResponseModel(
    this.message,
    this.state,
  );
}
