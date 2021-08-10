part of nyxx_pagination;

abstract class IPagination {
  int currentPage = 1;

  int get maxPage;
  INyxx get client;

  void onFirstPageButtonClicked() {
    currentPage = 1;
    updatePage();
  }

  void onPreviousPageButtonClicked() {
    currentPage = (currentPage - 1).clamp(1, maxPage);
    updatePage();
  }

  void onNextPageButtonClicked() {
    currentPage = (currentPage + 1).clamp(1, maxPage);
    updatePage();
  }

  void onLastPageButtonClicked() {
    currentPage = maxPage;
    updatePage();
  }

  FutureOr<void> updatePage();
  FutureOr<void> setup();
}
