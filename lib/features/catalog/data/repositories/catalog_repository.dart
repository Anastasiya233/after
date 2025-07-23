import 'package:wts_task/core/entities/api_response.dart';
import 'package:wts_task/core/services/api/api_response_parser.dart';
import 'package:wts_task/core/services/api/dio_network_service.dart';
import 'package:wts_task/features/catalog/data/model/catalog_model.dart';

class CatalogRepository extends DioNetworkService {
  CatalogRepository();

  Future<ApiResponse<List<CatalogResponse>>> getCatalogList(
    String? categoryId,
  ) async {
    final response = await get(
      '/category/list',
      queryParameters: {
        "accessToken": "CaIqP7H-gEhJJD4_gu4imh-_ZpV_wFeh",
        "parentId": categoryId,
      },
    );
    print(response.rawData);
    print(response.dataJson);
    return ApiResponseParser.parseListFromResponse(
      response,
      fromJson: CatalogResponse.fromJson,
      emptyError: 'Объекты не найден',
      key: 'categories',
    );
  }
}
