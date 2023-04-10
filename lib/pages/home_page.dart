import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../models/band.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Band> bands = [
    Band(id: "1", name: "Metalica", votes: 5),
    Band(id: "2", name: "Linkin park", votes: 3),
    Band(id: "3", name: "Nirvana", votes: 2),
    Band(id: "4", name: "Bon Jovi", votes: 1),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "BandNames",
          style: TextStyle(color: Colors.black87),
        ),
        backgroundColor: Colors.white,
        elevation: 1,
      ),
      body: ListView.builder(
          itemCount: bands.length,
          itemBuilder: (context, index) => _bandTile(bands[index])),
      floatingActionButton: FloatingActionButton(
        onPressed: addNewBand,
        elevation: 1,
        child: Icon(Icons.add),
      ),
    );
  }

  Widget _bandTile(Band band) {
    return Dismissible(
      key: Key(band.id),
      direction: DismissDirection.startToEnd,
      onDismissed: (direction) {
        print(direction);
        print(band.id);
      },
      background: Container(
          padding: const EdgeInsets.only(left: 8),
          color: Colors.grey.withOpacity(0.5),
          child: const Align(
              alignment: Alignment.centerLeft,
              child:
                  Text("Delete band", style: TextStyle(color: Colors.black)))),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.blue[100],
          child: Text(band.name.substring(0, 2)),
        ),
        title: Text(band.name),
        trailing: Text("${band.votes}", style: const TextStyle(fontSize: 20)),
        onTap: () {
          print("${band.name}");
        },
      ),
    );
  }

  addNewBand() {
    final textEditingController = TextEditingController();
    //Lo comento porque me hace fallar la parte web.
    // if (Platform.isIOS) {
    //   //Esto es para cuando esta en IOS
    //   showCupertinoDialog(
    //       context: context,
    //       builder: (context) {
    //         return CupertinoAlertDialog(
    //           title: Text("New band name"),
    //           content: CupertinoTextField(
    //             controller: textEditingController,
    //           ),
    //           actions: [
    //             CupertinoDialogAction(
    //               isDefaultAction: true,
    //               child: const Text("add"),
    //               onPressed: () => addBandToList(textEditingController.text),
    //             ),
    //             CupertinoDialogAction(
    //               isDefaultAction: true,
    //               child: const Text("dismiss"),
    //               onPressed: () => Navigator.pop(context),
    //             )
    //           ],
    //         );
    //       });
    // }
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("New band name: "),
            content: TextField(
              controller: textEditingController,
            ),
            actions: <Widget>[
              MaterialButton(
                onPressed: () => addBandToList(textEditingController.text),
                elevation: 5,
                textColor: Colors.blue,
                child: const Text("Add"),
              )
            ],
          );
        });
  }

  void addBandToList(String name) {
    if (name.length > 1) {
      bands.add(Band(id: DateTime.now().toString(), name: name, votes: 0));
      setState(() {});
    }

    Navigator.pop(context);
  }
}
