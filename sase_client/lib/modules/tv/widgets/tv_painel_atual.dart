import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sase_client/core/ui/widgets/sase_senha_display.dart';
import 'package:sase_client/modules/tv/tv_controller.dart';

/// Painel central da TV com a senha atual em destaque.
class TvPainelAtual extends GetView<TvController> {
  const TvPainelAtual({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Obx(() {
        final atual = controller.ultimaChamada.value;
        if (atual == null) {
          return const FittedBox(
            fit: BoxFit.scaleDown,
            child: Padding(
              padding: EdgeInsets.all(32.0),
              child: Text(
                'AGUARDANDO CHAMADAS',
                style: TextStyle(
                  color: Colors.white54,
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 4,
                ),
              ),
            ),
          );
        }

        final isPrioritaria = controller.getIsPrioritariaAtual;

        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 500),
          transitionBuilder: (child, animation) {
            return ScaleTransition(
              scale: Tween<double>(begin: 0.8, end: 1.0).animate(
                CurvedAnimation(parent: animation, curve: Curves.elasticOut),
              ),
              child: FadeTransition(opacity: animation, child: child),
            );
          },
          child: Padding(
            key: ValueKey(atual.senha),
            padding: const EdgeInsets.all(24.0),
            child: Column(
              children: [
                const FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    'SENHA',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 32,
                      letterSpacing: 4,
                    ),
                  ),
                ),

                const Spacer(flex: 1),

                Expanded(
                  flex: 4,
                  child: FittedBox(
                    fit: BoxFit.contain,
                    child: SaseSenhaDisplay(
                      senha: atual.senha,
                      subtitulo: isPrioritaria ? 'PRIORIDADE' : 'NORMAL',
                      corDestaque: isPrioritaria
                          ? Colors.orange[600]!
                          : Colors.blue[600]!,
                    ),
                  ),
                ),

                const Spacer(flex: 2),

                const FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    'DIRIJA-SE AO GUICHÊ',
                    style: TextStyle(
                      color: Colors.indigoAccent,
                      fontSize: 36,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),

                Expanded(
                  flex: 3,
                  child: FittedBox(
                    fit: BoxFit.contain,
                    child: Text(
                      '${atual.mesa}',
                      style: TextStyle(
                        color: Colors.yellow[400],
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
