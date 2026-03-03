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

  
  Future<void> fetchJogos() async {
    try {
      final response = await supabase.from('jogos').select();
      jogos = response.map((e) => Jogos.fromMap(e)).toList();
      notifyListeners();
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
          'esporte': jogo.esporte.name,
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

  Future<void> sairDoJogo(int jogoId, String usuario) async {
  try {
    final jogoIndex = jogos.indexWhere((j) => j.id == jogoId);

    if (jogoIndex == -1) return;

    final jogo = jogos[jogoIndex];

    
    jogo.jogadores.remove(usuario);

    
    if (jogo.jogadores.isEmpty) {
      await supabase
          .from('jogos')
          .delete()
          .eq('id', jogoId);

      jogos.removeAt(jogoIndex);
    } else {
      
      await supabase
          .from('jogos')
          .update({
            'jogadores': jogo.jogadores.cast<dynamic>(),
          })
          .eq('id', jogoId);

      jogos[jogoIndex] = jogo;
    }

    notifyListeners();
  } catch (e) {
    print("Erro ao sair do jogo: $e");
  }
}
  
  
  Future<void> fetchUsuarios() async {
    try {
      final response = await supabase.from('usuarios').select();
      usuarios = response.map((e) => Usuario.fromMap(e)).toList();
      notifyListeners();
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

  
