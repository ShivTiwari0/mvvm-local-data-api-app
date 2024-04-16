import 'dart:convert';
import 'dart:io';

import 'package:geekrabit_project/app_excaptions.dart';
import 'package:geekrabit_project/data/network/base_apiservice.dart';
import 'package:http/http.dart' as http;

class NetworkApiService extends BaseApiServices {
  @override
  Future getGetApiResponse(String url) async {
    dynamic responsejson;
    try {
      var response =
          await http.get(Uri.parse(url)).timeout(const Duration(seconds: 10));

      responsejson = returnResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet Connection');
    } catch (e) {
      print('Error occurred: $e');
      throw e;
    }
    print('responsejson:::::::$responsejson');
    return responsejson;
  }

  dynamic returnResponse(http.Response response) {
    switch (response.statusCode) {
      case 200:
        dynamic responseJson = jsonDecode(response.body);
        return responseJson;
      case 400:
        throw BadRequestException(response.body.toString());
      case 429:
        throw TooManyTaps(response.body.toString());
      case 404:
        throw UnaurthorisedException(response.body.toString());
      default:
        throw FetchDataException(
            "Error with status code ${response.statusCode.toString()}");
    }
  }
}
