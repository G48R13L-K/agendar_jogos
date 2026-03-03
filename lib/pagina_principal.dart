import 'package:agendar_jogos/jogos.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'my_change_notifier.dart';

class PaginaPrincipal extends StatefulWidget {
  const PaginaPrincipal({super.key});

  @override
  State<PaginaPrincipal> createState() => _PaginaPrincipalState();
}

class _PaginaPrincipalState extends State<PaginaPrincipal> {
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

  Future<void> _confirmarSaida(int jogoId, String usuario) async {
    final confirmar = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: const Text("Sair do jogo"),
        content: const Text("Deseja realmente sair deste jogo?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Cancelar"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: () => Navigator.pop(context, true),
            child: const Text("Sair"),
          ),
        ],
      ),
    );

    if (confirmar == true) {
      await context.read<MyChangeNotifier>().sairDoJogo(jogoId, usuario);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text("Você saiu do jogo ⚽"),
            backgroundColor: Colors.orange,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final usuarioLogado =
        context.watch<MyChangeNotifier>().usuarioLogado ?? "Usuário";

    final jogos = context
        .watch<MyChangeNotifier>()
        .jogos
        .where((j) => j.jogadores.contains(usuarioLogado))
        .toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF1F8E9),

      
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFF1B5E20),
                Color(0xFF4CAF50),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        title: const Text(
          "Meus Jogos",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: _carregarJogos,
          ),
        ],
      ),

      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : jogos.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(
                        Icons.sports_soccer,
                        size: 60,
                        color: Colors.grey,
                      ),
                      SizedBox(height: 16),
                      Text(
                        "Você ainda não participa de nenhum jogo",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                )
              : RefreshIndicator(
                  onRefresh: _carregarJogos,
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: jogos.length,
                    itemBuilder: (context, index) {
                      final jogo = jogos[index];
                      final dataFormatada =
                          DateFormat('dd/MM/yyyy HH:mm').format(jogo.data);

                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                        margin: const EdgeInsets.only(bottom: 16),
                        child: Card(
                          elevation: 6,
                          shadowColor:
                              jogo.esporte.cor.withOpacity(0.3),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(18),
                            child: Row(
                              crossAxisAlignment:
                                  CrossAxisAlignment.start,
                              children: [
                                Icon(
                                  jogo.esporte.icone,
                                  size: 32,
                                  color: jogo.esporte.cor,
                                ),
                                const SizedBox(width: 16),

                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        jogo.esporte.nome,
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight:
                                              FontWeight.bold,
                                          color: jogo.esporte.cor,
                                        ),
                                      ),
                                      const SizedBox(height: 6),
                                      Text(
                                        dataFormatada,
                                        style: const TextStyle(
                                          fontSize: 14,
                                        ),
                                      ),
                                      const SizedBox(height: 10),

                                      Container(
                                        padding:
                                            const EdgeInsets.symmetric(
                                          horizontal: 12,
                                          vertical: 6,
                                        ),
                                        decoration: BoxDecoration(
                                          color: jogo.esporte.cor
                                              .withOpacity(0.1),
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                        child: Text(
                                          "${jogo.jogadores.length}/${jogo.esporte.limiteJogadores}",
                                          style: TextStyle(
                                            fontWeight:
                                                FontWeight.bold,
                                            color: jogo.esporte.cor,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                CircleAvatar(
                                  radius: 18,
                                  backgroundColor:
                                      Colors.orange.withOpacity(0.1),
                                  child: IconButton(
                                    padding: EdgeInsets.zero,
                                    icon: const Icon(
                                      Icons.logout,
                                      size: 18,
                                      color: Colors.orange,
                                    ),
                                    onPressed: () =>
                                        _confirmarSaida(
                                      jogo.id,
                                      usuarioLogado,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
    );
  }
}