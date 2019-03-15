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

class LocalPushEvent {
  String cid, cname, cdesc;
  int id, delay;
  String title, body, payload;
  LocalPushEvent(this.cid, this.cname, this.cdesc, this.id, this.title, this.body, this.payload, this.delay);
}