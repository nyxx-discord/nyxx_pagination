import "dart:async";

import "package:nyxx/nyxx.dart";
import "package:nyxx_interactions/interactions.dart";
import "package:nyxx_pagination/nyxx_pagination.dart";

class MyCustomPagination extends ComponentPagination {
  @override
  // TODO: implement maxPage
   int get maxPage => this.pages.length;

  late final List<String> pages;

  MyCustomPagination(Nyxx client, Interactions interactions) : super(client, interactions) {
    this.pages = [
      "this is first page",
      "this is second page",
    ];
  }

  @override
  FutureOr<void> updatePage() {
    this.messageBuilder.content = this.pages[this.currentPage];

    super.updatePage();
  }
}

FutureOr<void> paginationExampleInteraction(InteractionEvent event) {
  // final pagination = MyCustomPagination(Nyxx("", 0), event.interaction);
}

void main() {
  final bot = Nyxx("<TOKEN>", GatewayIntents.allUnprivileged);

  final interaction = Interactions(bot)
    ..registerSlashCommand(SlashCommandBuilder("paginate", "This is pagination example", [])
      ..registerHandler(paginationExampleInteraction));
}
