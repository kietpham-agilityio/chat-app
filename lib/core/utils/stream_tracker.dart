import 'dart:async';

import 'package:chat_app/core/utils/failure.dart';
import 'package:chat_app/models/chat_room_model.dart';
import 'package:fpdart/fpdart.dart';

class StreamTracker {
  StreamTracker._();

  static final controller =
      StreamController<Either<Failure, List<ChatRoomModel>>>();

  static dispose() {
    controller.close();
  }
}
