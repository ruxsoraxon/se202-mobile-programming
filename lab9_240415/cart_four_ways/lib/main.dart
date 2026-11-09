import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'bloc/cart_page_bloc.dart';
import 'cubit/cart_page_cubit.dart';
import 'riverpod/cart_page_riverpod.dart';
import 'setstate/cart_page_setstate.dart';

void main() => runApp(const ProviderScope(child: CartFourWaysApp()));

class CartFourWaysApp extends StatelessWidget {
  const CartFourWaysApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'Cart: Four Ways',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(colorSchemeSeed: Colors.indigo, useMaterial3: true),
        home: const StateManagementHome(),
      );
}

class StateManagementHome extends StatefulWidget {
  const StateManagementHome({super.key});

  @override
  State<StateManagementHome> createState() => _StateManagementHomeState();
}

class _StateManagementHomeState extends State<StateManagementHome> {
  int _selected = 0;
  static const _pages = <Widget>[
    CartPageSetState(),
    CartPageCubit(),
    CartPageBloc(),
    CartPageRiverpod(),
  ];

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('Shopping Cart')),
        body: Column(children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
            child: SegmentedButton<int>(
              segments: const [
                ButtonSegment(value: 0, label: Text('setState')),
                ButtonSegment(value: 1, label: Text('Cubit')),
                ButtonSegment(value: 2, label: Text('BLoC')),
                ButtonSegment(value: 3, label: Text('Riverpod')),
              ],
              selected: {_selected},
              onSelectionChanged: (selection) =>
                  setState(() => _selected = selection.first),
            ),
          ),
          Expanded(child: _pages[_selected]),
        ]),
      );
}
