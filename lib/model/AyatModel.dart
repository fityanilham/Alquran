import 'dart:convert';

List<AyatModel> ayatModelFromJson(String str) => List<AyatModel>.from(json.decode(str).map((x) => AyatModel.fromJson(x)));

String ayatModelToJson(List<AyatModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class AyatModel {
    AyatModel({
        this.ar,
        this.id,
        this.nomor,
        this.tr,
    });

    String ar;
    String id;
    String nomor;
    String tr;

    factory AyatModel.fromJson(Map<String, dynamic> json) => AyatModel(
        ar: json["ar"],
        id: json["id"],
        nomor: json["nomor"],
        tr: json["tr"],
    );

    Map<String, dynamic> toJson() => {
        "ar": ar,
        "id": id,
        "nomor": nomor,
        "tr": tr,
    };
}