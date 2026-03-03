import 'package:agendar_jogos/novo_jogo.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'pagina_principal.dart';
import 'jogos_disponiveis.dart';
import 'my_change_notifier.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedIndex = 0;

  final List<Widget> _pages = const [
    PaginaPrincipal(),
    JogosDisponiveis(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _logout() {
    context.read<MyChangeNotifier>().logout();

    Navigator.pushNamedAndRemoveUntil(
      context,
      '/', // rota do login
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green[50],

      appBar: AppBar(
        backgroundColor: Colors.green,
        title: const Text("PartidasApp"),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: "Sair",
            onPressed: _logout,
          )
        ],
      ),

      body: _pages[_selectedIndex],

      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25),
            boxShadow: [
              BoxShadow(
                color: Colors.green.withOpacity(0.2),
                blurRadius: 10,
                offset: const Offset(0, 4),
              )
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(25),
            child: NavigationBar(
              backgroundColor: Colors.white,
              indicatorColor: Colors.green.withOpacity(0.2),
              selectedIndex: _selectedIndex,
              onDestinationSelected: _onItemTapped,
              destinations: const [
                NavigationDestination(
                  icon: Icon(Icons.home_outlined, color: Colors.green),
                  selectedIcon: Icon(Icons.home, color: Colors.green),
                  label: "Principal",
                ),
                NavigationDestination(
                  icon: Icon(Icons.sports_soccer_outlined, color: Colors.green),
                  selectedIcon:
                      Icon(Icons.sports_soccer, color: Colors.green),
                  label: "Jogos",
                ),
              ],
            ),
          ),
        ),
      ),

      floatingActionButton: _selectedIndex == 1
          ? FloatingActionButton(
              backgroundColor: Colors.green,
              elevation: 6,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const NovoJogo()),
                );
              },
              child: const Icon(Icons.add, size: 28),
              tooltip: "Cadastrar Novo Jogo",
            )
          : null,
    );
  }
}