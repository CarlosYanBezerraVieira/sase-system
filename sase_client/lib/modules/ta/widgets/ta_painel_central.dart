import 'package:flutter/material.dart';
import 'package:sase_client/core/ui/widgets/sase_fila_vazia_widget.dart';
import 'package:sase_client/core/ui/widgets/sase_senha_display.dart';
import 'package:sase_client/modules/ta/ta_controller.dart';

/// Painel central do TA, alternando entre senha, fila vazia e aguardando.
class TaPainelCentral extends StatelessWidget {
  final EstadoTa estado;
  final String senhaAtual;
  final bool isPrioritaria;
  const TaPainelCentral({
    super.key,
    required this.estado,
    required this.senhaAtual,
    required this.isPrioritaria,
  });

  @override
  Widget build(BuildContext context) {
    switch (estado) {
      case EstadoTa.atendendo:
        return SaseSenhaDisplay(
          key: ValueKey(senhaAtual),
          senha: senhaAtual,
          subtitulo: isPrioritaria
              ? 'Atendimento Prioritário'
              : 'Atendimento Normal',
          corDestaque: isPrioritaria ? Colors.orange[800]! : Colors.blue[700]!,
        );

      case EstadoTa.filaVazia:
        return const SaseFilaVaziaWidget(key: ValueKey('fila_vazia'));

      case EstadoTa.aguardando:
        return SaseSenhaDisplay(
          key: const ValueKey('aguardando'),
          senha: '---',
          subtitulo: 'Aguardando',
          corDestaque: Colors.grey[500]!,
        );
    }
  }
}
