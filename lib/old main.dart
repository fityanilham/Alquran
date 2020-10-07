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
      drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              DrawerHeader(
                // child: Image.network("https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcSejCufqekqw27KmFC7zMeec__1dBZnSMYcIA&usqp=CAU"),
                decoration: BoxDecoration(
                  color: Colors.blue[600]
                ),
              ),
              ListTile(
                title: Text('tea'),
                trailing: Icon(Icons.chevron_right),
                onTap: () {
                  // do something
                },
              ),
              ListTile(
                title: Text('dad'),
                trailing: Icon(Icons.chevron_right),
                onTap: () {
                  // do something
                },
              ),
            ],
          ),
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
              trailing: Icon(Icons.more_vert),
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
              trailing: Text(dataAlquranJSON[i]['nomor'] ?? ""),
              title: Text(dataAlquranJSON[i]['ar'] ?? "", textAlign: TextAlign.end,),
              subtitle: Container(
                child: Column(
                  children: [
                    // Text(dataAlquranJSON[i]['ar'] ?? ""),
                    Html(data: dataAlquranJSON[i]['tr'] ?? ""),
                    Text(dataAlquranJSON[i]['id'] ?? ""),
                    Html(
                      data: """
                      <div>
                        <hr>
                      </div>
                    """,
                    )
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
