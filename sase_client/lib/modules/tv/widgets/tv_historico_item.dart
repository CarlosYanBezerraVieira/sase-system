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
        Expanded(
          flex: 3,
          child: FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              item.senha,
              style: TextStyle(
                color: color,
                fontSize:
                    44, 
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),

        const SizedBox(width: 16),

        Expanded(
          flex: 2, 
          child: FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment
                .centerRight,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                const Text(
                  'GUICHÊ',
                  style: TextStyle(
                    color: Colors.white54,
                    fontSize: 14,
                    letterSpacing: 1,
                  ),
                ),
                Text(
                  '${item.mesa}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}