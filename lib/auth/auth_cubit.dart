// import 'package:bloc/bloc.dart';


// part 'auth_state.dart';


// class AuthCubit extends Cubit<AuthState> {
//   AuthCubit() : super(const AuthState.initial(isAutherise: false)) {

//     FirebaseAuth.instance.authStateChanges().listen((User? user) {
//       if (user == null) {
//         return emit(state.copyWith(isSignedIn: false));
//       } else {
//         emit(state.copyWith(isSignedIn: true));
//       }
//     });
//   }
// }