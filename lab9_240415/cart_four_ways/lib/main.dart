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
    body: _pages[_selected],
    bottomNavigationBar: NavigationBar(
      selectedIndex: _selected,
      onDestinationSelected: (index) => setState(() => _selected = index),
      destinations: const [
        NavigationDestination(icon: Icon(Icons.touch_app), label: 'setState'),
        NavigationDestination(
          icon: Icon(Icons.bubble_chart_outlined),
          label: 'Cubit',
        ),
        NavigationDestination(
          icon: Icon(Icons.account_tree_outlined),
          label: 'BLoC',
        ),
        NavigationDestination(
          icon: Icon(Icons.hub_outlined),
          label: 'Riverpod',
        ),
      ],
    ),
  );
}
