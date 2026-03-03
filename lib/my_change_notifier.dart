import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'jogos.dart';
import 'usuarios.dart';

class MyChangeNotifier extends ChangeNotifier {
  final supabase = Supabase.instance.client;

  List<Jogos> jogos = [];
  List<Usuario> usuarios = [];
  String? usuarioLogado;
  int currentIndex = 0;

  void setIndex(int i) {
    currentIndex = i;
    notifyListeners();
  }

  void setUsuarioLogado(String usuario) {
    usuarioLogado = usuario;
    notifyListeners();
  }

  void logout() {
    usuarioLogado = null;
    notifyListeners();
  }
  // JOGOS

  Future<void> fetchJogos() async {
    try {
      final response = await supabase.from('jogos').select();
      if (response is List) {
        jogos = response.map((e) => Jogos.fromMap(e)).toList();
        notifyListeners();
      }
    } catch (e) {
      print("Erro fetchJogos: $e");
      rethrow;
    }
  }

  Future<void> insertJogo({required Jogos jogo}) async {
  try {
    final response = await supabase
        .from('jogos')
        .insert({
          'data': jogo.data.toIso8601String(),
          'esporte': jogo.esporte,
          'jogadores': jogo.jogadores.cast<dynamic>(), 
        })
        .select()
        .single();

    final novoJogo = Jogos.fromMap(response);
    jogos.add(novoJogo);
    notifyListeners();
  } catch (e) {
    print("Erro insertJogo: $e");
    rethrow;
  }
}

  
  // USUÁRIOS
  
  Future<void> fetchUsuarios() async {
    try {
      final response = await supabase.from('usuarios').select();
      if (response is List) {
        usuarios = response.map((e) => Usuario.fromMap(e)).toList();
        notifyListeners();
      }
    } catch (e) {
      print("Erro fetchUsuarios: $e");
      rethrow;
    }
  }

  Future<void> insertUsuario({required Usuario usuario}) async {
    try {
      await supabase.from('usuarios').insert(usuario.toMap());
      await fetchUsuarios();
    } catch (e) {
      print("Erro insertUsuario: $e");
      rethrow;
    }
  }
}

