// To parse this JSON data, do
//
//     final categoriesResponse = categoriesResponseFromMap(jsonString);
import 'dart:convert';

import '../solares.dart';

class SolaresResponse {
    SolaresResponse({
        required this.total,
        required this.solares,
    });

    int total;
    List<Solares> solares;

    factory SolaresResponse.fromJson(String str) => SolaresResponse.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory SolaresResponse.fromMap(Map<String, dynamic> json) => SolaresResponse(
        total: json["total"],
        solares: List<Solares>.from(json["solares"].map((x) => Solares.fromMap(x))),
    );

    Map<String, dynamic> toMap() => {
        "total": total,
        "solares": List<dynamic>.from(solares.map((x) => x.toMap())),
    };
}


