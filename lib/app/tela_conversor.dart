import 'package:app_conversor_moeda/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

const request = "https://api.hgbrasil.com/finance?key=6a77e7e3";

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final realController = TextEditingController();
  final dolarController = TextEditingController();
  final euroController = TextEditingController();

  double dolar;
  double euro;

  void _realChanged(String text) {
    double real = double.parse(text);
    dolarController.text = (real / dolar).toStringAsFixed(2);
    euroController.text = (real / euro).toStringAsFixed(2);
  }

  void _dolarChanged(String text) {
    double dolar = double.parse(text);
    realController.text = (dolar * this.dolar).toStringAsFixed(2);
    euroController.text = (dolar / this.dolar / euro).toStringAsFixed(2);
  }

  void _euroChanged(String text) {
    double dolar = double.parse(text);
    realController.text = (euro * this.euro).toStringAsFixed(2);
    euroController.text = (euro * this.euro / dolar).toStringAsFixed(2);
  }

 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(
          "Conversor Moeda",
          style: TextStyle(color: Colors.black, fontSize: 25.0),
        ),
        backgroundColor: Colors.amber,
        centerTitle: true,
      ),
      body: FutureBuilder<Map>(
        future: getDados(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
              return Center(
                child: Text("Carregando dados...",
                    style: TextStyle(color: Colors.amber, fontSize: 25.0),
                    textAlign: TextAlign.center),
              );
            default:
              if (snapshot.hasError) {
                return Center(
                  child: Text(
                    "Erro ao carregar os dados...",
                    style: TextStyle(color: Colors.amber, fontSize: 25.0),
                    textAlign: TextAlign.center,
                  ),
                );
              } else {
                dolar = snapshot.data["results"]["currencies"]["USD"]["buy"];
                euro = snapshot.data["results"]["currencies"]["EUR"]["buy"];
                print(euro);
                return SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Icon(
                        Icons.monetization_on,
                        size: 150.0,
                        color: Colors.amber,
                      ),
                      TextField(
                        controller: realController,
                        decoration: InputDecoration(
                          labelText: "Reais",
                          labelStyle: TextStyle(color: Colors.amber),
                          border: OutlineInputBorder(),
                          prefixText: "R\$",
                        ),
                        style: TextStyle(color: Colors.amber, fontSize: 25.0),
                        onChanged: _realChanged,
                        keyboardType:
                            TextInputType.numberWithOptions(decimal: true),
                      ),
                      Divider(),
                      TextField(
                        controller: dolarController,
                        decoration: InputDecoration(
                          labelText: "Dolares",
                          labelStyle: TextStyle(color: Colors.amber),
                          border: OutlineInputBorder(),
                          prefixText: "US\$",
                        ),
                        style: TextStyle(color: Colors.amber, fontSize: 25.0),
                        onChanged: _dolarChanged,
                        keyboardType:
                            TextInputType.numberWithOptions(decimal: true),
                      ),
                      Divider(),
                      TextField(
                        controller: euroController,
                        decoration: InputDecoration(
                          labelText: "Euros",
                          labelStyle: TextStyle(color: Colors.amber),
                          border: OutlineInputBorder(),
                          prefixText: "\$",
                        ),
                        style: TextStyle(color: Colors.amber, fontSize: 25.0),
                        onChanged: _euroChanged,
                        keyboardType:
                            TextInputType.numberWithOptions(decimal: true),
                      )
                    ],
                  ),
                );
              }
          }
        },
      ),
    );
  }

  Future<Map> getDados() async {
    http.Response response = await http.get(request);
    return json.decode(response.body);
  }
}
