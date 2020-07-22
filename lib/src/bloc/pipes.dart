import 'dart:async';
import 'dart:ui';

class Pipe<T> {
  StreamController<T> _controller;
  bool hasListeners = false;
  T initialData;
  T _lastData;

  Stream<T> get receive => _controller.stream;

  Pipe({this.initialData}) {
    _controller = StreamController<T>.broadcast();
    _controller.onListen = () {
      hasListeners = true;
    };
  }

  Pipe.single({this.initialData}) {
    _controller = StreamController<T>();
    _controller.onListen = () {
      hasListeners = true;
    };
  }

  void onListen(VoidCallback onListen) {
    _controller.onListen = () {
      hasListeners = true;
      if (onListen != null) onListen();
    };
  }

  void dispose() {
    _controller.close();
  }

  bool send(T data) {
    if (_controller.isClosed || _lastData == data) return false;
    _lastData = data;
    _controller.sink.add(data);
    return true;
  }

  bool throwError(Error error) {
    if (_controller.isClosed) return false;
    _controller.sink.addError(error);
    return true;
  }
}

class EventPipe extends Pipe<void> {
  EventPipe({VoidCallback onListen}) : super(initialData: null);
  EventPipe.single({VoidCallback onListen}) : super.single(initialData: null);

  @override
  get receive => null;

  @override
  bool send(_) {
    if (_controller.isClosed) return false;
    _controller.sink.add(null);
    return true;
  }

  bool launch() => send(null);

  StreamSubscription<void> listen(void onData(), {Function onError}) {
    return _controller.stream.listen((_) => onData(), onError: onError);
  }
}
