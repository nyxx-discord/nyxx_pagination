part of nyxx_pagination;

abstract class IPagination<T, S extends MessageBuilder> {
  /// Current page that paginator is on
  int currentPage = 1;

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
  void onFirstPageButtonClicked() => this.currentPage = 1;

  /// Invoked when previous page button is clicked.
  void onPreviousPageButtonClicked() => this.currentPage = (this.currentPage - 1).clamp(1, this.maxPage);

  /// Invoked when next page button is clicked.
  void onNextPageButtonClicked() => this.currentPage = (this.currentPage + 1).clamp(1, this.maxPage);

  /// Invoked when last page button is clicked.
  void onLastPageButtonClicked() => this.currentPage = this.maxPage;
}
