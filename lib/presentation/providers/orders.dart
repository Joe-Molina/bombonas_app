import 'package:bombonas_app/data/models/orders_response.dart';
import 'package:bombonas_app/data/repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'orders.g.dart';

@Riverpod(keepAlive: true)
class Orders extends _$Orders {
  @override
  Future<List<OrdersResponse>> build() async {
    List<OrdersResponse> orders = await Repository().fetchOrders();
    return orders;
  }

  Future<bool> deleteOrder(int orderId) async {
    // Ensure the current state is a list (and not an error or loading state)
    // before attempting to modify it.
    if (state is AsyncData<List<OrdersResponse>>) {
      final currentOrders = state.value!;

      dynamic delete = await Repository().deleteOrder(orderId);

      if (delete) {
        // Create a new list excluding the order with the given orderId
        final updatedOrders = currentOrders
            .where((order) => order.id != orderId)
            .toList(); // Convert back to a list

        // Update the state with the new list.
        // This will trigger a rebuild of any widgets listening to this provider.
        state = AsyncData(updatedOrders);

        print('halloo');
        return true;
      } else {
        return false;
      }
    } else {
      print('ironman murio');
      return false;
    }
    // You might want to handle cases where state is loading or an error if necessary.
  }

  Future<bool> reloadOrders() async {
    List<OrdersResponse> orders = await Repository().fetchOrders();

    if (orders.isNotEmpty) {
      state = AsyncData(orders);
      return true;
    } else {
      return false;
    }

    // You might want to handle cases where state is loading or an error if necessary.
  }
}
