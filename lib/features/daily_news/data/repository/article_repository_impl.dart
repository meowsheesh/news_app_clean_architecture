import 'dart:io';

import 'package:dio/dio.dart';
import '../../../../core/constants/constants.dart';
import '../../../../core/resources/data_state.dart';
import '../../domain/repository/article_repository.dart';
import '../data_sourses/remote/news_api_service.dart';
import '../models/article.dart';

class ArticleRepositoryImpl implements ArticleRepository {
  final NewsApiService _newsApiService;
  ArticleRepositoryImpl(this._newsApiService);

  @override
  Future<DataState<List<ArticleModel>>> getNewsArticles() async {
    try {
      final httpResponse = await _newsApiService.getNewsArticles(
        apiKey: newsAPIKey,
        country: countryQuery,
        category: categoryQuery,
      );

      if (httpResponse.response.statusCode == HttpStatus.ok) {
        //print(httpResponse.data);
        return DataSuccess(httpResponse.data);
      } else {
        return DataFailed(DioError(
          error: httpResponse.response.statusMessage,
          response: httpResponse.response,
          type: DioErrorType.response,
          requestOptions: httpResponse.response.requestOptions,
        ));
      }
    } on DioError catch (e) {
      print(e);
      return DataFailed(e);
    }
  }
}
