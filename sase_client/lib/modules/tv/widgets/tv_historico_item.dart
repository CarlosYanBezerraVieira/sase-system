import 'package:flutter/material.dart';
import 'package:sase_client/modules/tv/tv_controller.dart';

/// Item individual do histórico de chamadas da TV.
class TvHistoricoItem extends StatelessWidget {
  final SenhaChamada item;
  final bool isPrioritaria;

  const TvHistoricoItem({
    super.key,
    required this.item,
    required this.isPrioritaria,
  });

  @override
  Widget build(BuildContext context) {
    final color = isPrioritaria ? Colors.orange[400] : Colors.blue[400];

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          item.senha,
          style: TextStyle(
            color: color,
            fontSize: 48,
            fontWeight: FontWeight.bold,
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            const Text(
              'GUICHÊ',
              style: TextStyle(color: Colors.white54, fontSize: 16),
            ),
            Text(
              '${item.mesa}',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 36,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
