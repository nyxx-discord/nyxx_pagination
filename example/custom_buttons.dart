import "dart:async";

import "package:nyxx/nyxx.dart";
import "package:nyxx_interactions/nyxx_interactions.dart";
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

  @override
  ComponentMessageBuilder initHook(ComponentMessageBuilder builder) {
    final customButtonId = "${customPreId}customButton";
    final customButton = ButtonBuilder("This is custom button", customButtonId, ComponentStyle.success);
    interactions.events.onButtonEvent.where((event) => event.interaction.customId == customButtonId).listen((event) async {
      await event.acknowledge();
      await event.respond(MessageBuilder.content("This is custom stuff"));
    });

    builder.componentRows?.add([
      customButton,
    ]);

    return builder;
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
