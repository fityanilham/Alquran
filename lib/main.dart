import 'dart:convert'; //tipe data json 
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:http/http.dart' as http;
import 'dart:async';

void main() {
  runApp(MaterialApp (
    title: "Al-Quran",
    home: HalamanJson(),
  ));
}

class HalamanJson extends StatefulWidget {
  @override
  _HalamanJsonState createState() => _HalamanJsonState();
}

class _HalamanJsonState extends State<HalamanJson> {
  int nomor;
  List datadariJSON;

  Future ambildata() async {
    http.Response hasil = await http.get(
      Uri.encodeFull("https://al-quran-8d642.firebaseio.com/data.json?print=pretty"),
        headers: {"Accept": "application/json"}
    );

    this.setState(() {
      datadariJSON = json.decode(hasil.body);
    });    
  }

  @override
  void initState() {
    this.ambildata();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Al-Quran"),
      ),
      body: Container(
        child: ListView.builder(
          itemCount: datadariJSON == null ? 0 : datadariJSON.length,
          itemBuilder: (context, i) {
            return ListTile(
              title: Text(datadariJSON[i]['nama'] ?? ""),
              subtitle: Text(
                datadariJSON[i]['type'] +
                " | " +
                datadariJSON[i]['ayat'].toString() +
                "ayat" ??
                ""
              ),
              trailing: Icon(Icons.keyboard_arrow_right),
              onTap: () {
                Navigator.push(
                  context, 
                  MaterialPageRoute(
                    builder: (context) {
                      var datadariJSON2 = datadariJSON[i];
                      return DetailAlQuran(
                        nomor: datadariJSON2['nomor'],
                        nama: datadariJSON2['nama'],
                      );
                    },
                  ),
                );
              },
            );
          }
        ),
      ),
    );
  }
}

class DetailAlQuran extends StatefulWidget {
  final String nomor;
  final String nama;

  DetailAlQuran({this.nomor, this.nama});
  @override
  _DetailAlQuran createState() => _DetailAlQuran();
}

class _DetailAlQuran extends State<DetailAlQuran> {
  List dataAlquranJSON;

  Future ambildata() async {
    http.Response hasil = await http.get(
        Uri.encodeFull(
            "https://al-quran-8d642.firebaseio.com/surat/${widget.nomor}.json?print=pretty"),
        headers: {"Accept": "application/json"});

    this.setState(() {
      dataAlquranJSON = json.decode(hasil.body);
    });
  }

  @override
  void initState() {
    this.ambildata();
  }

  // final String data = ambildata();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(" ${widget.nama}"),
      ),
      body: Container(
        child: ListView.builder(
          itemCount: dataAlquranJSON == null ? 0 : dataAlquranJSON.length,
          itemBuilder: (context, i) {
            return ListTile(
              title: Text(dataAlquranJSON[i]['ar'] ?? ""),
              subtitle: Container(
                child: Column(
                  children: [
                    Text(dataAlquranJSON[i]['ar'] ?? ""),
                    Html(data: dataAlquranJSON[i]['tr'] ?? ""),
                    // import flutter_html dulu di pubspec.yml di dependencies:
                    // flutter:
                    //   sdk: flutter
                    // http: ^0.12.0+1
                    // flutter_html: 
                    Text(dataAlquranJSON[i]['id'] ?? "")
                  ],
                ),
              ),
//              subtitle: Html(data: dataAlquranJSON[i]['s'] ?? ""),
            );
          },
        ),
      ),
    );
  }
}
