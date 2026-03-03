class Jogos {
  final int id;
  final DateTime data;
  final String esporte;
  final List<String> jogadores;

  Jogos({
    required this.id,
    required this.data,
    required this.esporte,
    required this.jogadores,
  });

  /// 🔹 Constrói objeto vindo do Supabase
  factory Jogos.fromMap(Map<String, dynamic> map) {
    final jogadoresRaw = map['jogadores'];

    List<String> listaJogadores = [];

    if (jogadoresRaw is List) {
      listaJogadores =
          jogadoresRaw.map((e) => e.toString()).toList();
    } else if (jogadoresRaw is String && jogadoresRaw.isNotEmpty) {
      listaJogadores = [jogadoresRaw];
    }

    return Jogos(
      id: map['id'] ?? 0,
      data: DateTime.tryParse(map['data'] ?? '') ?? DateTime.now(),
      esporte: map['esporte'] ?? '',
      jogadores: listaJogadores,
    );
  }

  /// 🔹 Converte para enviar ao Supabase
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'data': data.toIso8601String(),
      'esporte': esporte,
      'jogadores': jogadores,
    };
  }

  /// 🔹 Getter útil para UI
  int get quantidadeJogadores => jogadores.length;

  /// 🔹 Facilita atualizar objeto sem recriar tudo
  Jogos copyWith({
    int? id,
    DateTime? data,
    String? esporte,
    List<String>? jogadores,
  }) {
    return Jogos(
      id: id ?? this.id,
      data: data ?? this.data,
      esporte: esporte ?? this.esporte,
      jogadores: jogadores ?? this.jogadores,
    );
  }
}