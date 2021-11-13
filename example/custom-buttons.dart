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

  @override
  ComponentMessageBuilder initHook(ComponentMessageBuilder builder) {
    final customButtonId = "${this.customPreId}customButton";
    final customButton = ButtonBuilder("This is custom button", customButtonId, ComponentStyle.success);
    this.interactions.onButtonEvent.where((event) => event.interaction.customId == customButtonId).listen((event) async {
      await event.acknowledge();
      await event.respond(MessageBuilder.content("This is custom stuff"));
    });

    builder.components?.add([
      customButton,
    ]);

    return builder;
  }
}

FutureOr<void> paginationExampleInteraction(SlashCommandInteractionEvent event) {
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
