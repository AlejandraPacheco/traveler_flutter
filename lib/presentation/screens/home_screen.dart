import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../application/providers/viaje_provider.dart';
import '../../application/providers/auth_provider.dart';
import '../../model/viaje.dart';
import 'form_viaje_screen.dart';
import 'detalle_viaje_screen.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viajesAsync = ref.watch(viajeListProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mis Viajes'),
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
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: ElevatedButton(
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
              child: const Text('Agregar nuevo viaje'),
            ),
          ),
          Expanded(
            child: viajesAsync.when(
              data: (viajes) => viajes.isEmpty
                  ? const Center(child: Text('No hay viajes registrados'))
                  : ListView.builder(
                      itemCount: viajes.length,
                      itemBuilder: (context, index) {
                        final viaje = viajes[index];
                        return ListTile(
                          title: Text('${viaje.ciudad}, ${viaje.pais}'),
                          subtitle: Text(
                            'Del ${viaje.fechaInicio} al ${viaje.fechaFin}',
                          ),
                          trailing: Text(viaje.clima ?? ''),
                          onTap: () async {
                            final refrescar = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    DetalleViajeScreen(viaje: viaje),
                              ),
                            );
                            if (refrescar == true) {
                              ref.refresh(viajeListProvider);
                            }
                          },
                        );
                      },
                    ),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text('Error: $e')),
            ),
          ),
        ],
      ),
    );
  }
}
