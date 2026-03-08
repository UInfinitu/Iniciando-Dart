// Estrutura de retorno com o padrão Result
sealed class Result<T> {}

class Success<T> extends Result<T> {
  final T value;
  Success(this.value);
}

class Failure<T> extends Result<T> {
  final String message;
  Failure(this.message);
}

enum StatusPedido { pendente, confirmado, preparando, entregue, cancelado }

String statusParaTexto(StatusPedido status) => switch (status) {
  StatusPedido.pendente => 'Aguardando confirmação',
  StatusPedido.confirmado => 'Pedido confirmado',
  StatusPedido.preparando => 'Em preparo',
  StatusPedido.entregue => 'Entregue',
  StatusPedido.cancelado => 'Cancelado',
};

class ItemPedido {
  final String nomeProduto;
  final int quantidade;
  final double precoUnitario;
  final String? observacao; // Pode ser null: campo opcional no formulário

  // Construtor da Classe
  const ItemPedido({
    required this.nomeProduto,
    required this.quantidade,
    required this.precoUnitario,
    this.observacao, // Não é 'required': fica null se não fornecido
  });
}

class Pedido {
  final String id;
  final String idUsuario;
  final List<ItemPedido> itens;
  final StatusPedido status;
  final DateTime criadoEm;

  const Pedido({
    required this.id, 
    required this.idUsuario,
    required this.itens, 
    required this.status,
    required this.criadoEm
  });
}

// Definindo a classe de Relatório de pedidos.
class RelatorioPedidos {
  final String id;
  final List<Pedido> pedidos;

  // construtor
  const RelatorioPedidos({
    required this.id,
    required this.pedidos,
  });

  // Retorna a soma dos valores de todos os pedidos não cancelados
  double totalGeral() {
    return pedidos
      .where((p) => p.status != StatusPedido.cancelado) // Filtra os válidos
      .expand((p) => p.itens) // Transforma lista de pedidos em lista de itens
      .fold(0.0, (total, item) => total + (item.precoUnitario * item.quantidade)); // Soma tudo
  }


  // Retornar um map agrupando os pedidos pelo status
  Map<StatusPedido, List<Pedido>> pedidosPorStatus(StatusPedido status) {
    // Criando uma lista a partir de pedidos com status relacionado.
    final listaPedidos = pedidos.where((p) => p.status == status).toList();
    Map<StatusPedido, List<Pedido>> mapPedido = {status: listaPedidos};
    return mapPedido;
  }

  // Retornar o valor médio de um pedido não cancelado,
  // retornando 0.0 se não houver pedidos válidos para evitar divisão por zero
  double ticketMedio() {
    double ticketMedio = 0.0;

    // Somando todos os itens dos pedidos não cancelados
    final total = pedidos
      .where((p) => p.status != StatusPedido.cancelado)
      .expand((p) => p.itens)
      .fold(0.0, (total, item) => total + (item.precoUnitario * item.quantidade));

    final totalPedidos = pedidos
      .where((p) => p.status != StatusPedido.cancelado).length;

    // dividindo o valor total dos pedidos n cancelados
    // pela quantidade total de pedidos para obter a média
    if(total > 0) 
      ticketMedio = (total / totalPedidos);

    return ticketMedio;
  }

  // Retornar o nome do produto que aparece
  // com maior quantidade total somada entre todos os itens de todos
  // os pedidos.
  String produtoMaisVendido() {
    var mapa = pedidos
      .expand((pedido) => pedido.itens)
      .fold<Map<String, int>>({}, (acc, item) {
        acc[item.nomeProduto] = (acc[item.nomeProduto] ?? 0) + item.quantidade;
        return acc;
      });

    var maior = mapa.entries.reduce((a, b) => a.value > b.value ? a : b);

    return maior.key;
  }

  // Retorna a lista de pedidos de tal uisuário ordernado p mais recente ao
  // mais antigo
  List<Pedido> pedidosDoUsuario(String idUsuario) {
    // filtra os pedidos com base no idUsuario
    final filtrados = pedidos.where((p) => p.idUsuario == idUsuario).toList();
    filtrados.sort((a, b) => b.criadoEm.compareTo(a.criadoEm));
    return filtrados;
  }

  // Retornar true se houver pelo menos um pedido
  // com status pendente e criado a mais de 30 minutos
  bool contemPedidoUrgente(){
    return this.pedidos
      .any((p) => p.status == StatusPedido.pendente && DateTime.now().difference(p.criadoEm).inMinutes > 30);
  }
}

// Função assíncrona de RelatorioPedidos a partir da classe Result.
// Retorna Failure se a lista estiver vazia
// Caso contrário, Success.
Future<Result<RelatorioPedidos>> gerarRelatorio(List<Pedido> pedidos) async {
  // pequeno atraso de carregamento
  await Future.delayed(Duration(seconds: 1));

  // se a lista estiver vazia, retorna Failure
  if (pedidos.isEmpty) {
    return Failure("Não é possível gerar relatório de uma lista vazia.");
  }

  // Se tiver dados, cria a classe e retorna Success
  final relatorio = RelatorioPedidos(
    // Criando o id único a partir da data atual
    id: "REL-${DateTime.now().millisecondsSinceEpoch}",
    pedidos: pedidos,
  );

  return Success(relatorio);
}

void main() async {

  // Criando uma data base para os cálculos de tempo
  final agora = DateTime.now();

  // lista com 8 pedidos de usuários diferentes e status variados
  List<Pedido> meusPedidos = [
    Pedido(
      id: 'P01',
      idUsuario: 'user_1',
      status: StatusPedido.entregue,
      criadoEm: agora.subtract(Duration(days: 1)),
      itens: [
        ItemPedido(nomeProduto: 'Hambúrguer Gourmet', quantidade: 2, precoUnitario: 35.0),
        ItemPedido(nomeProduto: 'Batata Frita', quantidade: 1, precoUnitario: 15.0),
      ],
    ),
    Pedido(
      id: 'P02',
      idUsuario: 'user_2',
      status: StatusPedido.cancelado, // Não entra no totalGeral nem ticketMedio
      criadoEm: agora.subtract(Duration(hours: 5)),
      itens: [
        ItemPedido(nomeProduto: 'Pizza Margherita', quantidade: 1, precoUnitario: 50.0),
      ],
    ),
    Pedido(
      id: 'P03',
      idUsuario: 'user_3',
      status: StatusPedido.pendente,
      criadoEm: agora.subtract(Duration(minutes: 45)), // Urgente (> 30 min)
      itens: [
        ItemPedido(nomeProduto: 'Refrigerante 2L', quantidade: 3, precoUnitario: 10.0),
      ],
    ),
    Pedido(
      id: 'P04',
      idUsuario: 'user_4',
      status: StatusPedido.preparando,
      criadoEm: agora.subtract(Duration(minutes: 10)),
      itens: [
        ItemPedido(nomeProduto: 'Hambúrguer Gourmet', quantidade: 1, precoUnitario: 35.0),
      ],
    ),
    Pedido(
      id: 'P05',
      idUsuario: 'user_5',
      status: StatusPedido.confirmado,
      criadoEm: agora.subtract(Duration(hours: 2)),
      itens: [
        ItemPedido(nomeProduto: 'Sushi Combo 20pcs', quantidade: 1, precoUnitario: 85.0),
        ItemPedido(nomeProduto: 'Refrigerante 2L', quantidade: 1, precoUnitario: 10.0),
      ],
    ),
    Pedido(
      id: 'P06',
      idUsuario: 'user_6',
      status: StatusPedido.entregue,
      criadoEm: agora.subtract(Duration(days: 2)),
      itens: [
        ItemPedido(nomeProduto: 'Suco Natural', quantidade: 2, precoUnitario: 12.0),
      ],
    ),
    Pedido(
      id: 'P07',
      idUsuario: 'user_7',
      status: StatusPedido.pendente,
      criadoEm: agora.subtract(Duration(minutes: 5)), // Não é urgente (< 30 min)
      itens: [
        ItemPedido(nomeProduto: 'Hambúrguer Gourmet', quantidade: 1, precoUnitario: 35.0),
      ],
    ),
    Pedido(
      id: 'P08',
      idUsuario: 'user_7',
      status: StatusPedido.preparando,
      criadoEm: agora.subtract(Duration(minutes: 20)),
      itens: [
        ItemPedido(nomeProduto: 'Batata Frita', quantidade: 2, precoUnitario: 15.0),
      ],
    ),
  ];

  // 2. Executando a lógica do Relatório
  print("--- Iniciando Processamento ---");
  final resultado = await gerarRelatorio(meusPedidos);

  // Em caso de Success, chama todas as funções de RelatórioPedidos
  switch (resultado) {
    case Success(value: var relatorio):
      print("Relatório ID: ${relatorio.id}");
      print("Total Geral (Não cancelados): R\$ ${relatorio.totalGeral().toStringAsFixed(2)}");
      print("Ticket Médio por pedido: R\$ ${relatorio.ticketMedio().toStringAsFixed(2)}");
      print("Produto mais vendido: ${relatorio.produtoMaisVendido()}");
      print("Há pedidos urgentes? ${relatorio.contemPedidoUrgente() ? 'Sim' : 'Não'}");
      
      // busca por usuário específico (Ex: user_A)
      var pedidosUser1 = relatorio.pedidosDoUsuario('user_1');
      print("\nO user_1 tem ${pedidosUser1.length} pedidos.");
      print("\nPedidos:");
      for (var pedido in pedidosUser1) {
        print("\nPedido ID: ${pedido.id} | Status: ${statusParaTexto(pedido.status)}");
        print("Data: ${pedido.criadoEm}");
      }

    case Failure(message: var erro):
      print("Erro ao gerar: $erro");
  }
}