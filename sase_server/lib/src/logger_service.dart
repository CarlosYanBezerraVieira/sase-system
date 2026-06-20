import 'dart:convert';
import 'dart:io';

/// Serviço de log com rotação diária em formato JSONL.
///
/// Cada ação no servidor gera uma linha JSON no arquivo de log do dia.
/// Ao virar a meia-noite, um novo arquivo é criado automaticamente.
///
/// Formato do arquivo: `sase_logs_YYYY-MM-DD.log`
class LoggerService {
  static final LoggerService _instancia = LoggerService._interno();
  factory LoggerService() => _instancia;

  LoggerService._interno() : _logDirectory = 'logs';

  final String _logDirectory;

  String _currentDate = '';
  IOSink? _currentSink;

  /// Inicializa o diretório de logs, criando-o se necessário.
  Future<void> init() async {
    final dir = Directory(_logDirectory);
    if (!await dir.exists()) {
      await dir.create(recursive: true);
    }
  }

  /// Registra uma entrada de log no arquivo JSONL do dia.
  ///
  /// [modulo] - O módulo de origem (ex: "SRV").
  /// [acao] - A ação sendo registrada (ex: "nova_senha", "chamar_proxima").
  /// [dados] - Dados adicionais a serem incluídos na linha de log.
  Future<void> registrar({
    required String modulo,
    required String acao,
    Map<String, dynamic> dados = const {},
  }) async {
    final agora = DateTime.now().toUtc();

    /// Formata uma data no padrão YYYY-MM-DD.
    final dataHoje = agora.toIso8601String().substring(0, 10);

    // Rotação diária: se a data mudou, fecha o sink antigo e abre um novo.
    if (dataHoje != _currentDate) {
      await _rotacionar(dataHoje);
    }

    final entry = <String, dynamic>{
      'timestamp': agora.toIso8601String(),
      'modulo': modulo,
      'acao': acao,
      ...dados,
    };

    final linha = jsonEncode(entry);

    // Exibe no console do servidor.
    print('[LOG] $linha');

    // Escreve no arquivo em modo append (não bloqueante).
    _currentSink?.writeln(linha);
  }

  /// Fecha o sink atual e abre um novo arquivo para a data informada.
  Future<void> _rotacionar(String novaData) async {
    await _currentSink?.flush();
    await _currentSink?.close();

    _currentDate = novaData;
    final nomeArquivo = 'sase_logs_$novaData.log';
    final arquivo = File('$_logDirectory/$nomeArquivo');
    _currentSink = arquivo.openWrite(mode: FileMode.append);

    print('[LOGGER] Arquivo de log ativo: $nomeArquivo');
  }

  /// Libera os recursos do logger ao encerrar o servidor.
  Future<void> dispose() async {
    await _currentSink?.flush();
    await _currentSink?.close();
    _currentSink = null;
  }
}
