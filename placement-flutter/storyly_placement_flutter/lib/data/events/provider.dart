import '../util.dart';
import '../product.dart';
import 'payloads.dart';

class PlacementLoadEvent extends BaseEvent {
  final String dataSource;
  final STRDataPayload data;

  PlacementLoadEvent({required this.dataSource, required this.data});

  factory PlacementLoadEvent.fromJson(Map<String, dynamic> json) {
    return PlacementLoadEvent(
      dataSource: json['dataSource'],
      data: STRDataPayload.fromJson(json['data']),
    );
  }

  Map<String, dynamic> toJson() {
    return {'dataSource': dataSource, 'data': data.toJson()};
  }
}

class PlacementLoadFailEvent extends BaseEvent {
  final String errorMessage;

  PlacementLoadFailEvent({required this.errorMessage});

  factory PlacementLoadFailEvent.fromJson(Map<String, dynamic> json) {
    return PlacementLoadFailEvent(errorMessage: json['errorMessage']);
  }

  Map<String, dynamic> toJson() {
    return {'errorMessage': errorMessage};
  }
}

class PlacementHydrationEvent extends BaseEvent {
  final List<STRProductInformation> products;

  PlacementHydrationEvent({required this.products});

  factory PlacementHydrationEvent.fromJson(Map<String, dynamic> json) {
    return PlacementHydrationEvent(
      products: (json['products'] as List<dynamic>)
          .map((e) => STRProductInformation.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {'products': products.map((e) => e.toJson()).toList()};
  }
}
