import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'my_change_notifier.dart';
import 'jogos.dart';

class JogosDisponiveis extends StatefulWidget {
  const JogosDisponiveis({super.key});

  @override
  State<JogosDisponiveis> createState() => _JogosDisponiveisState();
}

class _JogosDisponiveisState extends State<JogosDisponiveis> {
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _carregarJogos();
  }

  Future<void> _carregarJogos() async {
    setState(() => isLoading = true);
    try {
      await context.read<MyChangeNotifier>().fetchJogos();
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  Future<void> _participar(Jogos jogo, String usuarioLogado) async {
    await context.read<MyChangeNotifier>().entrarNoJogo(jogo.id, usuarioLogado);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Você entrou no jogo ${jogo.esporte.nome} ⚽"),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final usuarioLogado =
        context.watch<MyChangeNotifier>().usuarioLogado ?? "Usuário";

    // Filtra jogos disponíveis que o usuário ainda não participa
    final jogosDisponiveis = context
        .watch<MyChangeNotifier>()
        .jogos
        .where((j) => !j.jogadores.contains(usuarioLogado))
        .toList();

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF1B5E20), Color(0xFF4CAF50)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        title: const Text(
          "Jogos Disponíveis",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ),
      backgroundColor: const Color(0xFFF1F8E9),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : jogosDisponiveis.isEmpty
              ? const Center(
                  child: Text(
                    "Não há jogos disponíveis para participar",
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                )
              : RefreshIndicator(
                  onRefresh: _carregarJogos,
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: jogosDisponiveis.length,
                    itemBuilder: (context, index) {
                      final jogo = jogosDisponiveis[index];

                      return _buildCard(
                        titulo: jogo.esporte.nome,
                        data:
                            "${jogo.data.day}/${jogo.data.month}/${jogo.data.year} ${jogo.data.hour.toString().padLeft(2, '0')}:${jogo.data.minute.toString().padLeft(2, '0')}",
                        vagas:
                            "${jogo.jogadores.length}/${jogo.esporte.limiteJogadores}",
                        cor: jogo.esporte.cor,
                        icone: jogo.esporte.icone,
                        onParticipar: () => _participar(jogo, usuarioLogado),
                      );
                    },
                  ),
                ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,
        onPressed: () {},
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildCard({
    required String titulo,
    required String data,
    required String vagas,
    required Color cor,
    required IconData icone,
    required VoidCallback onParticipar,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: cor.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(icone, color: cor, size: 40),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  titulo,
                  style:
                      TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: cor),
                ),
                const SizedBox(height: 6),
                Text(data),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: cor.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    vagas,
                    style: TextStyle(color: cor, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: cor,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: onParticipar,
            child: const Text("Participar"),
          ),
        ],
      ),
    );
  }
}