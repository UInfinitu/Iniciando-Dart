import 'dart:async'; // Biblioteca assíncrona do Dart (Stream, StreamController e Future)
import 'dart:math'; // Biblioteca de matemática (Random)

class Produto {
  final String nome;
  final double preco;
  final String categoria;
  final bool disponivel;

  Produto({
    required this.nome,
    required this.preco,
    required this.categoria,
    required this.disponivel,
  });
}

// Classe imutável que representa o estado atual do progresso de sincronização
class ProgressoSincronizacao {
  final int total;
  final int processados;
  final int falha;
  final String mensagem;

  ProgressoSincronizacao({
    required this.total,
    required this.processados,
    required this.falha,
    required this.mensagem,
  });

  double get progresso {
    if (total == 0) return 0.0;
    double prog = processados / total * 100;
    return double.parse(prog.toStringAsFixed(1)); // Arredonda para 1 casa decimal
  }

  ProgressoSincronizacao copyWith({
    int? total,
    int? processados,
    int? falha,
    String? mensagem,
  }) {
    return ProgressoSincronizacao(
      total: total ?? this.total,
      processados: processados ?? this.processados,
      falha: falha ?? this.falha,
      mensagem: mensagem ?? this.mensagem,
    );
  }
}

// Adiciona comportamentos na lista 
extension SincronizacaoProdutoExtension on List<Produto> {

  // Filtra a lista retornando apenas produtos válidos
  List<Produto> validos() {
    return where((p) => p.nome.isNotEmpty && p.preco > 0 && p.disponivel == true).toList();
  }

  // Ordena os produtos de cada categoria pelo preço em ordem crescente
  Map<String, List<Produto>> agrupadosParaSincronizacao() {
    final Map<String, List<Produto>> resultado = {};

    for (final p in this) {
      resultado.putIfAbsent(p.categoria, () => []); // Cria a lista da categoria se ainda não existir
      resultado[p.categoria]!.add(p);
    }

    // Ordena os produtos
    for (final categoria in resultado.keys) {
      resultado[categoria]!.sort((a, b) => a.preco.compareTo(b.preco));
    }
    return resultado;
  }
}

class SincronizacaoService {
  // StreamController libera métodos de stream (add, close e stream) (poderia colocar ".broadcast()" se vários listeners fossem usar essa service)
  final _controller = StreamController<ProgressoSincronizacao>();

  // Expõe o stream para usar "listen" e poder acompanhar o progresso
  Stream<ProgressoSincronizacao> get progressoStream => _controller.stream;

  // Processa os produtos, vai adicionando progresso e retorna quantidade de sucessos ou null (falha total)
  Future<int?> sincronizar(List<Produto> produtos) async {
    // Mensagem inicial para indicar que começou a rodar
    _controller.add(ProgressoSincronizacao(
      total: produtos.length,
      processados: 0,
      falha: 0,
      mensagem: 'Sincronização iniciada...',
    ));

    int sucessos = 0;
    int falhas = 0;

    for (final p in produtos) {
      // Simula latência de rede (entre 100ms e 500ms)
      await Future.delayed(Duration(milliseconds: 100 + Random().nextInt(400)));

      double simulaFalha = Random().nextDouble();

      // Simula ~20% de chance de falha para cada produto
      if (simulaFalha < 0.20) {
        falhas++;
      } else {
        sucessos++;
      }

      // Avisa se foi sucesso ou falha para cada produto
      _controller.add(ProgressoSincronizacao(
        total: produtos.length,
        processados: sucessos + falhas,
        falha: falhas,
        mensagem: simulaFalha < 0.20 ? 'Falha: ${p.nome}' : 'Sincronizado: ${p.nome}',
      ));
    }

    await _controller.close(); // Fecha o stream para evitar vazamento de memória
    return sucessos;
  }

  void dispose() {
    if (!_controller.isClosed) {
      _controller.close(); // Método para fechar o StreamController quando não for mais necessário
    }
  }
}

Future<void> main() async {
  final produtos = [
    Produto(nome: 'Notebook',  preco: 4500, categoria: 'Eletrônicos', disponivel: true),
    Produto(nome: '',          preco: 4500, categoria: 'Eletrônicos', disponivel: true),  // INVÁLIDO: nome vazio
    Produto(nome: 'Notebook',  preco: -1,   categoria: 'Eletrônicos', disponivel: true),  // INVÁLIDO: preço negativo
    Produto(nome: 'Lego',      preco: 2000, categoria: 'Brinquedos',  disponivel: true),
    Produto(nome: 'Bola',      preco: 50,   categoria: 'Brinquedos',  disponivel: false), // INVÁLIDO: indisponível
    Produto(nome: 'Caderno',   preco: 20,   categoria: 'Materiais',   disponivel: true),
    Produto(nome: 'Lapis',     preco: 4,    categoria: 'Materiais',   disponivel: true),
    Produto(nome: 'Celular',   preco: 2000, categoria: 'Eletrônicos', disponivel: true),
    Produto(nome: 'Mouse',     preco: 300,  categoria: 'Eletrônicos', disponivel: false), // INVÁLIDO: indisponível
    Produto(nome: 'Mousepad',  preco: 100,  categoria: 'Eletrônicos', disponivel: true),
  ];

  // Remove o segundo, terceiro, quinto e nono produtos (inválidos) usando a extensão "validos"
  final validos = produtos.validos();

  final service = SincronizacaoService();

  // Mensagens que acompanham conforme os produtos são processados
  service.progressoStream.listen((progresso) {
    print('[${progresso.progresso}%] ${progresso.processados} processados, ${progresso.falha} falhas - ${progresso.mensagem}');
  });

  final resultado = await service.sincronizar(validos);

  // Switch para mostrar mensagem final
  switch (resultado! > 0) {
    case true:
      print('Total de produtos sincronizados com sucesso: $resultado');
      break;
    case false:
      print('Nenhum produto foi sincronizado com sucesso.');
      break;
  }

  service.dispose(); // Garante que fecha o StreamController
}