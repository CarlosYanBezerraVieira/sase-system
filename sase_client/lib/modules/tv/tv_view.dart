import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sase_client/core/ui/widgets/sase_header.dart';
import 'package:sase_client/core/ui/widgets/sase_senha_display.dart';
import 'package:sase_client/modules/tv/tv_controller.dart';

/// Painel de exibição para a TV.
///
/// Interface otimizada para legibilidade à distância. Fundo de alto contraste,
/// senha principal em destaque máximo e histórico nas laterais.
class TvView extends GetView<TvController> {
  const TvView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[900], // Fundo escuro focado em TVs
      appBar: const SaseHeader(title: 'Painel de Chamadas'),
      body: Row(
        children: [
          // Área principal (Senha atual)
          Expanded(
            flex: 3,
            child: Center(
              child: Obx(() {
                final atual = controller.ultimaChamada.value;
                if (atual == null) {
                  return const Text(
                    'AGUARDANDO CHAMADAS',
                    style: TextStyle(
                      color: Colors.white54,
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 4,
                    ),
                  );
                }

                final isPrioritaria = atual.senha.startsWith('P');
                
                // AnimatedSwitcher para fazer a senha atual piscar/surgir ao mudar
                return AnimatedSwitcher(
                  duration: const Duration(milliseconds: 500),
                  transitionBuilder: (child, animation) {
                    return ScaleTransition(
                      scale: Tween<double>(begin: 0.8, end: 1.0).animate(CurvedAnimation(
                        parent: animation,
                        curve: Curves.elasticOut,
                      )),
                      child: FadeTransition(opacity: animation, child: child),
                    );
                  },
                  child: Container(
                    key: ValueKey(atual.senha),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          'SENHA',
                          style: TextStyle(color: Colors.white70, fontSize: 32, letterSpacing: 4),
                        ),
                        const SizedBox(height: 16),
                        // Aproveitando nosso componente, mas escalado gigante
                        Transform.scale(
                          scale: 1.8,
                          child: SaseSenhaDisplay(
                            senha: atual.senha,
                            subtitulo: isPrioritaria ? 'PRIORIDADE' : 'NORMAL',
                            corDestaque: isPrioritaria ? Colors.orange[600]! : Colors.blue[600]!,
                          ),
                        ),
                        const SizedBox(height: 100),
                        Text(
                          'DIRIJA-SE AO GUICHÊ',
                          style: TextStyle(color: Colors.yellow[400], fontSize: 36, fontWeight: FontWeight.w600),
                        ),
                        Text(
                          '${atual.mesa}',
                          style: TextStyle(color: Colors.yellow[400], fontSize: 120, fontWeight: FontWeight.w900),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ),
          ),

          // Divisória
          Container(width: 2, color: Colors.white24),

          // Histórico Lateral
          Expanded(
            flex: 1,
            child: Container(
              color: Colors.blueGrey[800],
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 24),
                    color: Colors.black26,
                    child: const Text(
                      'ÚLTIMAS CHAMADAS',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Expanded(
                    child: Obx(() {
                      final historico = controller.historico;
                      if (historico.isEmpty) {
                        return const Center(
                          child: Text('Nenhum histórico', style: TextStyle(color: Colors.white54)),
                        );
                      }

                      return ListView.separated(
                        itemCount: historico.length,
                        padding: const EdgeInsets.all(24),
                        separatorBuilder: (_, __) => const Divider(color: Colors.white24, height: 32),
                        itemBuilder: (context, index) {
                          final item = historico[index];
                          final isPrioritaria = item.senha.startsWith('P');
                          final color = isPrioritaria ? Colors.orange[400] : Colors.blue[400];

                          return Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                item.senha,
                                style: TextStyle(color: color, fontSize: 48, fontWeight: FontWeight.bold),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  const Text('GUICHÊ', style: TextStyle(color: Colors.white54, fontSize: 16)),
                                  Text(
                                    '${item.mesa}',
                                    style: const TextStyle(color: Colors.white, fontSize: 36, fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ],
                          );
                        },
                      );
                    }),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
