import 'package:flutter/material.dart';

//classe que gera o appbar, colocando a imagem que representa o status se ganhou, perdeu, ou ainda está jogando
class BarraResultado extends StatelessWidget implements PreferredSizeWidget {
  final bool? venceu;
  final VoidCallback reiniciar;

  // ignore: use_key_in_widget_constructors
  const BarraResultado({
    required this.venceu,
    required this.reiniciar,
  });

  //cor da 'carinha' de acordo com o resultado
  Color _corResultado() {
    if (venceu == null) {
      return Colors.grey;
    } else if (venceu == true) {
      return Colors.green;
    } else {
      return Colors.red;
    }
  }

  //icone do rosto referente ao resultado
  IconData _carinha() {
    if (venceu == null) {
      return Icons.sentiment_satisfied;
    } else if (venceu == true) {
      return Icons.sentiment_very_satisfied;
    } else {
      return Icons.sentiment_very_dissatisfied;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(10),
          child: CircleAvatar(
            backgroundColor: _corResultado(),
            child: IconButton(
              padding: const EdgeInsets.all(0),
              icon: Icon(
                _carinha(),
                color: Colors.black,
                size: 35,
              ),
              onPressed: reiniciar,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(120);
}
