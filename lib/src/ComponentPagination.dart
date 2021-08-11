part of nyxx_pagination;

abstract class IComponentPagination extends IPagination<ButtonInteractionEvent, ComponentMessageBuilder> {
  final Interactions interactions;
  late final String customPreId;

  late ComponentMessageBuilder _builder;

  IComponentPagination(this.interactions) {
    this.customPreId = randomAlpha(5);
  }

  ComponentMessageBuilder initMessageBuilder() {
    final firstPageButtonId = "${customPreId}firstPage";
    final firstPageButton = ButtonBuilder("<<", firstPageButtonId, ComponentStyle.secondary);
    interactions.onButtonEvent.where((event) => event.interaction.customId == firstPageButtonId).listen((event) async {
      await event.acknowledge();

      this.onFirstPageButtonClicked();
      updatePage(this.currentPage, this._builder, event);
    });

    final previousPageButtonId = "${customPreId}previousPage";
    final previousPageButton = ButtonBuilder("<", previousPageButtonId, ComponentStyle.secondary);
    interactions.onButtonEvent.where((event) => event.interaction.customId == previousPageButtonId).listen((event) async {
      await event.acknowledge();

      this.onPreviousPageButtonClicked();
      updatePage(this.currentPage, this._builder, event);
    });

    final nextPageButtonId = "${customPreId}nextPage";
    final nextPageButton = ButtonBuilder(">", nextPageButtonId, ComponentStyle.secondary);
    interactions.onButtonEvent.where((event) => event.interaction.customId == nextPageButtonId).listen((event) async {
      await event.acknowledge();

      this.onNextPageButtonClicked();
      updatePage(this.currentPage, this._builder, event);
    });

    final lastPageButtonId = "${customPreId}lastPage";
    final lastPageButton = ButtonBuilder(">>", lastPageButtonId, ComponentStyle.secondary);
    interactions.onButtonEvent.where((event) => event.interaction.customId == lastPageButtonId).listen((event) async {
      await event.acknowledge();

      this.onLastPageButtonClicked();
      updatePage(this.currentPage, this._builder, event);
    });

    this._builder = ComponentMessageBuilder()
      ..components = [
        [
          firstPageButton,
          previousPageButton,
          nextPageButton,
          lastPageButton,
        ]
      ];

    return this.getMessageBuilderForPage(1, this._builder);
  }
}
