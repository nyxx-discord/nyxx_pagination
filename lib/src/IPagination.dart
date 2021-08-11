part of nyxx_pagination;

abstract class IPagination<T, S extends MessageBuilder> {
  int currentPage = 1;

  int get maxPage;

  S initMessageBuilder();
  S getMessageBuilderForPage(int page, S currentBuilder);
  FutureOr<void> updatePage(int page, S currentBuilder, T target);

  void onFirstPageButtonClicked() {
    this.currentPage = 1;
  }

  void onPreviousPageButtonClicked() {
    this.currentPage = (this.currentPage - 1).clamp(1, maxPage);
  }

  void onNextPageButtonClicked() {
    currentPage = (currentPage + 1).clamp(1, maxPage);
  }

  void onLastPageButtonClicked() {
    currentPage = maxPage;
  }
}
