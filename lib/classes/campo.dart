import 'package:flutter/foundation.dart';
import 'explosao_exception.dart';

//classe que gera a lógica de cada campo
class Campo {
  //linha e coluna referente a um campo
  final int? lin;
  final int? col;
  //lista de vizinhos de um campo
  final List<Campo> vizinhos = [];

  //campos de status referentes a cada um dos campos
  bool _aberto = false;
  bool _comBandeira = false;
  bool _comBomba = false;
  bool _explodido = false;
  bool _bandeiraErrada = false;

  Campo({
    @required this.lin,
    @required this.col,
  });

  void adicionarVizinho(Campo vizinho) {
    final deltaLin = (lin! - vizinho.lin!).abs();
    final deltaCol = (col! - vizinho.col!).abs();

    if (deltaLin == 0 && deltaCol == 0) {
      //é o próprio campo, então não faz nada
      return;
    }

    if (deltaLin <= 1 && deltaCol <= 1) {
      //se entrou na condição acima, então é vizinho e adiciona à lista vizinhos
      vizinhos.add(vizinho);
    }
  }

  void clicar() {
    //funcao que 'abre' um campo que está fechado e sem bandeira
    if (!_aberto && !_comBandeira) {
      //só entra se o campo não estava aberto antes
      _aberto = true;
      if (_comBomba) {
        //se o campo está minado, o campo passa a ser explodido
        _explodido = true;
        throw ExplosaoException();
      }
      if (vizinhosSemBombas) {
        //abre recursivamente (chama novemnte a funcao abrir dentro dela mesmo)
        //quando não tem bombas vizinhas
        //abrindo para todos os vizinhos do campo que está com 0 bombas nos vizinhos
        for (var vizinho in vizinhos) {
          //se o vizinho estiver marcado com bandeira, mantem a bandeira
          if (!vizinho._comBandeira) {
            vizinho.clicar();
          }
        }
      }
    }
  }

  void revelarBomba() {
    //revela as bombas (que nao foram marcados) quando o usuario perde
    if (_comBomba && !_comBandeira) {
      _aberto = true;
    }
  }

  void exibirBandeiraErrada() {
    //revela bandeiras marcadas erradas
    if (!_comBomba && _comBandeira) {
      _bandeiraErrada = true;
    }
  }

  void inserirBandeira() {
    //quando o usuario ganha, coloca bandeira nos campos que nao foram colocados
    if (_comBomba && !_comBandeira) {
      _comBandeira = true;
    }
  }

  void insereBomba() {
    //insere mina no campo
    _comBomba = true;
  }

  void inserirRetirarBandeira() {
    //muda marcacao
    _comBandeira = !_comBandeira;
  }

  void reiniciar() {
    //reincializa os campos
    _aberto = false;
    _comBandeira = false;
    _comBomba = false;
    _explodido = false;
    _bandeiraErrada = false;
  }

  bool get comBomba {
    return _comBomba;
  }

  bool get explodido {
    return _explodido;
  }

  bool get aberto {
    return _aberto;
  }

  bool get comBandeira {
    return _comBandeira;
  }

  bool get bandeiraErrada {
    return _bandeiraErrada;
  }

  bool get resolvido {
    //um campo é considerado resolvido se:
    //1 - estiver com uma mina e marcado com a bandeirinha
    bool comBombaEComBandeira = comBomba && comBandeira;
    //2 - estiver sem mina e ele foi aberto
    bool semBombaEAberto = !comBomba && aberto;
    //3 - se estiver com uma mina mas não foi marcado, tbm considera resolvido,
    //nesse caso, a pessoa não precisa perder tempo colocando a bandeirinha caso ela saiba que lá tem bomba
    bool comBombaESemBandeira = comBomba && !comBandeira;

    return comBombaEComBandeira || semBombaEAberto || comBombaESemBandeira;
    //obs, poderia ser apenas bool minado = minado (unificar caso 1 e 2); mas queria evidenciar a possibilidade dos casos
  }

  bool get vizinhosSemBombas {
    //se não tiver bomba nos vizinhos, retorna true (para abrir recursivamente)
    return vizinhos.every((vizinho) => !vizinho.comBomba);
  }

  int get nBombaVizinho {
    //retorna a quantida de bombas nos campos vizinhos para definir qual imagem vai mostrar com o número de bombas
    return vizinhos.where((vizinho) => vizinho.comBomba).length;
  }
}
