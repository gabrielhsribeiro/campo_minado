import 'package:flutter/material.dart';
import '../classes/tabuleiro.dart';
import '../classes/campo.dart';
import 'inicializa_campo_unitario.dart';

//classe para gerar o Stateless do tabuleiro
//é composto de N campos gerados pelo inicializa_campo_unitario.dart
class MontaTabuleiro extends StatelessWidget {
  // const TabuleiroWidget({Key? key}) : super(key: key);
  final Tabuleiro? tabuleiro;
  final void Function(Campo)? clicar;
  final void Function(Campo)? colocaTiraBandeira;

  // ignore: use_key_in_widget_constructors
  const MontaTabuleiro(
      {@required this.tabuleiro, //tabuleiro gerado pela classe tabuleiro.dart
      @required this.clicar,
      @required this.colocaTiraBandeira});

  @override
  Widget build(BuildContext context) {
    // ignore: avoid_unnecessary_containers
    return Container(
        child: GridView.count(
      crossAxisCount: tabuleiro!.cols!,
      children: tabuleiro!.campos.map((campo) {
        return InicializaCampoUnitario(
            campo: campo,
            clicar: clicar,
            colocaTiraBandeira: colocaTiraBandeira);
      }).toList(),
    ));
  }
}
