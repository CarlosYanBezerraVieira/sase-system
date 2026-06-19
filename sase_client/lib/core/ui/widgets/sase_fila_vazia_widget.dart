import 'package:flutter/material.dart';

/// Widget dedicado para exibir o estado de fila vazia no Terminal de Atendimento.
///
/// Exibido em lugar do painel de senha quando o servidor retorna `fila_vazia`.
/// O botão de chamar continua ativo, deixando o atendente tentar novamente.
class SaseFilaVaziaWidget extends StatefulWidget {
  const SaseFilaVaziaWidget({super.key});

  @override
  State<SaseFilaVaziaWidget> createState() => _SaseFilaVaziaWidgetState();
}

class _SaseFilaVaziaWidgetState extends State<SaseFilaVaziaWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
    _fadeAnimation = Tween<double>(begin: 0.4, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(40),
      decoration: BoxDecoration(
        color: Colors.amber[50],
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.amber[300]!, width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.amber.withValues(alpha: 0.15),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FadeTransition(
            opacity: _fadeAnimation,
            child: Icon(
              Icons.hourglass_empty_rounded,
              size: 80,
              color: Colors.amber[700],
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'SEM SENHAS NA FILA',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.amber[900],
              letterSpacing: 1.5,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Aguarde um momento e tente novamente.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 18,
              color: Colors.amber[800],
            ),
          ),
        ],
      ),
    );
  }
}
