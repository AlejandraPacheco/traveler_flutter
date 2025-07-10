import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../application/providers/viaje_provider.dart';
import '../../model/viaje.dart';
import 'form_viaje_screen.dart';
import 'detalle_viaje_screen.dart';
import '../../application/providers/auth_provider.dart';
import 'recomendaciones_screen.dart';
import 'explorar_recomendaciones_screen.dart';
import 'favoritos_screen.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  int _selectedIndex = 0;

  static const List<Widget> _screens = [
    _ViajesList(),
    RecomendacionesScreen(),
    ExplorarRecomendacionesScreen(),
    FavoritosScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Traveler'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.red),
            tooltip: 'Cerrar sesión',
            onPressed: () async {
              final auth = ref.read(authServiceProvider);
              await auth.signOut();
              if (context.mounted) {
                Navigator.pushReplacementNamed(context, '/login');
              }
            },
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF4A90E2), Color(0xFF50E3C2)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: _screens[_selectedIndex],
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white.withOpacity(0.9),
        selectedItemColor: Colors.deepPurpleAccent,
        unselectedItemColor: Colors.grey.shade600,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.airplanemode_active_outlined),
            label: 'Viajes',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list_alt_outlined),
            label: 'Recomend.',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.explore_outlined),
            label: 'Explorar',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite_border),
            label: 'Favoritos',
          ),
        ],
      ),
      floatingActionButton: _selectedIndex == 0
          ? FloatingActionButton.extended(
              onPressed: () async {
                final creado = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const FormularioViajeScreen(),
                  ),
                );
                if (creado == true) {
                  ref.refresh(viajeListProvider);
                }
              },
              icon: const Icon(Icons.add),
              label: const Text('Agregar viaje'),
              backgroundColor: Colors.deepPurpleAccent,
            )
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}

class _ViajesList extends ConsumerWidget {
  const _ViajesList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viajesAsync = ref.watch(viajeListProvider);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: viajesAsync.when(
        data: (viajes) => viajes.isEmpty
            ? const Center(
                child: Text(
                  'No hay viajes registrados',
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              )
            : ListView.builder(
                itemCount: viajes.length,
                itemBuilder: (context, index) {
                  final viaje = viajes[index];
                  return Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    color: Colors.white.withOpacity(0.9),
                    margin: const EdgeInsets.symmetric(
                      vertical: 8,
                      horizontal: 0,
                    ),
                    child: ListTile(
                      title: Text(
                        '${viaje.ciudad}, ${viaje.pais}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        'Del ${viaje.fechaInicio} al ${viaje.fechaFin}',
                      ),
                      trailing: Text(
                        viaje.clima ?? '',
                        style: const TextStyle(fontStyle: FontStyle.italic),
                      ),
                      onTap: () async {
                        final refrescar = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => DetalleViajeScreen(viaje: viaje),
                          ),
                        );
                        if (refrescar == true) {
                          ref.refresh(viajeListProvider);
                        }
                      },
                    ),
                  );
                },
              ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
      ),
    );
  }
}
