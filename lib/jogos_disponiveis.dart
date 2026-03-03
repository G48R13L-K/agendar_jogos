import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'jogos.dart';
import 'my_change_notifier.dart';

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
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Erro ao carregar jogos: $e")),
        );
      }
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  Future<void> _participar(Jogos jogo) async {
    final provider = context.read<MyChangeNotifier>();
    final usuario = provider.usuarioLogado ?? "Desconhecido";

    if (jogo.jogadores.contains(usuario)) return;

    setState(() => isLoading = true);

    jogo.jogadores.add(usuario);

    try {
      await provider.supabase
          .from('jogos')
          .update({'jogadores': jogo.jogadores.cast<dynamic>()})
          .eq('id', jogo.id);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Você entrou no jogo! ⚽")),
      );

      await _carregarJogos();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erro ao entrar no jogo: $e")),
      );
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<MyChangeNotifier>();
    final usuario = provider.usuarioLogado ?? "Usuário";

    final jogosDisponiveis = provider.jogos
        .where((j) => !j.jogadores.contains(usuario))
        .toList();

    return Scaffold(
      backgroundColor: Colors.green[50],

      appBar: AppBar(
        backgroundColor: Colors.green,
        title: const Text("Jogos Disponíveis"),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _carregarJogos,
          ),
        ],
      ),

      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(
                color: Colors.green,
              ),
            )
          : jogosDisponiveis.isEmpty
              ? const Center(
                  child: Text(
                    "Nenhum jogo disponível",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.green,
                    ),
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: jogosDisponiveis.length,
                  itemBuilder: (context, index) {
                    final jogo = jogosDisponiveis[index];
                    final dataFormatada =
                        DateFormat('dd/MM/yyyy HH:mm').format(jogo.data);

                    return Card(
                      elevation: 6,
                      shadowColor: Colors.green.withOpacity(0.3),
                      margin: const EdgeInsets.only(bottom: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.sports_soccer,
                              size: 40,
                              color: Colors.green,
                            ),
                            const SizedBox(width: 16),

                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    jogo.esporte,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.green,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    "Data: $dataFormatada",
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                ],
                              ),
                            ),

                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              onPressed: () => _participar(jogo),
                              child: const Text("Participar"),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}