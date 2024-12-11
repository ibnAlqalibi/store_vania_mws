import 'package:store/app/models/product_note.dart';
import 'package:vania/vania.dart';
// ignore: implementation_imports
import 'package:vania/src/exception/validation_exception.dart';

class ProductNoteController extends Controller {
  Future<Response> index() async {
    try {
      final productNoteData = await ProductNote().query().get();
      return Response.json({
        "success": true,
        "message": "Berhasil menampilkan data",
        "data": productNoteData,
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
        'note_id': 'required|string|max_length:5',
        'prod_id': 'required|string|max_length:10',
        'note_date': 'required|date',
        'note_text': 'required|string',
      });

      final requestData = req.input();
      final existingProduct = await ProductNote()
          .query()
          .where('note_id', '=', requestData['note_id'])
          .first();

      if (existingProduct != null) {
        return Response.json({
          'message': 'Catatan product dengan id ini sudah ada.',
          'success': false,
          'data': null
        }, 409);
      }
      await ProductNote().query().insert(requestData);

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
        'prod_id': 'string|max_length:10',
        'note_date': 'date',
        'note_text': 'string',
      });

      final requestData = req.input();
      final productNote =
          await ProductNote().query().where('note_id', '=', id).first();
      if (productNote == null) {
        return Response.json({
          "success": false,
          "message": "Product tidak ditemukan",
          "data": null,
        }, 404);
      }
      await ProductNote().query().where('note_id', '=', id).update(requestData);
      final updatedData = await ProductNote().query().get();

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
      await ProductNote().query().where('note_id', '=', id).delete();
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

final ProductNoteController productNoteController = ProductNoteController();
