import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:band_names/providers/socket_provider.dart';

class StatusPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final socketProvider = Provider.of<SocketProvider>(context);

    return Scaffold(
      body: Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Text("Server status: ${socketProvider.serverStatus}",
              style: const TextStyle(fontSize: 23))
        ]),
      ),
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.message),
          onPressed: () {
            socketProvider.socket.emit("emitir-mensaje",
                {"nombre": "Flutter", "mensaje": "Hola desde flutter"});
          }),
    );
  }
}
