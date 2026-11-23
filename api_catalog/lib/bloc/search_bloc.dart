import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../data/product_api.dart';
import '../models/product.dart';
import 'search_event.dart';
import 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  SearchBloc(this._api) : super(const SearchIdle()) {
    on<SearchQueryChanged>(_onQueryChanged, transformer: restartable());
  }

  final ProductApi _api;
  ProductApi get api => _api;

  Future<void> _onQueryChanged(
    SearchQueryChanged event,
    Emitter<SearchState> emit,
  ) async {
    final query = event.query.trim();
    if (query.isEmpty) {
      emit(const SearchIdle());
      return;
    }
    emit(SearchLoading(query));
    try {
      final page = await _api.searchProducts(query);
      if (!emit.isDone) emit(SearchLoaded(query, page.products));
    } on Exception catch (error) {
      if (!emit.isDone) emit(SearchFailure(query, error.toString()));
    }
  }
}
