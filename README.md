# nyxx_pagination

Pagination addon for [nyxx][nyxx]. Allows sending paginated and interactive content 
via message using discord interactions. Also contains legacy paginator based on emojis.  

## Usage

Package includes pre-made classes ready to use and also has interfaces to implement everything 
by yourself. 

Example using embed as pagination pages:
```dart
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
```

## Features and bugs

Please file feature requests and bugs at the [issue tracker][tracker].

[tracker]: https://github.com/nyxx-discord/nyxx_pagination/issues
[nyxx]: https://github.com/nyxx-discord/nyxx_pagination/issues
