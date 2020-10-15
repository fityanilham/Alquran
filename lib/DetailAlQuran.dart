import 'package:flutter/material.dart';
import 'package:alquran/viewModel/AyatViewModel.dart';

class DetailAlQuran extends StatefulWidget {
  final String nomor;
  final String nama;

  DetailAlQuran({this.nomor, this.nama});

  @override
  _DetailAlQuranState createState() => _DetailAlQuranState();
}

class _DetailAlQuranState extends State<DetailAlQuran> {
  List dataAyat = List();
  
  void getAyat() {
    AyatViewModel().getAyat(int.parse(widget.nomor)).then((value){
      setState(() {
        dataAyat = value;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    getAyat();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.nama}"),
        backgroundColor: Colors.blueGrey,
      ),
      body: dataAyat == null ? Center(
        child: CircularProgressIndicator(),
      ) :
      Card(
        color: Colors.grey[300],
        child: ListView.builder(
          padding: EdgeInsets.all(10),
          itemCount: dataAyat.length,
          itemBuilder: (context, i) {
            return Card(
              elevation: 2,
              child: ListTile(
                trailing: Text(dataAyat[i].nomor ?? "", ),
                title: Container(
                  padding: EdgeInsets.all(10),
                  child: Column(
                    children: [
                      Text(dataAyat[i].ar ?? "", textAlign: TextAlign.right,),
                      Text(dataAyat[i].id ?? "", textAlign: TextAlign.left,),
                    ],
                  ),
                ),
              ),
            );
          }
        ),
      )
    );
  }
}