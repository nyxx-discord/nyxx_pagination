/// Pagination module for nyxx. Allows creating paginated and interactive content
/// in message. Uses nyxx_interactions to handle pagination in message.
library nyxx_pagination;

import "dart:async";

import "package:nyxx/nyxx.dart";
import "package:nyxx_interactions/interactions.dart";
import "package:random_string/random_string.dart";

part "src/IPagination.dart";
part "src/ComponentPagination.dart";
