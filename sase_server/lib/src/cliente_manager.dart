import 'dart:io';

import 'package:sase_server/src/enums/sase_enums.dart';

/// Gerencia as conexões de clientes TCP classificadas por tipo.
///
/// Mantém listas separadas de Sockets para cada tipo de terminal:
/// - TS (Terminal de Senhas)
/// - TA (Terminal de Atendimento)
/// - TV (Terminal de Visualização)
///
/// Isso permite ao servidor realizar unicast (para um TA específico)
/// e broadcast (para todas as TVs) de forma eficiente.
class ClienteManager {
  /// Sockets de Terminais de Senhas conectados.
  final List<Socket> _terminaisSenha = [];

  /// Sockets de Terminais de Atendimento conectados.
  final List<Socket> _terminaisAtendimento = [];

  /// Sockets de Terminais de Visualização conectados.
  final List<Socket> _terminaisVisualizacao = [];

  /// Registra um socket na lista correspondente ao [tipoCliente].
  void registrar(Socket socket, TipoCliente tipoCliente) {
    switch (tipoCliente) {
      case TipoCliente.ts:
        _terminaisSenha.add(socket);
        break;
      case TipoCliente.ta:
        _terminaisAtendimento.add(socket);
        break;
      case TipoCliente.tv:
        _terminaisVisualizacao.add(socket);
        break;
    }
  }

  /// Remove um socket de todas as listas ao desconectar.
  void remover(Socket socket) {
    _terminaisSenha.remove(socket);
    _terminaisAtendimento.remove(socket);
    _terminaisVisualizacao.remove(socket);
  }

  /// Retorna a lista de Sockets do tipo TV (para broadcast).
  List<Socket> get terminaisVisualizacao =>
      List.unmodifiable(_terminaisVisualizacao);

  /// Retorna a lista de Sockets do tipo TA.
  List<Socket> get terminaisAtendimento =>
      List.unmodifiable(_terminaisAtendimento);

  /// Retorna a lista de Sockets do tipo TS.
  List<Socket> get terminaisSenha => List.unmodifiable(_terminaisSenha);

  /// Retorna o total de clientes conectados.
  int get totalConectados =>
      _terminaisSenha.length +
      _terminaisAtendimento.length +
      _terminaisVisualizacao.length;

  /// Retorna um resumo das conexões ativas.
  String get resumo => 'TS: ${_terminaisSenha.length} | '
      'TA: ${_terminaisAtendimento.length} | '
      'TV: ${_terminaisVisualizacao.length}';
}
