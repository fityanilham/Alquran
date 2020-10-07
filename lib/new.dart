//import 'dart:html';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http; // mengambil content yang ada di internet
import 'dart:async'; // untuk asynchronous
import 'dart:convert'; // untuk tipe data Json

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'Al Quran XII RPL',
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
      Uri.encodeFull("https://al-quran-8d642.firebaseio.com/data.json?print=pretty "),
      headers: {"Accept": "application/json"});

    this.setState(() { datadariJSON = json.decode(hasil.body);
    });
  }

  @override
  void initState() {
      this.ambildata();
    }
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('AL Quran XII RPL'),
      ),
      body: Container(
        child: ListView.builder(
          itemCount: datadariJSON == null ? 0 : datadariJSON.length,
            itemBuilder: (context,i) {
            // subtitle = toString (datadariJSON[i][ayat]) ?? "";
              return ListTile(
                title: Text(datadariJSON[i]['nama'] ?? ""),
                subtitle: Text(datadariJSON[i]['type'] + " | " + datadariJSON[i]['ayat'].toString() + " ayat " ?? ""),
                trailing: Icon(Icons.keyboard_arrow_right),
                onTap: (){
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          var datadariJSON2 = datadariJSON[i];
                          return DetailAlQuran(
                            nomor : datadariJSON2['nomor'],
                            nama : datadariJSON2['nama']
                          );
                        }
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
              title: Container(
                child: Column(
                  children: <Widget>[
                    Text(dataAlquranJSON[i]['ar'] ?? ""),
                    Text(dataAlquranJSON[i]['tr'] ?? ""),
                    Text(dataAlquranJSON[i]['id'] ?? "")
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