import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sase_client/core/services/socket_service.dart';

/// Cabeçalho padronizado para as telas do SASE Client.
///
/// Exibe o título do terminal e um indicador visual em tempo real
/// do status da conexão TCP com o servidor.
class SaseHeader extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  const SaseHeader({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    final socketService = Get.find<SocketService>();

    return AppBar(
      title: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      centerTitle: true,
      elevation: 4,
      shadowColor: Colors.black26,
      backgroundColor: Colors.white,
      foregroundColor: Colors.black87,
      actions: [
        Obx(() {
          final isConnected = socketService.isConnected.value;
          return Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Row(
              children: [
                Icon(
                  isConnected ? Icons.cloud_done : Icons.cloud_off,
                  color: isConnected ? Colors.green : Colors.red,
                ),
                const SizedBox(width: 8),
                Text(
                  isConnected ? 'Conectado' : 'Desconectado',
                  style: TextStyle(
                    color: isConnected ? Colors.green : Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
