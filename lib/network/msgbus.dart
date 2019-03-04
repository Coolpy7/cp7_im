import 'package:event_bus/event_bus.dart';
import 'package:mqtt_client/mqtt_client.dart';

final EventBus eventBus = new EventBus();

class MsgEvent {
  MqttReceivedMessage<MqttMessage> msg;
  MsgEvent(this.msg);
}

class ChatListEvent {
  Map item;
  ChatListEvent(this.item);
}