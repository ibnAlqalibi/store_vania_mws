import 'package:store/app/models/product.dart';
import 'package:vania/vania.dart';
// ignore: implementation_imports
import 'package:vania/src/exception/validation_exception.dart';

class ProductController extends Controller {
  Future<Response> index() async {
    try {
      final productData = await Product().query().get();
      return Response.json({
        "success": true,
        "message": "Berhasil menampilkan data",
        "data": productData,
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
        'prod_id': 'required|string|max_length:10',
        'vend_id': 'required|string|max_length:5',
        'prod_name': 'required|string|max_length:25',
        'prod_price': 'required|numeric|max_length:11',
        'prod_desc': 'required|string',
      });

      final requestData = req.input();
      final existingProduct = await Product()
          .query()
          .where('vend_id', '=', requestData['vend_id'])
          .first();

      if (existingProduct != null) {
        return Response.json({
          'message': 'Product dengan id ini sudah ada.',
          'success': false,
          'data': null
        }, 409);
      }
      await Product().query().insert(requestData);

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
        'vend_id': 'string|max_length:5',
        'prod_name': 'string|max_length:25',
        'prod_price': 'numeric|max_length:11',
        'prod_desc': 'string',
      });

      final requestData = req.input();
      final product = await Product().query().where('prod_id', '=', id).first();
      if (product == null) {
        return Response.json({
          "success": false,
          "message": "Product tidak ditemukan",
          "data": null,
        }, 404);
      }
      await Product().query().where('prod_id', '=', id).update(requestData);
      final updatedData = await Product().query().get();

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
      await Product().query().where('prod_id', '=', id).delete();
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

final ProductController productController = ProductController();
