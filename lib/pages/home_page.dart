import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:provider/provider.dart';

import 'package:band_names/providers/socket_provider.dart';
import '../models/band.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Band> bands = [
    // Band(id: "1", name: "Metalica", votes: 5),
    // Band(id: "2", name: "Linkin park", votes: 3),
    // Band(id: "3", name: "Nirvana", votes: 2),
    // Band(id: "4", name: "Bon Jovi", votes: 1),
  ];

  @override
  void initState() {
    final socketProvider = Provider.of<SocketProvider>(context, listen: false);
    socketProvider.socket.on("bandas-activas", _handleActiveBands);
    super.initState();
  }

  void _handleActiveBands(dynamic payload) {
    bands = (payload as List).map((band) => Band.fromMap(band)).toList();
    setState(() {});
  }

  @override
  void dispose() {
    final socketProvider = Provider.of<SocketProvider>(context, listen: false);
    //Unbinds el evento bandas activas del socket para que no lo escuche mas.
    socketProvider.socket.off("bandas-activas");
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final socketProvider = Provider.of<SocketProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "BandNames",
          style: TextStyle(color: Colors.black87),
        ),
        backgroundColor: Colors.white,
        elevation: 1,
        actions: [
          Container(
              margin: const EdgeInsets.only(right: 10),
              child: socketProvider.serverStatus == ServerStatus.Online
                  ? Icon(Icons.check_circle_outline, color: Colors.blue[300])
                  : Icon(Icons.offline_bolt_outlined, color: Colors.red[300]))
        ],
      ),
      body: Column(
        children: [
          if(bands.isNotEmpty)
            _showGraph(),
          //Si no podemos el expanded, ListView no sabe cuando espacio tiene, y falla
          //ya que necesita saberlo.
          const SizedBox(height: 15),
          Expanded(
            child: ListView.builder(
                itemCount: bands.length,
                itemBuilder: (context, index) => _bandTile(bands[index])),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: addNewBand,
        elevation: 1,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _bandTile(Band band) {
    final socketProvider = Provider.of<SocketProvider>(context, listen: false);
    return Dismissible(
      key: Key(band.id),
      direction: DismissDirection.startToEnd,
      onDismissed: (direction) =>
          socketProvider.socket.emit("banda-eliminada", {"id": band.id}),
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
        onTap: () =>
            socketProvider.socket.emit("votacion-banda", {"id": band.id}),
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
        builder: (context) => AlertDialog(
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
            ));
  }

  void addBandToList(String name) {
    final socketProvider = Provider.of<SocketProvider>(context, listen: false);
    if (name.length > 1) {
      socketProvider.socket.emit("nueva-banda", {"name": name});
    }

    Navigator.pop(context);
  }

  Widget _showGraph() {
    Map<String, double> dataMap = {};
    bands.forEach((band) {
      dataMap[band.name] = band.votes.toDouble();
    });
    final List<Color> colores = [
      Colors.blue,
      Colors.blue[200]!,
      Colors.pink,
      Colors.pink[200]!,
      Colors.yellow,
      Colors.yellow[200]!,

    ];
    //Creacion y edicion de la grafica
    return PieChart(
      dataMap: dataMap,
      colorList: colores,
      legendOptions: const LegendOptions(
        legendPosition: LegendPosition.left,
        legendShape: BoxShape.rectangle,
      ),
      chartValuesOptions: const ChartValuesOptions(
        showChartValueBackground: false,
        showChartValues: true,
        showChartValuesInPercentage: true,
        showChartValuesOutside: false,
        decimalPlaces: 1,
      ),
    );
  }
}
