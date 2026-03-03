import 'package:flutter/material.dart';

class JogosDisponiveis extends StatefulWidget {
  const JogosDisponiveis({super.key});

  @override
  State<JogosDisponiveis> createState() => _JogosDisponiveisState();
}

class _JogosDisponiveisState extends State<JogosDisponiveis> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      
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
          "Jogos Disponíveis",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ),

      backgroundColor: const Color(0xFFF1F8E9),

      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [

          _buildCard(
            titulo: "Futebol",
            data: "04/03/2026 16:00",
            vagas: "1/22",
            cor: Colors.green,
            icone: Icons.sports_soccer,
          ),

          const SizedBox(height: 20),

          _buildCard(
            titulo: "Basquete",
            data: "04/03/2026 15:45",
            vagas: "1/10",
            cor: Colors.orange,
            icone: Icons.sports_basketball,
          ),

          const SizedBox(height: 20),

          _buildCard(
            titulo: "Vôlei",
            data: "07/03/2026 10:30",
            vagas: "1/12",
            cor: Colors.blue,
            icone: Icons.sports_volleyball,
          ),
        ],
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
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
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

          Icon(
            icone,
            color: cor,
            size: 40,
          ),

          const SizedBox(width: 16),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                Text(
                  titulo,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: cor,
                  ),
                ),

                const SizedBox(height: 6),

                Text(data),

                const SizedBox(height: 8),

                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: cor.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    vagas,
                    style: TextStyle(
                      color: cor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),

          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: cor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: () {},
            child: const Text("Participar"),
          ),
        ],
      ),
    );
  }
}