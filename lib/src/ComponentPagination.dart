part of nyxx_pagination;

abstract class ComponentPagination extends IPagination {
  @override
  final Nyxx client;
  final Interactions interactions;

  late final ComponentMessageBuilder messageBuilder;
  late final String customPreId;

  late Message resultingMessage;

  ComponentPagination(this.client, this.interactions) {
    this.customPreId = randomAlpha(5);
    this.messageBuilder = ComponentMessageBuilder();

    setupButtons(this.messageBuilder);
  }

  @override
  FutureOr<void> setup() {
    setupButtons(messageBuilder);
  }

  @override
  FutureOr<void> updatePage() => this.resultingMessage.edit(this.messageBuilder);

  FutureOr<void> setupButtons(ComponentMessageBuilder builder) {
    final firstPageButtonId = "${customPreId}firstPage";
    final firstPageButton = ButtonBuilder("<<", firstPageButtonId, ComponentStyle.secondary);
    interactions.onButtonEvent.where((event) => event.interaction.customId == firstPageButtonId).listen((event) => onFirstPageButtonClicked());

    final previousPageButtonId = "${customPreId}previousPage";
    final previousPageButton = ButtonBuilder("<", previousPageButtonId, ComponentStyle.secondary);
    interactions.onButtonEvent.where((event) => event.interaction.customId == previousPageButtonId).listen((event) => onPreviousPageButtonClicked());

    final nextPageButtonId = "${customPreId}nextPage";
    final nextPageButton = ButtonBuilder(">", nextPageButtonId, ComponentStyle.secondary);
    interactions.onButtonEvent.where((event) => event.interaction.customId == nextPageButtonId).listen((event) => onNextPageButtonClicked());

    final lastPageButtonId = "${customPreId}lastPage";
    final lastPageButton = ButtonBuilder(">>", lastPageButtonId, ComponentStyle.secondary);
    interactions.onButtonEvent.where((event) => event.interaction.customId == lastPageButtonId).listen((event) => onLastPageButtonClicked());

    builder.components = [
      [
        firstPageButton,
        previousPageButton,
        nextPageButton,
        lastPageButton,
      ]
    ];
  }
}
