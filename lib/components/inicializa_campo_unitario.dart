import 'package:flutter/material.dart';
import '../classes/campo.dart';

//classe para inicializar os campos unitários
class InicializaCampoUnitario extends StatelessWidget {
  final Campo? campo;
  final void Function(Campo)? clicar;
  final void Function(Campo)? colocaTiraBandeira;

  // ignore: use_key_in_widget_constructors
  const InicializaCampoUnitario({
    @required this.campo,
    @required this.clicar,
    @required this.colocaTiraBandeira,
  });

  //define qual imagem salva na pasta images será exibida para os campos a depender do seu status
  Widget _defineImagem() {
    if (campo!.aberto && campo!.comBomba && campo!.explodido) {
      return Image.asset('images/explodido.png');
    } else if (campo!.aberto && campo!.comBomba) {
      return Image.asset('images/bomba.png');
    } else if (campo!.aberto && campo!.nBombaVizinho > 0) {
      return Image.asset('images/bomba_vizinha${campo!.nBombaVizinho}.png');
    } else if (campo!.aberto) {
      return Image.asset('images/aberto.png');
    } else if (campo!.bandeiraErrada) {
      return Image.asset('images/bandeira_errada.png');
    } else if (campo!.comBandeira) {
      return Image.asset('images/bandeira.png');
    } else {
      return Image.asset('images/fechado.png');
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => clicar!(campo!),
      onLongPress: () => colocaTiraBandeira!(campo!),
      child: _defineImagem(),
    );
  }
}
