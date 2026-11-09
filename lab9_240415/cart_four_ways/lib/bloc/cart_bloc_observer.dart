import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

import '../models/cart.dart';

class CartBlocObserver extends BlocObserver {
  @override
  void onTransition(
    Bloc<dynamic, dynamic> bloc,
    Transition<dynamic, dynamic> transition,
  ) {
    super.onTransition(bloc, transition);
    final state = transition.nextState;
    if (state is CartState) {
      debugPrint(
        'BLoC ${transition.event.runtimeType}: '
        '${state.status}, ${state.itemCount} items, total ${state.total}',
      );
    }
  }
}
