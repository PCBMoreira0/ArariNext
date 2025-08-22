// buffer == lista que mantem as ultimas n entradas adicionadas.

class Buffer<T> {
  
  // variavel para guardar o tamanho do buffer
  int size;

  // lista principal do buffer
  List<T> _mainBuffer = <T>[];

  // metodo add, adiciona um item a lista, removendo o mais antigo se a lista estiver no tamanho maximo.
  void add (T item) {
    if (_mainBuffer.length >= size) {
      // revertendo a lista para podermos remover o objeto mais antigo primeiro
      _mainBuffer = List.from(_mainBuffer.reversed);
      // removendo os objetos mais antigos maiores que n;
      while (_mainBuffer.length >= size) {
        _mainBuffer.removeLast();
      }
      // revertendo a lista de volta ao normal
     _mainBuffer = List.from(_mainBuffer.reversed);
    }
    _mainBuffer.add(item);
  }
  // metodo asList, retorna buffer como lista.
  List<T> asList () {   
    return _mainBuffer.toList();
  }

  // clears buffer
  void clear() {

    _mainBuffer = <T>[];

  }

  @override
  String toString() {

    return _mainBuffer.reversed.toString();

  }
  Buffer({required this.size});
}