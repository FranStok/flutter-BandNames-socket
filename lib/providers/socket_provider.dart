import 'package:flutter/material.dart';

import 'package:socket_io_client/socket_io_client.dart' as IO;

enum ServerStatus { Online, Offline, Connecting }

class SocketProvider extends ChangeNotifier {
  late ServerStatus _serverStatus = ServerStatus.Connecting;
  late IO.Socket _socket;
  SocketProvider() {
    _initConfig();
  }

  IO.Socket get socket => _socket;
  ServerStatus get serverStatus => _serverStatus;

  void _initConfig() {
    _socket = IO.io(
        'http://192.168.1.44:3000',
        IO.OptionBuilder()
            .setTransports(['websocket'])
            .enableAutoConnect()
            .build());
    _socket.onConnect((_) {
      print('connect');
      _serverStatus = ServerStatus.Online;
      notifyListeners();
    });
    _socket.onDisconnect((_) {
      print('disconnect');
      _serverStatus = ServerStatus.Offline;
      notifyListeners();
    });
    //Desde el navegador, en al consola pongo socket.emit("emitir-mensaje","Fran"), es decir,
    //desde el cliente navegador, emito el mensaje, que lo escuchan todos los clientes
    //con el metodo que esta en el backend en socket.js, emito el mensaje "nuevo-mensaje" a
    //todos los clientes. Luego, con este metodo escucho este "nuevo-mensaje" e imprime el payload.
    // socket.on("nuevo-mensaje", (payload) {
    //   print("Nuevo mensaje $payload");
    // });
  }
}
