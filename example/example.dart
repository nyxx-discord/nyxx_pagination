import "dart:async";

import "package:nyxx/nyxx.dart";
import "package:nyxx_interactions/interactions.dart";
import "package:nyxx_pagination/nyxx_pagination.dart";

FutureOr<void> paginationExampleInteraction(InteractionEvent event) {
  final paginator = EmbedComponentPagination(event.interactions, [
    EmbedBuilder()..description = "This is first page",
    EmbedBuilder()..description = "This is second page",
  ]);

  event.respond(paginator.initMessageBuilder());
}

void main() {
  final bot = Nyxx("<TOKEN>", GatewayIntents.allUnprivileged);

  final interaction = Interactions(bot)
    ..registerSlashCommand(SlashCommandBuilder("paginated", "This is pagination example", [], guild: 302360552993456135.toSnowflake())
      ..registerHandler(paginationExampleInteraction))
    ..syncOnReady();
}
