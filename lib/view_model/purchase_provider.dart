import 'package:perfumes_app/model/purchased_model.dart';

class PurchasedItemsProvider {
  static final PurchasedItemsProvider _instance =
      PurchasedItemsProvider._internal();

  factory PurchasedItemsProvider() {
    return _instance;
  }

  PurchasedItemsProvider._internal();

  final List<PurchasedItem> _purchasedItems = [];

  void addPurchasedItem(PurchasedItem item) {
    _purchasedItems.add(item);
  }

  List<PurchasedItem> getPurchasedItems() {
    return List.unmodifiable(_purchasedItems);
  }
}
