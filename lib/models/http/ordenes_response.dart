// To parse this JSON data, do
//
//     final categoriesResponse = categoriesResponseFromMap(jsonString);
import 'dart:convert';

import '../orden.dart';

class OrdenesResponse {
    OrdenesResponse({
        required this.total,
        required this.ordenes,
    });

    int total;
    List<Orden> ordenes;

    factory OrdenesResponse.fromJson(String str) => OrdenesResponse.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory OrdenesResponse.fromMap(Map<String, dynamic> json) => OrdenesResponse(
        total: json["total"],
        ordenes: List<Orden>.from(json["ordenes"].map((x) => Orden.fromMap(x))),
    );

    Map<String, dynamic> toMap() => {
        "total": total,
        "ordenes": List<dynamic>.from(ordenes.map((x) => x.toMap())),
    };
}


