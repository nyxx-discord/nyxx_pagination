import "dart:async";

import "package:nyxx/nyxx.dart";
import "package:nyxx_interactions/interactions.dart";
import "package:nyxx_pagination/nyxx_pagination.dart";

class MyCustomPagination extends IComponentPagination {
  List<String> get pages => [
    "This is first page",
    "This is second page",
  ];

  @override
  int get maxPage => this.pages.length;

  MyCustomPagination(Interactions interactions): super(interactions);

  @override
  ComponentMessageBuilder getMessageBuilderForPage(int page, ComponentMessageBuilder currentBuilder) =>
      currentBuilder..content = pages[page - 1];

  @override
  FutureOr<void> updatePage(int page, ComponentMessageBuilder currentBuilder, ButtonInteractionEvent target) {
    target.respond(this.getMessageBuilderForPage(page, currentBuilder));
  }
}

FutureOr<void> paginationExampleInteraction(InteractionEvent event) {
  final pagination = MyCustomPagination(event.interactions);

  event.respond(pagination.initMessageBuilder());
}

void main() {
  final bot = Nyxx("<TOKEN>", GatewayIntents.allUnprivileged);

  final interaction = Interactions(bot)
    ..registerSlashCommand(SlashCommandBuilder("paginated", "This is pagination example", [], guild: 302360552993456135.toSnowflake())
      ..registerHandler(paginationExampleInteraction))
    ..syncOnReady();
}
