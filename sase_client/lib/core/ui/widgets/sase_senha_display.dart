import 'package:flutter/material.dart';

/// Painel de exibição da senha atual em destaque.
///
/// Exibe a senha em fonte gigante e um subtítulo descritivo.
/// Reutilizado no Terminal de Atendimento (TA) e no painel TV.
class SaseSenhaDisplay extends StatelessWidget {
  final String senha;
  final String subtitulo;
  final Color corDestaque;

  const SaseSenhaDisplay({
    super.key,
    required this.senha,
    required this.subtitulo,
    this.corDestaque = const Color(0xFF1565C0),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 48, horizontal: 64),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: corDestaque.withValues(alpha: 0.15),
            blurRadius: 30,
            offset: const Offset(0, 12),
          ),
        ],
        border: Border.all(
          color: corDestaque.withValues(alpha: 0.3),
          width: 2,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            subtitulo.toUpperCase(),
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: corDestaque.withValues(alpha: 0.7),
              letterSpacing: 3.0,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            senha,
            style: TextStyle(
              fontSize: 96,
              fontWeight: FontWeight.w900,
              color: corDestaque,
              letterSpacing: 8,
            ),
          ),
        ],
      ),
    );
  }
}
