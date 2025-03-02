// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:io';
import 'package:african_countries/utils/enum.dart';
import 'package:african_countries/utils/network_request_helper/request_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class AppNetworkRequest {
  static late Dio _dioClient;

  AppNetworkRequest();

  static void init({bool useToken = false}) {
    _dioClient = Dio();
    _dioClient.options.headers = {"Content-Type": "application/json"};
    _dioClient.options.headers = {"Accept": "application/json"};
  }

  static Future<AppHttpResponse> makeRequest(
    String url, {
    HttpRequestType requestType = HttpRequestType.get,
    Map<String, dynamic>? payload,
    String? customBaseUrl,
    String? message,
  }) async {
    // _dioClient.options.baseUrl = customBaseUrl ?? _baseUrl;

    AppHttpResponse response;
    
    try {
      switch (requestType) {
        case HttpRequestType.get:
          response = await _getRequest(url, payload);

        case HttpRequestType.post:
        case HttpRequestType.put:
        case HttpRequestType.patch:
          response =
              await _postRequest(url, payload ?? {}, requestType: requestType);
        default:
          response = await _getRequest(url);
      }
      return response;
    } catch (e) {
      debugPrint(e.toString());
    }
    return ErrorResponse(
        result: {}, message: "error communicating with backend");
  }

  static Future<AppHttpResponse> _getRequest(String url,
      [Map<String, dynamic>? data]) async {
    try {
      final response = await _dioClient.get(url, data: data);
      return SuccessResponse(
          result: response.data,
          message: response.statusMessage ?? "Request successful");
    } on DioException catch (e) {
      return ErrorResponse(
          message: e.response?.statusMessage ?? "Failed to process request");
    } on SocketException catch (e) {
      return ErrorResponse(result: {}, message: e.message);
    } catch (e) {
      return ErrorResponse(result: {}, message: "Failed to process request");
    }
  }

  static Future<AppHttpResponse> _postRequest(
      String url, Map<String, dynamic> data,
      {HttpRequestType requestType = HttpRequestType.post}) async {
    try {
      final response = requestType == HttpRequestType.post
          ? await _dioClient.post(url, data: data)
          : requestType == HttpRequestType.put
              ? await _dioClient.put(url, data: data)
              : await _dioClient.patch(url, data: data);

      Map<String, dynamic>? rawJson;
      if (response.data.runtimeType == String) {
        rawJson = jsonDecode(response.data);
      }

      if (rawJson == null) {
        if (response.data["status"] == false) {
          return ErrorResponse(result: {}, message: response.data["message"]);
        }
      }
      return SuccessResponse(
          result: rawJson ??
              (response.data["data"].runtimeType == List
                  ? {}
                  : response.data["data"] ?? response.data),
          message: rawJson != null
              ? "Request successful"
              : response.data["message"] ?? "Request successful");
    } on DioException catch (e) {
      if (e.response!.statusCode == 401) {
        return ErrorResponse(
          message: e.response?.data["message"] ?? "Failed to process request",
        );
      }

      return ErrorResponse(
        message: e.response?.data["message"] ?? "Failed to process request",
      );
    } on SocketException catch (e) {
      return ErrorResponse(message: e.message);
    } catch (e) {
      return ErrorResponse.defaultError();
    }
  }
}
