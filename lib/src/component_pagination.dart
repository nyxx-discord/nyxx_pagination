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

  final String firstLabel;
  final String prevLabel;
  final String nextLabel;
  final String lastLabel;

  final IEmoji? firstEmoji;
  final IEmoji? prevEmoji;
  final IEmoji? nextEmoji;
  final IEmoji? lastEmoji;

  /// A timeout after which pagination will be disabled for this message.
  ///
  /// Set to `null` to enable pagination forever (or until bot restart).
  final Duration? timeout;

  /// Current page that paginator is on
  @override
  int currentPage = 1;

  /// Message builder used to create paginated messages
  late ComponentMessageBuilder builder;

  IMessage? message;

  /// Creates new paginator using interactions
  ///
  /// The `*Label` and `*Emoji` parameters control the emojis and labels used for the pagination buttons.
  ComponentPaginationAbstract(
    this.interactions, {
    this.firstLabel = '<<',
    this.prevLabel = '<',
    this.nextLabel = '>',
    this.lastLabel = '>>',
    this.firstEmoji,
    this.prevEmoji,
    this.nextEmoji,
    this.lastEmoji,
    this.timeout,
  }) {
    customPreId = randomAlpha(10);
  }

  /// Inits [ComponentMessageBuilder] with buttons needed for pagination. And hooks needed events.
  @override
  ComponentMessageBuilder initMessageBuilder() {
    final firstPageButtonId = "${customPreId}firstPage";
    final firstPageButton = ButtonBuilder(firstLabel, firstPageButtonId, ComponentStyle.secondary, emoji: firstEmoji);
    interactions.events.onButtonEvent.where((event) => event.interaction.customId == firstPageButtonId).listen((event) async {
      await event.acknowledge();

      onFirstPageButtonClicked();
      updatePage(currentPage, this.builder, event);
    });

    final previousPageButtonId = "${customPreId}previousPage";
    final previousPageButton = ButtonBuilder(prevLabel, previousPageButtonId, ComponentStyle.secondary, emoji: prevEmoji);
    interactions.events.onButtonEvent.where((event) => event.interaction.customId == previousPageButtonId).listen((event) async {
      await event.acknowledge();

      onPreviousPageButtonClicked();
      updatePage(currentPage, this.builder, event);
    });

    final nextPageButtonId = "${customPreId}nextPage";
    final nextPageButton = ButtonBuilder(nextLabel, nextPageButtonId, ComponentStyle.secondary, emoji: nextEmoji);
    interactions.events.onButtonEvent.where((event) => event.interaction.customId == nextPageButtonId).listen((event) async {
      await event.acknowledge();

      onNextPageButtonClicked();
      updatePage(currentPage, this.builder, event);
    });

    final lastPageButtonId = "${customPreId}lastPage";
    final lastPageButton = ButtonBuilder(lastLabel, lastPageButtonId, ComponentStyle.secondary, emoji: lastEmoji);
    interactions.events.onButtonEvent.where((event) => event.interaction.customId == lastPageButtonId).listen((event) async {
      await event.acknowledge();
    final lastPageButton = ButtonBuilder(lastLabel, lastPageButtonId, ComponentStyle.secondary, emoji: lastEmoji);

    void updateButtonState() {
      firstPageButton.disabled = currentPage == 1;
      previousPageButton.disabled = currentPage == 1;
      nextPageButton.disabled = currentPage == maxPage;
      lastPageButton.disabled = currentPage == maxPage;
    }

    // TODO: use ButtonInteractionEvent, currently it is not exported from nyxx_interactions
    StreamSubscription<dynamic> subscription = interactions.events.onButtonEvent.listen((event) async {
      if ([firstPageButtonId, previousPageButtonId, nextPageButtonId, lastPageButtonId].contains(event.interaction.customId)) {
        await event.acknowledge();

        message = event.interaction.message;

        if (event.interaction.customId == firstPageButtonId) {
          onFirstPageButtonClicked();
        } else if (event.interaction.customId == previousPageButtonId) {
          onPreviousPageButtonClicked();
        } else if (event.interaction.customId == nextPageButtonId) {
          onNextPageButtonClicked();
        } else if (event.interaction.customId == lastPageButtonId) {
          onLastPageButtonClicked();
        }

        updateButtonState();
        updatePage(currentPage, this.builder, event);
      }
    });

    if (timeout != null) {
      Future.delayed(timeout!, () {
        subscription.cancel();

        firstPageButton.disabled = true;
        previousPageButton.disabled = true;
        nextPageButton.disabled = true;
        lastPageButton.disabled = true;

        message?.edit(this.builder);
      });
    }

    updateButtonState();

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
  ///
  /// The `*Label` and `*Emoji` parameters control the emojis and labels used for the pagination buttons.
  ComponentPaginationBase(
    IInteractions interactions, {
    String firstLabel = '<<',
    String prevLabel = '<',
    String nextLabel = '>',
    String lastLabel = '>>',
    IEmoji? firstEmoji,
    IEmoji? prevEmoji,
    IEmoji? nextEmoji,
    IEmoji? lastEmoji,
    Duration? timeout,
  }) : super(
          interactions,
          firstLabel: firstLabel,
          prevLabel: prevLabel,
          nextLabel: nextLabel,
          lastLabel: lastLabel,
          firstEmoji: firstEmoji,
          prevEmoji: prevEmoji,
          nextEmoji: nextEmoji,
          lastEmoji: lastEmoji,
          timeout: timeout,
        );

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
  ///
  /// The `*Label` and `*Emoji` parameters control the emojis and labels used for the pagination buttons.
  EmbedComponentPagination(
    IInteractions interactions,
    this.embeds, {
    String firstLabel = '<<',
    String prevLabel = '<',
    String nextLabel = '>',
    String lastLabel = '>>',
    IEmoji? firstEmoji,
    IEmoji? prevEmoji,
    IEmoji? nextEmoji,
    IEmoji? lastEmoji,
    Duration? timeout,
  }) : super(
          interactions,
          firstLabel: firstLabel,
          prevLabel: prevLabel,
          nextLabel: nextLabel,
          lastLabel: lastLabel,
          firstEmoji: firstEmoji,
          prevEmoji: prevEmoji,
          nextEmoji: nextEmoji,
          lastEmoji: lastEmoji,
          timeout: timeout,
        );

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
  ///
  /// The `*Label` and `*Emoji` parameters control the emojis and labels used for the pagination buttons.
  SimpleComponentPagination(
    IInteractions interactions,
    this.contentPages, {
    String firstLabel = '<<',
    String prevLabel = '<',
    String nextLabel = '>',
    String lastLabel = '>>',
    IEmoji? firstEmoji,
    IEmoji? prevEmoji,
    IEmoji? nextEmoji,
    IEmoji? lastEmoji,
    Duration? timeout,
  }) : super(
          interactions,
          firstLabel: firstLabel,
          prevLabel: prevLabel,
          nextLabel: nextLabel,
          lastLabel: lastLabel,
          firstEmoji: firstEmoji,
          prevEmoji: prevEmoji,
          nextEmoji: nextEmoji,
          lastEmoji: lastEmoji,
          timeout: timeout,
        );

  @override
  ComponentMessageBuilder getMessageBuilderForPage(int page, ComponentMessageBuilder currentBuilder) => currentBuilder..content = contentPages[page - 1];
}
