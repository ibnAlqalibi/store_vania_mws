import 'package:store/app/models/order_items.dart';
import 'package:vania/vania.dart';
// ignore: implementation_imports
import 'package:vania/src/exception/validation_exception.dart';

class OrderItemController extends Controller {
  Future<Response> index() async {
    try {
      final orderItemsData = await OrderItems().query().get();
      return Response.json({
        "success": true,
        "message": "Berhasil menampilkan data",
        "data": orderItemsData,
      }, 200);
    } catch (e) {
      return Response.json({
        "success": false,
        "message": e.toString(),
        "data": null,
      }, 500);
    }
  }

//buat validasi
  Future<Response> store(Request req) async {
    try {
      req.validate({
        'order_item': 'required|numeric|max_length:11',
        'order_num': 'required|numeric|max_length:11',
        'prod_id': 'required|string|max_length:10',
        'quantity': 'required|numeric|max_length:11',
        'size': 'required|numeric|max_length:11',
      });

      final requestData = req.input();
      final existingProduct = await OrderItems()
          .query()
          .where('order_item', '=', requestData['order_item'])
          .first();

      if (existingProduct != null) {
        return Response.json({
          'message': 'Item order dengan id ini sudah ada.',
          'success': false,
          'data': null
        }, 409);
      }
      await OrderItems().query().insert(requestData);

      return Response.json({
        "success": true,
        "message": "Berhasil memasukkan data",
        "data": requestData,
      }, 201);
    } catch (e) {
      if (e is ValidationException) {
        final errorMessages = e.message;
        return Response.json({
          "success": false,
          "message": errorMessages,
          "data": null,
        }, 400);
      } else {
        return Response.json({
          "success": false,
          "message": e.toString(),
          "data": null,
        }, 500);
      }
    }
  }

  Future<Response> update(Request req, int id) async {
    try {
      req.validate({
        'order_num': 'numeric|max_length:11',
        'prod_id': 'string|max_length:10',
        'quantity': 'numeric|max_length:11',
        'size': 'numeric|max_length:11',
      });

      final requestData = req.input();
      final orderItems =
          await OrderItems().query().where('order_item', '=', id).first();
      if (orderItems == null) {
        return Response.json({
          "success": false,
          "message": "Item order tidak ditemukan",
          "data": null,
        }, 404);
      }
      await OrderItems()
          .query()
          .where('order_item', '=', id)
          .update(requestData);
      final updatedData = await OrderItems().query().get();

      return Response.json({
        "success": true,
        "message": "Berhasil mengupdate data",
        "data": updatedData,
      }, 200);
    } catch (e) {
      if (e is ValidationException) {
        final errorMessages = e.message;
        return Response.json({
          "success": false,
          "message": errorMessages,
          "data": null,
        }, 400);
      } else {
        return Response.json({
          "success": false,
          "message": e.toString(),
          "data": null,
        }, 500);
      }
    }
  }

  Future<Response> destroy(int id) async {
    try {
      await OrderItems().query().where('order_item', '=', id).delete();
      return Response.json({
        "success": true,
        "message": "Berhasil menghapus data",
        "data": null,
      }, 200);
    } catch (e) {
      return Response.json({
        "success": false,
        "message": e.toString(),
        "data": null,
      }, 500);
    }
  }
}

final OrderItemController orderItemController = OrderItemController();
