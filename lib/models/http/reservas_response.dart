// To parse this JSON data, do
//
//     final categoriesResponse = categoriesResponseFromMap(jsonString);
import 'dart:convert';

import '../reserva.dart';

class ReservasResponse {
    ReservasResponse({
        required this.total,
        required this.reservas,
    });

    int total;
    List<Reserva> reservas;

    factory ReservasResponse.fromJson(String str) => ReservasResponse.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory ReservasResponse.fromMap(Map<String, dynamic> json) => ReservasResponse(
        total: json["total"],
        reservas: List<Reserva>.from(json["reservas"].map((x) => Reserva.fromMap(x))),
    );

    Map<String, dynamic> toMap() => {
        "total": total,
        "reservas": List<dynamic>.from(reservas.map((x) => x.toMap())),
    };
}


