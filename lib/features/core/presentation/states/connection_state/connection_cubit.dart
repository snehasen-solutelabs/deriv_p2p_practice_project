import 'package:bloc/bloc.dart';
import 'package:deriv_p2p_practice_project/api/binary_api_wrapper.dart';
import 'package:deriv_p2p_practice_project/features/core/presentation/states/connection_state/connection_state.dart';

///ConnectionCubit
class ConnectionCubit extends Cubit<ConnectionState> {
  /// Initializes ConnectionCubit state.
  ConnectionCubit() : super(ConnectionStateInitialState());

  /// ConnectionCubit states change
  void onConnectionSetup(BinaryAPIWrapper api) {
    emit(ConnectionStateStable(api: api));
  }
}
