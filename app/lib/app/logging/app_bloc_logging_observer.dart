import 'package:bloc/bloc.dart';
import 'package:logging/logging.dart';

/// A Bloc observer that logs Bloc events, state changes, transitions, and errors
class AppBlocLoggingObserver extends BlocObserver {
  final Logger _logger = Logger('AppBlocObserver');

  @override
  void onEvent(Bloc bloc, Object? event) {
    super.onEvent(bloc, event);
    _logger.info('[${bloc.runtimeType}]: Received event ${event.runtimeType}');
  }

  @override
  void onChange(BlocBase bloc, Change change) {
    super.onChange(bloc, change);

    // Only log state changes for Cubits to avoid redundancy with transitions
    if (bloc is Cubit) {
      _logger.info(
        '[${bloc.runtimeType}]: Changed from ${change.currentState.runtimeType} to ${change.nextState.runtimeType}',
      );
    }
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
    _logger.info(
        '[${bloc.runtimeType}]: Transitioned from ${transition.currentState.runtimeType} to ${transition.nextState.runtimeType}');
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    super.onError(bloc, error, stackTrace);
    _logger.severe('[${bloc.runtimeType}]: $error', error, stackTrace);
  }
}
