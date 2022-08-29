import 'package:flutter/foundation.dart';
import 'dart:math';
import 'campo.dart';

//classe que gera a logica do tabuleiro
class Tabuleiro {
  final int? lins;
  final int? cols;
  final int? nBombas;

  final List<Campo> _campos = [];

  Tabuleiro({
    @required this.lins,
    @required this.cols,
    @required this.nBombas,
  }) {
    _criarCampos();
    _relacionarVizinhos();
    _inserirBombas();
  }

  void reiniciar() {
    for (var campo in _campos) {
      campo.reiniciar();
    }
    _inserirBombas();
  }

  void revelarBombas() {
    //qdo o usuário perde o jogo, exibe todas as bombas
    for (var campo in _campos) {
      campo.revelarBomba();
    }
  }

  void exibirBandeirasErradas() {
    //qdo o usuário perde o jogo, exibe todas as mandeiras marcadas erradas
    for (var campo in _campos) {
      campo.exibirBandeiraErrada();
    }
  }

  void inserirBandeiras() {
    //qdo o usuário ganha o jogo, insere mandeiras nos campos que tem bomba (se não havia bandeira)
    for (var campo in _campos) {
      campo.inserirBandeira();
    }
  }

  void _criarCampos() {
    //criando os campos quando inicializa o tabuleiro
    for (int i = 0; i < lins!; i++) {
      for (int j = 0; j < cols!; j++) {
        _campos.add(Campo(lin: i, col: j));
      }
    }
  }

  void _relacionarVizinhos() {
    //adiciona os vizinhos de cada campo
    for (var campo in _campos) {
      for (var vizinho in _campos) {
        campo.adicionarVizinho(vizinho);
      }
    }
  }

  void _inserirBombas() {
    //sorteia randomicamente as bombas nos campos
    if (nBombas! > (lins! * cols!)) {
      return;
    }
    for (int sorteadas = 0; sorteadas < nBombas!; sorteadas++) {
      int i = Random().nextInt(_campos.length);
      if (!_campos[i].comBomba) {
        _campos[i].insereBomba();
      } else {
        sorteadas--;
      }
    }
  }

  List<Campo> get campos {
    return _campos;
  }

  bool get resolvido {
    return _campos.every((campo) => campo.resolvido);
  }
}
