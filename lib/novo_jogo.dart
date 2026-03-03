import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'jogos.dart';
import 'my_change_notifier.dart';

class NovoJogo extends StatefulWidget {
  const NovoJogo({super.key});

  @override
  State<NovoJogo> createState() => _NovoJogoState();
}

class _NovoJogoState extends State<NovoJogo> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController esporteController = TextEditingController();

  DateTime? dataSelecionada;
  TimeOfDay? horaSelecionada;
  bool isLoading = false;

  Future<void> _selecionarData() async {
    final data = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (data != null) setState(() => dataSelecionada = data);
  }

  Future<void> _selecionarHora() async {
    final hora = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (hora != null) setState(() => horaSelecionada = hora);
  }

  Future<void> _salvarJogo() async {
    if (!_formKey.currentState!.validate()) return;

    if (dataSelecionada == null || horaSelecionada == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Selecione data e hora")),
      );
      return;
    }

    setState(() => isLoading = true);

    try {
      final provider = context.read<MyChangeNotifier>();
      final usuario = provider.usuarioLogado ?? "Desconhecido";

      final dataFinal = DateTime(
        dataSelecionada!.year,
        dataSelecionada!.month,
        dataSelecionada!.day,
        horaSelecionada!.hour,
        horaSelecionada!.minute,
      );

      final jogo = Jogos(
        id: 0,
        data: dataFinal,
        esporte: esporteController.text.trim(),
        jogadores: [usuario],
      );

      await provider.insertJogo(jogo: jogo);

      if (mounted) Navigator.pop(context);

    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Erro ao salvar: $e")),
        );
      }
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  @override
  void dispose() {
    esporteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dataTexto = dataSelecionada != null
        ? DateFormat('dd/MM/yyyy').format(dataSelecionada!)
        : "Selecionar Data";

    final horaTexto = horaSelecionada != null
        ? horaSelecionada!.format(context)
        : "Selecionar Hora";

    return Scaffold(
      backgroundColor: Colors.green[50],

      appBar: AppBar(
        backgroundColor: Colors.green,
        title: const Text("Criar Novo Jogo"),
        centerTitle: true,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            children: [

              const Icon(
                Icons.sports_soccer,
                size: 80,
                color: Colors.green,
              ),
              const SizedBox(height: 20),

              TextFormField(
                controller: esporteController,
                decoration: InputDecoration(
                  labelText: "Esporte",
                  prefixIcon: const Icon(Icons.sports),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                validator: (value) =>
                    value == null || value.isEmpty ? "Informe o esporte" : null,
              ),

              const SizedBox(height: 20),

              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: _selecionarData,
                      child: Text(dataTexto),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: _selecionarHora,
                      child: Text(horaTexto),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 40),

              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: isLoading ? null : _salvarJogo,
                  child: isLoading
                      ? const CircularProgressIndicator(
                          color: Colors.white,
                        )
                      : const Text(
                          "Salvar Jogo",
                          style: TextStyle(fontSize: 18),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}