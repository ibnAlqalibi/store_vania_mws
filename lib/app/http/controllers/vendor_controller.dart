import 'package:store/app/models/vendor.dart';
import 'package:vania/vania.dart';
// ignore: implementation_imports
import 'package:vania/src/exception/validation_exception.dart';

class VendorController extends Controller {
  Future<Response> index() async {
    try {
      final vendorData = await Vendor().query().get();
      return Response.json({
        "success": true,
        "message": "Berhasil menampilkan data",
        "data": vendorData,
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
        'vend_id': 'required|string|max_length:5',
        'vend_name': 'required|string|max_length:50',
        'vend_address': 'required|string',
        'vend_kota': 'required|string',
        'vend_state': 'required|string|max_length:5',
        'vend_zip': 'required|string|max_length:7',
        'vend_country': 'required|string|max_length:25',
      });

      final requestData = req.input();
      final existingProduct = await Vendor()
          .query()
          .where('vend_id', '=', requestData['vend_id'])
          .first();

      if (existingProduct != null) {
        return Response.json({
          'message': 'Vendor dengan nomor ini sudah ada.',
          'success': false,
          'data': null
        }, 409);
      }
      await Vendor().query().insert(requestData);

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

  Future<Response> update(Request req, String id) async {
    try {
      req.validate({
        'vend_name': 'string|max_length:50',
        'vend_address': 'string',
        'vend_kota': 'string',
        'vend_state': 'string|max_length:5',
        'vend_zip': 'string|max_length:7',
        'vend_country': 'string|max_length:25',
      });

      final requestData = req.input();
      final vendor = await Vendor().query().where('vend_id', '=', id).first();
      if (vendor == null) {
        return Response.json({
          "success": false,
          "message": "Vendor tidak ditemukan",
          "data": null,
        }, 404);
      }
      await Vendor().query().where('vend_id', '=', id).update(requestData);
      final updatedData = await Vendor().query().get();

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

  Future<Response> destroy(String id) async {
    try {
      await Vendor().query().where('vend_id', '=', id).delete();
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

final VendorController vendorController = VendorController();
