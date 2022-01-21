import 'package:event_bus/event_bus.dart';

class EventBusHolder {
  static EventBus _eventBus = EventBus();

  static get get => _eventBus;
}