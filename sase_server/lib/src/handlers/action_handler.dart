import 'dart:io';

import 'package:sase_server/src/cliente_manager.dart';
import 'package:sase_server/src/fila_manager.dart';
import 'package:sase_server/src/logger_service.dart';

/// Interface base para manipuladores de ações recebidas via TCP.
abstract class ActionHandler {
  final ClienteManager clienteManager;
  final LoggerService logger;
  final FilaManager filaManager;

  ActionHandler({
    required this.clienteManager,
    required this.logger,
    required this.filaManager,
  });

  /// Processa a mensagem recebida de um cliente.
  ///
  /// [socket] - O socket do cliente que enviou a mensagem.
  /// [mensagem] - O payload decodificado do formato JSON.
  /// [enderecoRemoto] - Endereço IP e porta do cliente.
  void handle(Socket socket, Map<String, dynamic> mensagem, String enderecoRemoto);
}
