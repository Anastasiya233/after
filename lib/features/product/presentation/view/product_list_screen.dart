import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:wts_task/core/page/base_grid_view_page_state.dart';
import 'package:wts_task/core/page/base_page.dart';
import 'package:wts_task/features/product/presentation/view_model/product_view_model.dart';

class ProductListScreen extends BasePage {
  final String categoryId;
  const ProductListScreen({
    super.key,
    super.title = 'Каталог',
    required this.categoryId,
  });

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState
    extends BaseGridViewPageState<ProductListScreen, ProductViewModel> {
  static GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  @override
  ProductViewModel createModel() =>
      ProductViewModel(categoryId: widget.categoryId);

  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();

  @override
  bool get shouldBuildEmptyListPlaceholder => false;

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget? buildSliverHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        key: _formKey,
        controller: _searchController,
        focusNode: _searchFocusNode,
        decoration: InputDecoration(
          hintText: 'Поиск товаров',
          prefixIcon: Icon(Icons.search),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
        onChanged: (text) {
          model.setSearchString(text);
        },
      ),
    );
  }

  @override
  Widget buildListItemImpl(BuildContext context, int index) {
    final theme = Theme.of(context);
    final item = model.items[index];

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 0,
      color: theme.colorScheme.surface,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Container(
                width: double.infinity,
                color: theme.colorScheme.surface,
                child: CachedNetworkImage(
                  width: 64,
                  height: 64,
                  imageUrl: item.imageUrl ?? "",
                  progressIndicatorBuilder: (context, url, progress) {
                    return Center(
                      child: SizedBox(
                        width: 64,
                        height: 64,
                        child: CircularProgressIndicator.adaptive(
                          value: progress.progress,
                        ),
                      ),
                    );
                  },
                  errorWidget: (context, url, error) {
                    return Icon(Icons.error, color: theme.colorScheme.error);
                  },
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              item.name ?? "null",
              style: theme.textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.w500,
              ),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.bottomRight,
              child: IconButton(
                icon: Icon(
                  Icons.shopping_basket_outlined,
                  color: theme.iconTheme.color,
                ),
                onPressed: () {
                  // Переход к деталям товара
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
