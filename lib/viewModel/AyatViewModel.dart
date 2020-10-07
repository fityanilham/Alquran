import 'package:alquran/model/AyatModel.dart';
import 'package:http/http.dart' as http;

class AlQuranViewModel {
  Future<List> getAlQuran(int nomor) async {
    try {
      http.Response hasil = await http.get(
        Uri.encodeFull("https://al-quran-8d642.firebaseio.com/surat/${nomor}.json?print=pretty"),
        headers: {"Accept": "application/json"},
      );
      if(hasil.statusCode == 200) {
        print("Data AlQuran Success");
        final data = ayatModelFromJson(hasil.body);
        return data;
      } else {
        print("Error Status ${hasil.statusCode.toString()}");
        return null;
      }
    } 
    catch(e) {
      print("Error Catch $e");
      return null;
    }
  }
}