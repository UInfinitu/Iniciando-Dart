import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(colorScheme: .fromSeed(seedColor: Colors.deepPurple)),
      home: const TelaFinalizarPedido(title: 'Tela de Login'),
    );
  }
}

class ItemCarrinho {
  final String id;
  final String nome;
  final String observacao;
  final String imagemUrl;
  final double preco;
  double quantidade;

  ItemCarrinho({
    required this.id,
    required this.nome,
    this.observacao = "",
    required this.imagemUrl,
    required this.preco,
    required this.quantidade,
  });
}

class Endereco {
  final String id;
  final String logradouro;
  final String complemento;

  Endereco({required this.id, required this.logradouro, this.complemento = ""});
}

enum MetodoPagamento { cartaoCredito, cartaoDebito, pix }

class SecaoPedido extends StatelessWidget {
  const SecaoPedido({super.key, required this.titulo, required this.child});

  final String titulo;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(titulo, style: Theme.of(context).textTheme.titleMedium),
          child,
        ],
      ),
    );
  }
}

class CartItemTile extends StatelessWidget {
  const CartItemTile({
    super.key,
    required this.item,
    required this.onAlterarQuantidade,
  });

  final ItemCarrinho item;
  final void Function(ItemCarrinho, {bool incrementar}) onAlterarQuantidade;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.fromLTRB(12, 4, 12, 4),
      child: Padding(
        padding: EdgeInsets.all(8.0),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Image.network(
                item.imagemUrl,
                width: 80,
                height: 80,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.nome,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    item.observacao,
                    style: Theme.of(
                      context,
                    ).textTheme.bodySmall?.copyWith(color: Colors.grey),
                  ),
                  SizedBox(height: 8),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.remove_circle_outline),
                        onPressed: () {
                          onAlterarQuantidade(item, incrementar: false);
                        },
                      ),
                      Text(item.quantidade.toString()),
                      IconButton(
                        icon: Icon(Icons.add_circle_outline),
                        onPressed: () {
                          onAlterarQuantidade(item, incrementar: true);
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TelaFinalizarPedido extends StatefulWidget {
  const TelaFinalizarPedido({super.key, required this.title});

  final String title;

  @override
  State<TelaFinalizarPedido> createState() => _TelaFinalizarPedidoState();
}

class _TelaFinalizarPedidoState extends State<TelaFinalizarPedido> {
  void _alterarQuantidade(
    ItemCarrinho itemCarrinho, {
    bool incrementar = true,
  }) {
    setState(() {
      if (incrementar) {
        itemCarrinho.quantidade += 1;
      } else {
        itemCarrinho.quantidade -= 1;
      }
    });
  }

  final List<ItemCarrinho> _itens = [
    ItemCarrinho(
      id: "1",
      nome: "Pizza de Pepperoni",
      observacao: "Sem cebola",
      imagemUrl: "",
      preco: 59.99,
      quantidade: 1,
    ),
    ItemCarrinho(
      id: "2",
      nome: "Onigiri",
      imagemUrl: "",
      preco: 49.99,
      quantidade: 1,
    ),
    ItemCarrinho(
      id: "3",
      nome: "X-Salada",
      observacao: "Dobro de Hambúrguer",
      imagemUrl: "",
      preco: 54.99,
      quantidade: 1,
    ),
  ];

  final Endereco endereco = Endereco(
    id: "1",
    logradouro: "Rua das Flores, 123",
    complemento: "Apto 45",
  );

  double get _subtotal {
    return _itens.fold(
      0,
      (total, item) => total + (item.preco * item.quantidade),
    );
  }

  void _confirmarPedido() {
    print("Pedido confirmado! Total: ${(_subtotal + 10).toStringAsFixed(2)}");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Finalizar Pedido")),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              shrinkWrap: false,
              children: [
                SecaoPedido(
                  titulo: "Itens do Pedido",
                  child: Column(
                    children: _itens
                        .map(
                          (item) => Dismissible(
                            key: ValueKey(item.id),
                            direction: DismissDirection.endToStart,
                            background: Container(
                              color: Colors.red,
                              alignment: Alignment.centerRight,
                              padding: EdgeInsets.symmetric(horizontal: 20),
                              child: Icon(Icons.delete, color: Colors.white),
                            ),
                            child: CartItemTile(
                              item: item,
                              onAlterarQuantidade: _alterarQuantidade,
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ),
                SecaoPedido(
                  titulo: "Endereço de Entrega",
                  child: Card(
                    margin: EdgeInsets.all(12),
                    child: ListTile(
                      leading: Icon(Icons.location_on_outlined),
                      title: Text(endereco.logradouro),
                      subtitle: Text(endereco.complemento),
                      trailing: TextButton(
                        onPressed: () {},
                        child: Text('Alterar'),
                      ),
                    ),
                  ),
                ),
                SecaoPedido(
                  titulo: "Forma de Pagamento",
                  child: Column(
                    children: [
                      RadioListTile(
                        title: Text("Cartão de Crédito"),
                        value: MetodoPagamento.cartaoCredito,
                      ),
                      RadioListTile(
                        title: Text("Cartão de Débito"),
                        value: MetodoPagamento.cartaoDebito,
                      ),
                      RadioListTile(
                        title: Text("Pix"),
                        value: MetodoPagamento.pix,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border(top: BorderSide(color: Colors.grey)),
              boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [Text("Subtotal: ${_subtotal.toStringAsFixed(2)}")],
                ),
                Row(children: [Text("Taxa de Entrega: 10.00")]),
                Divider(),
                Row(
                  children: [
                    Text(
                      "Total: ",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      (_subtotal + 10).toStringAsFixed(2),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ).copyWith(color: Theme.of(context).colorScheme.primary),
                    ),
                  ],
                ),
                SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    child: Text(
                      "Confirmar Pedido ${(_subtotal + 10).toStringAsFixed(2)}",
                    ),
                    onPressed: () {
                      _confirmarPedido();
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
