import "dart:async";

import "package:nyxx/nyxx.dart";
import 'package:nyxx_interactions/nyxx_interactions.dart';
import "package:nyxx_pagination/nyxx_pagination.dart";

FutureOr<void> paginationExampleInteraction(ISlashCommandInteractionEvent event) {
  final paginator = EmbedComponentPagination(event.interactions, [
    EmbedBuilder()..description = "This is first page",
    EmbedBuilder()..description = "This is second page",
  ]);

  event.respond(paginator.initMessageBuilder());
}

void main() {
  final bot = NyxxFactory.createNyxxWebsocket("<TOKEN>", GatewayIntents.allUnprivileged);

  IInteractions.create(WebsocketInteractionBackend(bot))
    ..registerSlashCommand(SlashCommandBuilder("paginated", "This is pagination example", [], guild: 302360552993456135.toSnowflake())
      ..registerHandler(paginationExampleInteraction))
    ..syncOnReady();
}
