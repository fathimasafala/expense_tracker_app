part of 'search_cubit.dart';

@immutable
sealed class SearchState {}

final class SearchInitial extends SearchState {}

final class SearchLoading extends SearchState {}

final class SearchSuccess extends SearchState {
  final List<Transaction> transactions;

  SearchSuccess({required this.transactions});
}

final class SearchError extends SearchState {
  final String error;

  SearchError({required this.error});
}
