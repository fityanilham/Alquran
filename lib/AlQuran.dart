import 'package:flutter/material.dart';
import 'package:alquran/viewModel/AlQuranViewModel.dart';
import 'package:alquran/DetailAlQuran.dart';
import 'jadwal.dart' as jadwal;

class AlQuran extends StatefulWidget {
  @override
  _AlQuranState createState() => _AlQuranState();
}

class _AlQuranState extends State<AlQuran> {
  List dataAlQuran = List();
  
  void getListSurat() {
    AlQuranViewModel().getAlQuran().then((value){
      setState(() {
        dataAlQuran = value;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    getListSurat();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Image.asset("assets/img/backApp.png"),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(200),
          child: Container(
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(15),
                  bottomRight: Radius.circular(15),
                )
              ),
              child: Container(
                child: FlatButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context, 
                      MaterialPageRoute(builder: (context) => jadwal.Home())
                    );
                  }, 
                  icon: Icon(
                    Icons.keyboard_arrow_right, 
                    color: Colors.grey[700], 
                  ),
                  label: Text(
                    "Mencari Lokasi ...",
                    style: TextStyle(
                      color: Colors.grey[700],
                      fontSize: 14
                    ),
                  )
                )
              )
            ),
          )
        ),
      ),
      body: dataAlQuran == null ? Center(
        child: CircularProgressIndicator(),
      ) :
      ListView.builder(
        itemCount: dataAlQuran.length,
        itemBuilder: (context, i) {
          return Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            color: Colors.grey[300],
            child: Container(
              child: Column(
                children: [
                  ListTile(
                    title: Text(dataAlQuran[i].nama),
                    subtitle: Text("${dataAlQuran[i].type} | ${dataAlQuran[i].ayat} ayat"),
                    trailing: Text(dataAlQuran[i].asma),
                    onTap: () {
                      Navigator.push(
                        context, 
                        MaterialPageRoute(
                          builder: (context) {
                            return DetailAlQuran(
                              nomor : dataAlQuran[i].nomor,
                              nama : dataAlQuran[i].nama,
                            );
                          }
                        )  
                      );
                    },
                  ),
                ],
              )
            )
          );
        }
      ),
    );
  }
}