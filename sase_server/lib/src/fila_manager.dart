import 'package:sase_server/src/enums/sase_enums.dart';

/// Gerencia o estado interno das filas de senhas.
///
/// Mantém as filas Normal ("N") e Prioritária ("P") e aplica
/// a regra de intercalação para garantir o balanceamento.
class FilaManager {
  final List<String> _filaNormal = [];
  final List<String> _filaPrioritaria = [];

  /// Controla a regra de intercalação.
  /// 
  /// Regra: a cada 2 senhas normais chamadas, a próxima
  /// obrigatoriamente deve ser prioritária (se houver).
  int _normaisChamadasConsecutivas = 0;

  /// Adiciona uma nova senha à fila correspondente.
  ///
  /// [senha] - Ex: "N1", "P1".
  /// [tipo] - Enum que define se é Normal ou Prioritária.
  void adicionarSenha(String senha, TipoSenha tipo) {
    if (tipo == TipoSenha.prioritaria) {
      _filaPrioritaria.add(senha);
    } else {
      _filaNormal.add(senha);
    }
  }

  /// Retorna a próxima senha da fila de acordo com as regras,
  /// removendo-a da respectiva lista.
  ///
  /// Retorna `null` se ambas as filas estiverem vazias.
  String? chamarProxima() {
    if (_filaNormal.isEmpty && _filaPrioritaria.isEmpty) {
      return null;
    }

    // Regra de intercalação:
    // Se já chamamos 2 ou mais normais seguidas e tem prioritária esperando.
    if (_normaisChamadasConsecutivas >= 2 && _filaPrioritaria.isNotEmpty) {
      _normaisChamadasConsecutivas = 0;
      return _filaPrioritaria.removeAt(0);
    }

    // Se temos prioridades aguardando, elas têm precedência.
    // Mas, como a regra fala explicitamente sobre intercalação de normais,
    // garantimos que a proporção 2:1 seja respeitada, chamando normais
    // antes de esvaziar todas as prioritárias.
    if (_filaNormal.isNotEmpty && _normaisChamadasConsecutivas < 2) {
      _normaisChamadasConsecutivas++;
      return _filaNormal.removeAt(0);
    }

    // Se chegou aqui, ou a fila Normal acabou, ou já chamamos 2 normais
    // (e se tinha prioritária, já caiu no primeiro IF).
    if (_filaPrioritaria.isNotEmpty) {
      _normaisChamadasConsecutivas = 0;
      return _filaPrioritaria.removeAt(0);
    }

    // Caso de fallback: tem normal mas a prioritária estava vazia.
    if (_filaNormal.isNotEmpty) {
      _normaisChamadasConsecutivas++;
      return _filaNormal.removeAt(0);
    }

    return null;
  }

  /// Retorna o tamanho atual da fila Normal.
  int get tamanhoFilaNormal => _filaNormal.length;

  /// Retorna o tamanho atual da fila Prioritária.
  int get tamanhoFilaPrioritaria => _filaPrioritaria.length;
  
  /// Limpa todas as filas e reseta os contadores.
  void resetar() {
    _filaNormal.clear();
    _filaPrioritaria.clear();
    _normaisChamadasConsecutivas = 0;
  }
}
