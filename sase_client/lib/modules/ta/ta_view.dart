import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sase_client/core/ui/widgets/sase_button.dart';
import 'package:sase_client/core/ui/widgets/sase_fila_vazia_widget.dart';
import 'package:sase_client/core/ui/widgets/sase_header.dart';
import 'package:sase_client/core/ui/widgets/sase_senha_display.dart';
import 'package:sase_client/modules/ta/ta_controller.dart';

/// Tela principal do Terminal de Atendimento (TA).
///
/// Exibe o painel de senha ou o widget de fila vazia dependendo do estado
/// gerenciado pelo `TaController`. Nenhuma regra de negócio aqui.
class TaView extends GetView<TaController> {
  const TaView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final titulo = 'Guichê N° ${controller.numeroMesa.value}';

      return Scaffold(
        backgroundColor: Colors.grey[100],
        appBar: SaseHeader(title: titulo),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(48.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Painel central — alterna entre senha, aguardando ou fila vazia.
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 400),
                  transitionBuilder: (child, animation) => FadeTransition(
                    opacity: animation,
                    child: ScaleTransition(scale: animation, child: child),
                  ),
                  child: _buildPainelCentral(),
                ),

                const SizedBox(height: 64),

                // Botão de chamar sempre visível.
                SizedBox(
                  width: 480,
                  height: 140,
                  child: SaseButton(
                    label: 'Chamar Próxima',
                    icon: Icons.notifications_active,
                    color: Colors.blue[700]!,
                    onTap: controller.chamarProxima,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }

  Widget _buildPainelCentral() {
    switch (controller.estado.value) {
      case EstadoTa.atendendo:
        final senha = controller.senhaAtual.value;
        // Define cor baseada no tipo de senha (P = laranja, N = azul)
        final isPrioritaria = senha.startsWith('P');
        return SaseSenhaDisplay(
          key: ValueKey(senha),
          senha: senha,
          subtitulo: isPrioritaria ? 'Atendimento Prioritário' : 'Atendimento Normal',
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
