import "dart:async";

import "package:nyxx/nyxx.dart";
import 'package:nyxx_interactions/nyxx_interactions.dart';
import "package:nyxx_pagination/nyxx_pagination.dart";

class MyCustomPagination extends ComponentPaginationAbstract {
  List<String> get pages => [
    "This is first page",
    "This is second page",
  ];

  @override
  int get maxPage => pages.length;

  MyCustomPagination(IInteractions interactions): super(interactions);

  @override
  ComponentMessageBuilder getMessageBuilderForPage(int page, ComponentMessageBuilder currentBuilder) =>
      currentBuilder..content = pages[page - 1];

  @override
  FutureOr<void> updatePage(int page, ComponentMessageBuilder currentBuilder, IButtonInteractionEvent target) {
    target.respond(getMessageBuilderForPage(page, currentBuilder));
  }
}

FutureOr<void> paginationExampleInteraction(ISlashCommandInteractionEvent event) {
  final pagination = MyCustomPagination(event.interactions);

  event.respond(pagination.initMessageBuilder());
}

void main() {
  final bot = NyxxFactory.createNyxxWebsocket("<TOKEN>", GatewayIntents.allUnprivileged);

  IInteractions.create(WebsocketInteractionBackend(bot))
    ..registerSlashCommand(SlashCommandBuilder("paginated", "This is pagination example", [], guild: 302360552993456135.toSnowflake())
      ..registerHandler(paginationExampleInteraction))
    ..syncOnReady();
}
