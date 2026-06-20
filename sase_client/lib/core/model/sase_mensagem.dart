import 'package:sase_client/core/enums/sase_enums.dart';

/// Data Transfer Object (DTO) que unifica e tipa todas as mensagens
/// que trafegam pelo ecossistema SASE.
class SaseMensagem {
  final AcaoSase? acao;
  final String? senha;
  final int? mesa;
  final String? tipo;

  SaseMensagem({required this.acao, this.senha, this.mesa, this.tipo});

  /// Converte um mapa JSON cru vindo do Socket em uma instância tipada.
  factory SaseMensagem.fromJson(Map<String, dynamic> json) {
    final acaoRaw = json['acao'] as String? ?? '';

    return SaseMensagem(
      acao: AcaoSase.fromComando(acaoRaw),
      senha: json['senha'] as String?,
      mesa: json['mesa'] as int?,
      tipo: json['tipo'] as String?,
    );
  }

  /// Converte a instância tipada em um mapa JSON para envio via Socket.
  Map<String, dynamic> toJson() {
    return {
      'acao': acao?.comando,
      if (senha != null) 'senha': senha,
      if (mesa != null) 'mesa': mesa,
      if (tipo != null) 'tipo': tipo,
    };
  }
}
