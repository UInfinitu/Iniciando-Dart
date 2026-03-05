import 'dart:async';

class SincronizacaoService {
  // StreamController do tipo broadcast: permite múltiplos listeners.
  // Use StreamController.broadcast() quando mais de um widget precisa
  // escutar a mesma Stream.
  final _controller = StreamController<StatusPedido>.broadcast();

  // Expõe apenas a Stream (não o Controller) — encapsulamento correto
  Stream<StatusPedido> get statusStream => _controller.stream;

  // Simula o progresso de um pedido (em um app real, isso viria do servidor)
  Future<void> simularProgresso(String pedidoId) async {
    final etapas = [
      StatusPedido.confirmado,
      StatusPedido.preparando,
      StatusPedido.entregue,
    ];

    for (final status in etapas) {
      // Emite o novo status para todos os listeners
      _controller.sink.add(status);
      // Simula o tempo entre cada mudança de status
      await Future.delayed(const Duration(seconds: 2));
    }

    // Fecha o controller quando o processo termina
    await _controller.close();
  }

  // IMPORTANTE: sempre fechar o StreamController quando não for mais usado
  // para evitar vazamentos de memória
  void dispose() {
    if (!_controller.isClosed) {
      _controller.close();
    }
  }
}

// Consumindo a Stream com await for
Future<void> monitorarPedido(RastreamentoPedidoService service) async {
  print('Monitorando pedido...');

  // 'await for' é como um 'for-in' para Streams: espera cada novo valor
  await for (final status in service.statusStream) {
    print('Novo status: ${statusParaTexto(status)}');
  }

  print('Pedido finalizado — Stream encerrada');
}

// Consumindo a Stream com listen (estilo callback)
void monitorarComListen(RastreamentoPedidoService service) {
  // listen retorna uma StreamSubscription que você pode usar para cancelar
  final subscription = service.statusStream.listen(
    (status) {
      // Chamado cada vez que um novo status é emitido
      print('Novo status: ${statusParaTexto(status)}');
    },
    onError: (Object erro) {
      // Chamado se a Stream emitir um erro
      print('Erro no rastreamento: $erro');
    },
    onDone: () {
      // Chamado quando a Stream é fechada
      print('Rastreamento concluído');
    },
  );

  // Exemplo: cancelar o rastreamento após 5 segundos
  Future.delayed(const Duration(seconds: 5), () {
    subscription.cancel();
    print('Rastreamento cancelado pelo usuário');
  });
}
