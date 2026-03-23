graph TD
A["TelaInicial<br/>(StatelessWidget)"] --> B["Scaffold"]
B --> C["AppBar"]
B --> D["SingleChildScrollView"]
B --> E["FloatingActionButton<br/>(icon: add, contador de produtos (vindo de um Provider))"]
D --> G["Padding<br/>(h: 6)"]
G --> F["Column"]
F --> M["BarraDeBusca (StatefulWidget)"]
F --> H["Categorias (StatefulWidget)"]
F --> I["BannerCarrossel (StatefulWidget)"]
F --> J["SecaoMaisPedidos (StatelessWidget)"]
J --> N["[xN] CardMaisPedidos (StatelessWidget)"]
F --> K["SecaoLojasProximas (StatelessWidget)"]
J --> O["[xN] CardLojasProximas (StatelessWidget)"]
B --> L["BottomNavigationBar"]

| Nome               | Tipo            | Justificativa                                                                                                                                                          |
| ------------------ | --------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| BarraDeBusca       | StatefulWidget  | Essa barra terá comportamentos próprios de sugestão de escrita conforme o usuário digita, sendo uma regra isolada desse campo, vejo sentido de separá-lo em um Widget. |
| SecaoCategorias    | StatefulWidget  | Essa seção com os cards de categoria é mais uma parte com lógica própria que, para manter as lógicas isoladas, é melhor deixá-la separada também.                      |
| BannerCarrossel    | StatefulWidget  | Parte exclusivamente para mostrar Banners de promoções e produtos, tem lógica própria para gerenciar o estado dos Banners e botões em baixo.                           |
| SecaoMaisPedidos   | StatelessWidget | Outra seção com rolagem e cards diferente das outras seções, além de link próprio para outra tela.                                                                     |
| CardMaisPedidos    | StatelessWidget | Card com estilização própria diferente de outros cards presentes na tela.                                                                                              |
| SecaoLojasProximas | StatelessWidget | Seção bem semelhante a SecaoMaisPedidos mas preferi separar dela por causa da rolagem vertical.                                                                        |
| CardLojasProximas  | StatelessWidget | Card traz informações semelhantes ao CardMaisPedidos mas tem disposição diferente na tela.                                                                             |

<!-- Para BannerCarrossel manter os indicadores atualizados deve ter um estado que marca o ID do banner selecionado, assim quando o banner for trocado pelo usuário ou automaticamente, o método de gerenciamento do estado é passado após a ação para atualizar o visual dos indicadores. -->
