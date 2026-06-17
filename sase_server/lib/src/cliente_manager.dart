import 'dart:io';

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
  ///
  /// Retorna `true` se o tipo é válido e o registro foi feito,
  /// `false` caso contrário.
  bool registrar(Socket socket, String tipoCliente) {
    switch (tipoCliente) {
      case 'TS':
        _terminaisSenha.add(socket);
        return true;
      case 'TA':
        _terminaisAtendimento.add(socket);
        return true;
      case 'TV':
        _terminaisVisualizacao.add(socket);
        return true;
      default:
        return false;
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
