import 'dart:async';

import 'package:nyxx/nyxx.dart';
import 'package:nyxx_interactions/nyxx_interactions.dart';
import 'package:nyxx_pagination/src/pagination.dart';
import 'package:random_string/random_string.dart';

/// Base component paginator. If don't want custom behavior on page update use [ComponentPaginationBase].
abstract class ComponentPaginationAbstract extends IPagination<IButtonInteractionEvent, ComponentMessageBuilder> {
  /// Reference to [Interactions]
  final IInteractions interactions;

  /// Custom id for this instance of paginator that different paginators could be recognized.
  late final String customPreId;

  /// Current page that paginator is on
  @override
  int currentPage = 1;

  /// Message builder used to create paginated messages
  late ComponentMessageBuilder builder;

  /// Creates new paginator using interactions
  ComponentPaginationAbstract(this.interactions) {
    customPreId = randomAlpha(10);
  }

  /// Inits [ComponentMessageBuilder] with buttons needed for pagination. And hooks needed events.
  @override
  ComponentMessageBuilder initMessageBuilder() {
    final firstPageButtonId = "${customPreId}firstPage";
    final firstPageButton = ButtonBuilder("<<", firstPageButtonId, ComponentStyle.secondary);
    interactions.events.onButtonEvent.where((event) => event.interaction.customId == firstPageButtonId).listen((event) async {
      await event.acknowledge();

      onFirstPageButtonClicked();
      updatePage(currentPage, this.builder, event);
    });

    final previousPageButtonId = "${customPreId}previousPage";
    final previousPageButton = ButtonBuilder("<", previousPageButtonId, ComponentStyle.secondary);
    interactions.events.onButtonEvent.where((event) => event.interaction.customId == previousPageButtonId).listen((event) async {
      await event.acknowledge();

      onPreviousPageButtonClicked();
      updatePage(currentPage, this.builder, event);
    });

    final nextPageButtonId = "${customPreId}nextPage";
    final nextPageButton = ButtonBuilder(">", nextPageButtonId, ComponentStyle.secondary);
    interactions.events.onButtonEvent.where((event) => event.interaction.customId == nextPageButtonId).listen((event) async {
      await event.acknowledge();

      onNextPageButtonClicked();
      updatePage(currentPage, this.builder, event);
    });

    final lastPageButtonId = "${customPreId}lastPage";
    final lastPageButton = ButtonBuilder(">>", lastPageButtonId, ComponentStyle.secondary);
    interactions.events.onButtonEvent.where((event) => event.interaction.customId == lastPageButtonId).listen((event) async {
      await event.acknowledge();

      onLastPageButtonClicked();
      updatePage(currentPage, this.builder, event);
    });

    final builder = ComponentMessageBuilder()
      ..componentRows = [
        [
          firstPageButton,
          previousPageButton,
          nextPageButton,
          lastPageButton,
        ]
      ];

    this.builder = initHook(builder);

    return getMessageBuilderForPage(1, this.builder);
  }

  /// Called after initializing basic components.
  ComponentMessageBuilder initHook(ComponentMessageBuilder builder) => builder;

  /// Invoked on first page button click
  @override
  void onFirstPageButtonClicked() => currentPage = 1;

  /// Invoked when previous page button is clicked.
  @override
  void onPreviousPageButtonClicked() => currentPage = (currentPage - 1).clamp(1, maxPage);

  /// Invoked when next page button is clicked.
  @override
  void onNextPageButtonClicked() => currentPage = (currentPage + 1).clamp(1, maxPage);

  /// Invoked when last page button is clicked.
  @override
  void onLastPageButtonClicked() => currentPage = maxPage;
}

/// Base class for custom interaction paginator.
/// [getMessageBuilderForPage] needs to be implemented in order to work.
abstract class ComponentPaginationBase extends ComponentPaginationAbstract {
  /// Creates instance of [ComponentPaginationBase]
  ComponentPaginationBase(IInteractions interactions) : super(interactions);

  @override
  FutureOr<void> updatePage(int page, ComponentMessageBuilder currentBuilder, IButtonInteractionEvent target) {
    target.respond(getMessageBuilderForPage(page, currentBuilder));
  }
}

/// Paginator where each page is embed
class EmbedComponentPagination extends ComponentPaginationBase {
  @override
  int get maxPage => embeds.length;

  /// List of embeds to paginate with
  final List<EmbedBuilder> embeds;

  /// Creates instance of [EmbedComponentPagination]
  EmbedComponentPagination(IInteractions interactions, this.embeds) : super(interactions);

  @override
  ComponentMessageBuilder getMessageBuilderForPage(int page, ComponentMessageBuilder currentBuilder) => currentBuilder..embeds = [embeds[page - 1]];
}

/// Paginator where each page is message content
class SimpleComponentPagination extends ComponentPaginationBase {
  @override
  int get maxPage => contentPages.length;

  /// List of string to paginate with
  final List<String> contentPages;

  /// Creates instance of [SimpleComponentPagination]
  SimpleComponentPagination(IInteractions interactions, this.contentPages) : super(interactions);

  @override
  ComponentMessageBuilder getMessageBuilderForPage(int page, ComponentMessageBuilder currentBuilder) => currentBuilder..content = contentPages[page - 1];
}
