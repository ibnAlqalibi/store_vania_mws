import 'package:store/app/models/todo.dart';
import 'package:vania/vania.dart';
// ignore: implementation_imports
import 'package:vania/src/exception/validation_exception.dart';

class TodosController extends Controller {
  Future<Response> index() async {
    try {
      Map? user = Auth().user();
      final userId = user!['id'];
      final orderData = await Todo().query().where("userId", "=", userId).get();
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
      Map? user = Auth().user();
      final userId = user!['id'];
      req.validate({
        'id': 'required|string',
        'todo': 'required|string',
        'status': 'required|string|max_length:10',
      });

      final todo = req.input("todo");
      final status = req.input("status");

      await Todo().query().insert({
        "userId": userId,
        "id": req.input("id"),
        "todo": todo,
        "status": status,
        "created_at": DateTime.now().toIso8601String(),
      });

      return Response.json({
        "success": true,
        "message": "Berhasil memasukkan data",
        "data": todo,
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
        'todo': 'string',
      });

      final requestData = req.input();
      final todo = await Todo().query().where('id', '=', id).first();
      if (todo == null) {
        return Response.json({
          "success": false,
          "message": "Order tidak ditemukan",
          "data": null,
        }, 404);
      }
      await Todo().query().where('id', '=', id).update(requestData);
      final updatedData = await Todo().query().get();

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
      await Todo().query().where('id', '=', id).delete();
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

final TodosController todosController = TodosController();
