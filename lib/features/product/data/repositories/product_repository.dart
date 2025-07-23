import 'package:wts_task/core/entities/api_response.dart';
import 'package:wts_task/core/services/api/api_response_parser.dart';
import 'package:wts_task/core/services/api/dio_network_service.dart';
import 'package:wts_task/features/product/data/models/product_model.dart';

class ProductRepository extends DioNetworkService {
  ProductRepository();

  Future<ApiResponse<List<ProductModel>>> getProductList({
    String? categoryId,
    String? text,
  }) async {
    final response = await get(
      '/shop/product/list',
      queryParameters: {
        "accessToken": "CaIqP7H-gEhJJD4_gu4imh-_ZpV_wFeh",
        if (categoryId != '0') "categoryId": categoryId,
        "text": text,
      },
    );
    print(response.rawData);
    print(response.dataJson);
    return ApiResponseParser.parseListFromResponse(
      response,
      fromJson: ProductModel.fromJson,
      emptyError: 'Объекты не найден',
      key: 'products',
    );
  }
}
