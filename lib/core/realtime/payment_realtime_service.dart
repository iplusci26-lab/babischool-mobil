import 'dart:async';

class PaymentRealtimeService {
  PaymentRealtimeService._();

  static final PaymentRealtimeService instance =
      PaymentRealtimeService._();

  //----------------------------------------------------------
  // CONTROLLER
  //----------------------------------------------------------

  final StreamController<void> _controller =
      StreamController<void>.broadcast();

  //----------------------------------------------------------
  // STREAM
  //----------------------------------------------------------

  Stream<void> get stream =>
      _controller.stream;

  //----------------------------------------------------------
  // NOTIFIER
  //----------------------------------------------------------

  void notify() {

    if (!_controller.isClosed) {

      _controller.add(null);

    }

  }

  //----------------------------------------------------------
  // LIBÉRATION
  //----------------------------------------------------------

  void dispose() {

    _controller.close();

  }
}