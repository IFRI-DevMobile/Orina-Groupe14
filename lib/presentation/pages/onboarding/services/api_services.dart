import 'package:dio/dio.dart';

class ApiService {
final Dio _dio = Dio(
BaseOptions(
baseUrl: "https://jsonplaceholder.typicode.com/users",
connectTimeout: Duration(seconds: 10),
receiveTimeout: Duration(seconds: 10),
headers: {
"Content-Type": "application/json",
},
),
);
ApiService() {
_dio.interceptors.add(LogInterceptor(
requestBody: true,
responseBody: true,
));
}
Dio get client => _dio;
}