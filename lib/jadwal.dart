import 'package:flutter/material.dart';
import 'package:alquran/model/prayer_time.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import 'AlQuran.dart' as alquran;

void main() {
  runApp(new MaterialApp(
    title: "Jadwal Sholat",
    home: Home(),
  ));
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;
  Position userLocation;
  Placemark userAddress;

  double lat_value = -6.2841796;
  double long_value = 106.8332884;
  String address = "Kota Bekasi";

  List<String> _prayerTimes = [];
  List<String> _prayerNames = [];
  List initData = [];

  @override
  void initState() {
    super.initState();

    getSP().then((value) {
      initData = value;
      getPrayerTimes(lat_value, long_value);
      getAddress(lat_value, long_value);
    });
  }

  void setSP() async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    pref.setDouble('key_lat', userLocation.latitude);
    pref.setDouble('key_long', userLocation.longitude);
    pref.setString('key_address', " ${userAddress.subAdministrativeArea} " " ${userAddress.country} ");
  }

  Future <Position> _getLocation() async {
    var currentLocation;

    try {
      currentLocation = await geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best
      );
    } catch(e) {
      currentLocation = null;
    }
    return currentLocation;
  }

  Future <dynamic> getSP() async {
    List dataPref = [];
    SharedPreferences pref = await SharedPreferences.getInstance();

    lat_value = pref.getDouble('key_lat');
    long_value = pref.getDouble('key_long');
    address = pref.getString('key_address');

    dataPref.add(lat_value);
    dataPref.add(long_value);
    dataPref.add(address);

    return dataPref;
  }

  getAddress(double lat, double long) async {
    try {
      List<Placemark> p = await geolocator.placemarkFromCoordinates(lat, long);
      Placemark place = p[0];
      userAddress = place;
    } catch(e) {
      userAddress = null;
    }
  }

  getPrayerTimes(double lat, double long) {
    PrayerTime prayer = new PrayerTime();

    prayer.setTimeFormat(prayer.getTime12());
    prayer.setCalcMethod(prayer.getMWL());
    prayer.setAsrJuristic(prayer.getShafii());
    prayer.setAdjustHighLats(prayer.getAdjustHighLats()); 

    List<int> offsets = [-6, 0, 3, 2, 0, 3, 6];

    String tmx = "${DateTime.now().timeZoneOffset}";

    var currentTime = DateTime.now();
    var timeZone = double.parse(tmx[0]);

    prayer.tune(offsets);

    setState(() {
      _prayerTimes = prayer.getPrayerTimes(currentTime, lat, long, timeZone);
      _prayerNames = prayer.getTimeNames();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          SafeArea(
            child: Container(
              child: Column(
                children: [
                  SizedBox(height: 30),
                  Container(
                    // width: double.infinity,
                    child: Image.asset("assets/img/masjid.png")
                  ),
                  SizedBox(height: 70),
                  Container(
                    height: MediaQuery.of(context).size.height * 0.3,
                    padding: EdgeInsets.only(top: 10),
                    child: ListView.builder(
                      itemCount: _prayerNames.length,
                      itemBuilder: (context, position) {
                        return Container(
                          margin: EdgeInsets.only(left: 10,),
                          padding: EdgeInsets.all(5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: 120,
                                child: Text(_prayerNames[position],
                                  style: TextStyle(
                                    color: Colors.grey[800],
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              SizedBox(width: 30),
                              Container(
                                width: 150,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(Radius.circular(5)),
                                  color: Colors.white
                                ),
                                child: Text(
                                  _prayerTimes[position],
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold
                                  ),
                                ),
                              )
                            ],
                          ),
                        );
                      }
                    ),
                  ),
                  SizedBox(height: 80,),
                  FlatButton.icon(
                    onPressed: () {
                      _getLocation().then((value) {
                        setState(() {
                          userLocation = value;
                          getPrayerTimes(userLocation.latitude, userLocation.longitude);
                          getAddress(userLocation.latitude, userLocation.longitude);
                          address = "${userAddress.locality}" " ${userAddress.subAdministrativeArea} " " ${userAddress.country} ";
                        });
                        setSP();
                      });
                    }, 
                    icon: Icon(
                      Icons.location_on, 
                      color: Colors.grey[700], 
                    ),
                    label: Text( 
                      address ?? "Mencari Lokasi ...",
                      style: TextStyle(
                        color: Colors.grey[700],
                        fontSize: 14
                      ),
                    )
                  )
                ],
              ),
            )
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context, 
            MaterialPageRoute(builder: (context) => alquran.AlQuran())
          );
        },
        icon: Icon(Icons.backspace),
        label: Text("Kembali"),
        backgroundColor: Colors.blueGrey,
      ),
    );
  }
}
