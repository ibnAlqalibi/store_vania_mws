import 'package:store/app/models/customer.dart';
import 'package:vania/vania.dart';
// ignore: implementation_imports
import 'package:vania/src/exception/validation_exception.dart';

class CustomerController extends Controller {
  Future<Response> index() async {
    try {
      final custData = await Customer().query().get();
      return Response.json({
        "success": true,
        "message": "Berhasil menampilkan data",
        "data": custData,
      }, 200);
    } catch (e) {
      return Response.json({
        "success": false,
        "message": e.toString(),
        "data": null,
      }, 500);
    }
  }

  Future<Response> create(Request req) async {
    try {
      req.validate({
        'cust_id': 'required|string|max_length:5',
        'cust_name': 'required|string|max_length:100',
        'cust_address': 'required|string|max_length:50',
        'cust_city': 'required|string|max_length:20',
        'cust_state': 'required|string|max_length:5',
        'cust_zip': 'required|string|max_length:7',
        'cust_country': 'required|string|max_length:25',
        'cust_telp': 'required|string|max_length:15',
      });

      final requestData = req.input();
      final existingProduct = await Customer()
          .query()
          .where('cust_id', '=', requestData['cust_id'])
          .first();

      if (existingProduct != null) {
        return Response.json({
          'message': 'Customer dengan id ini sudah ada.',
          'success': false,
          'data': null
        }, 409);
      }
      await Customer().query().insert(requestData);

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
          "message": "Kesalahan pada server",
          "data": null,
        }, 500);
      }
    }
  }

  Future<Response> update(Request request, int id) async {
    return Response.json({});
  }

  Future<Response> destroy(int id) async {
    return Response.json({});
  }
}

final CustomerController customerController = CustomerController();
