import 'dart:async';

import 'package:nyxx/nyxx.dart';

/// Base interface for implementing pagination
abstract class IPagination<T, S extends MessageBuilder> {
  /// Current page that paginator is on
  int get currentPage;

  /// Number of pages
  int get maxPage;

  /// Initializes [MessageBuilder] with stuff need to paginate. Also hooks needed event to allow pagination.
  S initMessageBuilder();

  /// Returns [MessageBuilder] for [page] number. Always modify builder passed in [currentBuilder] argument.
  S getMessageBuilderForPage(int page, S currentBuilder);

  /// Invoked on each page update. Current page number is passed in [page] argument.
  /// Builder that message should be edited with is passed in [currentBuilder] argument.
  /// [target] parameter is generic and allows customization of how message will be modified.
  FutureOr<void> updatePage(int page, S currentBuilder, T target);

  /// Invoked on first page button click
  void onFirstPageButtonClicked();

  /// Invoked when previous page button is clicked.
  void onPreviousPageButtonClicked();

  /// Invoked when next page button is clicked.
  void onNextPageButtonClicked();

  /// Invoked when last page button is clicked.
  void onLastPageButtonClicked();
}
