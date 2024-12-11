import 'package:store/app/models/order.dart';
import 'package:vania/vania.dart';
// ignore: implementation_imports
import 'package:vania/src/exception/validation_exception.dart';

class OrdersController extends Controller {
  Future<Response> index() async {
    try {
      final orderData = await Order().query().get();
      return Response.json({
        "success": true,
        "message": "Berhasil menampilkan data",
        "data": orderData,
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
        'order_num': 'required|numeric|max_length:11',
        'order_date': 'required|date',
        'cust_id': 'required|string|max_length:5',
      });

      final requestData = req.input();
      final existingProduct = await Order()
          .query()
          .where('order_num', '=', requestData['order_num'])
          .first();

      if (existingProduct != null) {
        return Response.json({
          'message': 'Order dengan nomor ini sudah ada.',
          'success': false,
          'data': null
        }, 409);
      }
      await Order().query().insert(requestData);

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
        'order_date': 'date',
        'cust_id': 'string|max_length:5',
      });

      final requestData = req.input();
      final order = await Order().query().where('order_num', '=', id).first();
      if (order == null) {
        return Response.json({
          "success": false,
          "message": "Order tidak ditemukan",
          "data": null,
        }, 404);
      }
      await Order().query().where('order_num', '=', id).update(requestData);
      final updatedData = await Order().query().get();

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
      await Order().query().where('order_num', '=', id).delete();
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

final OrdersController ordersController = OrdersController();
