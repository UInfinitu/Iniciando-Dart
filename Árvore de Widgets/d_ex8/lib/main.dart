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
      home: const TelaCatalogo(title: 'Tela de Login'),
    );
  }
}

class Produto {
  final String id;
  final String nome;
  final String categoria;
  final double preco;
  final double avaliacao;
  final String imagemUrl;

  Produto({
    required this.id,
    required this.nome,
    required this.categoria,
    required this.preco,
    required this.avaliacao,
    required this.imagemUrl,
  });
}

class CartaoProduto extends StatelessWidget {
  const CartaoProduto({
    super.key,
    required this.produto,
    required this.onAdicionarNoCarrinho,
  });

  final Produto produto;
  final VoidCallback onAdicionarNoCarrinho;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          Stack(
            children: [
              Image(
                height: 120,
                fit: BoxFit.cover,
                image: NetworkImage(produto.imagemUrl),
              ),
              Positioned(
                top: 8,
                right: 8,
                child: CircleAvatar(
                  radius: 16,
                  backgroundColor: Colors.white,
                  child: Icon(
                    Icons.favorite_border,
                    size: 18,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  produto.nome,
                  maxLines: 2,
                  style: Theme.of(
                    context,
                  ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 4),
                Row(
                  children: [
                    Row(
                      children: [
                        Icon(Icons.star, size: 14, color: Colors.amber),
                        Text(
                          produto.avaliacao.toStringAsFixed(1),
                          style: Theme.of(context).textTheme.labelSmall,
                        ),
                      ],
                    ),
                    Text(
                      produto.preco.toStringAsFixed(2),
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton.tonal(
                    onPressed: onAdicionarNoCarrinho,
                    child: Text("Adicionar"),
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

class TelaCatalogo extends StatefulWidget {
  const TelaCatalogo({super.key, required this.title});

  final String title;

  @override
  State<TelaCatalogo> createState() => _TelaCatalogoState();
}

class _TelaCatalogoState extends State<TelaCatalogo> {
  final List<String> categorias = [
    "Todos",
    "Pizza",
    "Hamburguer",
    "Sushi",
    "Bebidas",
  ];

  String _categoriaSelecionada = "Todos";

  void _selecionarCategoria(String categoria) {
    setState(() {
      _categoriaSelecionada = categoria;
    });
  }

  final List<Produto> produtos = [
    Produto(
      id: "1",
      nome: "Pizza de Pepperoni",
      categoria: "Pizza",
      preco: 59.99,
      avaliacao: 4.5,
      imagemUrl: "",
    ),
    Produto(
      id: "2",
      nome: "Pizza de Muzzarella",
      categoria: "Pizza",
      preco: 49.99,
      avaliacao: 4.7,
      imagemUrl: "",
    ),
    Produto(
      id: "3",
      nome: "Pizza de Calabresa",
      categoria: "Pizza",
      preco: 54.99,
      avaliacao: 4.3,
      imagemUrl: "",
    ),
    Produto(
      id: "4",
      nome: "X-Salada",
      categoria: "Hamburguer",
      preco: 34.99,
      avaliacao: 4.5,
      imagemUrl: "",
    ),
    Produto(
      id: "5",
      nome: "X-Bacon",
      categoria: "Hamburguer",
      preco: 36.99,
      avaliacao: 4.7,
      imagemUrl: "",
    ),
    Produto(
      id: "6",
      nome: "X-Tudo",
      categoria: "Hamburguer",
      preco: 44.99,
      avaliacao: 4.3,
      imagemUrl: "",
    ),
    Produto(
      id: "7",
      nome: "Onigiri",
      categoria: "Sushi",
      preco: 13.99,
      avaliacao: 4.5,
      imagemUrl: "",
    ),
    Produto(
      id: "8",
      nome: "Temaki",
      categoria: "Sushi",
      preco: 19.99,
      avaliacao: 4.7,
      imagemUrl: "",
    ),
    Produto(
      id: "9",
      nome: "Mochi",
      categoria: "Sushi",
      preco: 7.99,
      avaliacao: 4.3,
      imagemUrl: "",
    ),
    Produto(
      id: "10",
      nome: "Coca-Cola",
      categoria: "Bebidas",
      preco: 5.99,
      avaliacao: 4.5,
      imagemUrl: "",
    ),
    Produto(
      id: "11",
      nome: "Guaraná Antarctica",
      categoria: "Bebidas",
      preco: 4.99,
      avaliacao: 4.7,
      imagemUrl: "",
    ),
    Produto(
      id: "12",
      nome: "Dolly",
      categoria: "Bebidas",
      preco: 3.99,
      avaliacao: 4.3,
      imagemUrl: "",
    ),
  ];

  List<Produto> get produtosFiltrados {
    if (_categoriaSelecionada == "Todos") {
      return produtos;
    }
    return produtos.where((p) => p.categoria == _categoriaSelecionada).toList();
  }

  void _adicionarAoCarrinho(Produto produto) {
    print("Produto adicionado: ${produto.nome}");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Cardápio"),
        actions: [
          IconButton(onPressed: () {}, icon: Icon(Icons.filter_alt_rounded)),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            height: 56,
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  spreadRadius: 1,
                  blurRadius: 10,
                  offset: Offset(0, 5),
                ),
              ],
            ),
            child: ListView.builder(
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () => _selecionarCategoria(categorias[index]),
                  child: AnimatedContainer(
                    duration: Duration(milliseconds: 300),
                    margin: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: _categoriaSelecionada == categorias[index]
                          ? Colors.deepPurple
                          : Colors.white,
                    ),
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
                      child: Text(
                        categorias[index],
                        style: TextStyle(
                          color: _categoriaSelecionada == categorias[index]
                              ? Colors.white
                              : Colors.black,
                        ),
                      ),
                    ),
                  ),
                );
              },
              scrollDirection: Axis.horizontal,
              itemCount: categorias.length,
            ),
          ),
          Expanded(
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
              ),
              padding: EdgeInsets.all(12),
              itemCount: produtosFiltrados.length,
              itemBuilder: (context, index) {
                final produto = produtosFiltrados[index];

                return CartaoProduto(
                  produto: produto,
                  onAdicionarNoCarrinho: () => _adicionarAoCarrinho(produto),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
