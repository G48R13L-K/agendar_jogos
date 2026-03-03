import 'package:flutter/material.dart';

enum Esporte {
  futebol,
  volei,
  basquete,
  tenis;

  String get nome {
    switch (this) {
      case Esporte.futebol:
        return "Futebol";
      case Esporte.volei:
        return "Vôlei";
      case Esporte.basquete:
        return "Basquete";
      case Esporte.tenis:
        return "Tênis";
    }
  }

  IconData get icone {
    switch (this) {
      case Esporte.futebol:
        return Icons.sports_soccer;
      case Esporte.volei:
        return Icons.sports_volleyball;
      case Esporte.basquete:
        return Icons.sports_basketball;
      case Esporte.tenis:
        return Icons.sports_tennis;
    }
  }

  Color get cor {
    switch (this) {
      case Esporte.futebol:
        return Colors.green;
      case Esporte.volei:
        return Colors.blue;
      case Esporte.basquete:
        return Colors.orange;
      case Esporte.tenis:
        return Colors.amber;
    }
  }

  int get limiteJogadores {
    switch (this) {
      case Esporte.futebol:
        return 22;
      case Esporte.volei:
        return 12;
      case Esporte.basquete:
        return 10;
      case Esporte.tenis:
        return 4;
    }
  }
}

class Jogos {
  final int id;
  final DateTime data;
  final Esporte esporte;
  final List<String> jogadores;

  Jogos({
    required this.id,
    required this.data,
    required this.esporte,
    required this.jogadores,
  });

  
  factory Jogos.fromMap(Map<String, dynamic> map) {
    final esporteString = map['esporte']?.toString();

    Esporte esporteConvertido = Esporte.futebol; // padrão seguro

    for (var e in Esporte.values) {
      if (e.name.toLowerCase() ==
          esporteString?.toLowerCase()) {
        esporteConvertido = e;
        break;
      }
    }

    return Jogos(
      id: map['id'],
      data: DateTime.parse(map['data']),
      esporte: esporteConvertido,
      jogadores: List<String>.from(map['jogadores'] ?? []),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'data': data.toIso8601String(),
      'esporte': esporte.name,
      'jogadores': jogadores,
    };
  }
}