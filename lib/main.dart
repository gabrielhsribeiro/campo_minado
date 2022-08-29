import 'package:flutter/material.dart';
import 'components/monta_tabuleiro.dart';
import 'components/barra_resultado.dart';
import 'classes/tabuleiro.dart';
import 'classes/campo.dart';
import 'classes/explosao_exception.dart';

void main() {
  runApp(const CampoMinado());
}

class CampoMinado extends StatefulWidget {
  const CampoMinado({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _CampoMinadoAppState createState() => _CampoMinadoAppState();
}

class _CampoMinadoAppState extends State<CampoMinado> {
  bool? _venceu;
  Tabuleiro? _tabuleiro;

  void _reiniciar() {
    //reinicia o jogo
    setState(() {
      _venceu = null;
      _tabuleiro?.reiniciar();
    });
  }

  void _clicar(Campo campo) {
    //funcao responsavel para tratar quando o usuário clica em um campo
    if (_venceu == null) {
      setState(() {
        try {
          campo.clicar();
          if (_tabuleiro!.resolvido) {
            //se o tabuleiro está resolvido, atualiza a flag venceu
            _venceu = true;
            //e insere bandeiras nos campos de bombas(para caso o usuário não tivesse inserido)
            _tabuleiro!.inserirBandeiras();
          }
        } on ExplosaoException {
          //se explode, atualiza a flag venceu como false, e revela as bombas
          _venceu = false;
          _tabuleiro!.exibirBandeirasErradas();
          _tabuleiro!.revelarBombas();
        }
      });
    }
  }

  void _colocaTiraBandeira(Campo campo) {
    //funcao para inserir ou não a bandeira
    if (_venceu == null) {
      setState(() {
        campo.inserirRetirarBandeira();
        if (_tabuleiro!.resolvido) {
          _venceu = true;
        }
      });
    }
  }

  // ignore: unused_element
  Tabuleiro _getTabuleiro(double largura, double altura, {int? nBombas}) {
    //vou reinicializar o tabuleiro se ele não existia, ou se mudou a qdade de bombas
    if (_tabuleiro == null || _tabuleiro!.nBombas != nBombas) {
      int qtdeColunas = 15;
      double tamanhoCampo = largura / qtdeColunas;
      int qtdeLinhas = (altura / tamanhoCampo).floor();

      _tabuleiro = Tabuleiro(
        lins: qtdeLinhas,
        cols: qtdeColunas,
        nBombas: nBombas,
      );
    }
    return _tabuleiro!;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        //o app bar chama o componente barra_resultado.dart
        appBar: BarraResultado(
          venceu: _venceu,
          reiniciar: _reiniciar,
        ),
        //o body chama o componente monta_tabuleiro.dart
        body: Container(
          color: Colors.grey,
          child: LayoutBuilder(
            builder: (ctx, constraints) {
              return MontaTabuleiro(
                tabuleiro: _getTabuleiro(
                    constraints.maxWidth, constraints.maxHeight,
                    nBombas:
                        15), //colocar numero de bombas como input do usuario
                clicar: _clicar,
                colocaTiraBandeira: _colocaTiraBandeira,
              );
            },
          ),
        ),
      ),
    );
  }
}
