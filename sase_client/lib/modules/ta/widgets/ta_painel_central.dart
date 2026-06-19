import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sase_client/core/ui/widgets/sase_fila_vazia_widget.dart';
import 'package:sase_client/core/ui/widgets/sase_senha_display.dart';
import 'package:sase_client/modules/ta/ta_controller.dart';

/// Painel central do TA, alternando entre senha, fila vazia e aguardando.
class TaPainelCentral extends GetView<TaController> {
  const TaPainelCentral({super.key});

  @override
  Widget build(BuildContext context) {
    switch (controller.estado.value) {
      case EstadoTa.atendendo:
        final senha = controller.senhaAtual.value;
        final isPrioritaria = controller.isPrioritaria;
        return SaseSenhaDisplay(
          key: ValueKey(senha),
          senha: senha,
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
