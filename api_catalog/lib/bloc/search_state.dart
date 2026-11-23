import '../models/product.dart';

sealed class SearchState {
  const SearchState();
}

final class SearchIdle extends SearchState {
  const SearchIdle();
}

final class SearchLoading extends SearchState {
  const SearchLoading(this.query);
  final String query;
}

final class SearchLoaded extends SearchState {
  const SearchLoaded(this.query, this.products);
  final String query;
  final List<Product> products;
}

final class SearchFailure extends SearchState {
  const SearchFailure(this.query, this.message);
  final String query;
  final String message;
}
