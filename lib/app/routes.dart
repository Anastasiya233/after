import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'package:wts_task/app/bottom_nav_bar.dart';
import 'package:wts_task/core/models/app_user.dart';
import 'package:wts_task/features/auth/data/datasource/auth_local_data_source.dart';
import 'package:wts_task/features/auth/presentation/view/otp_screen.dart';
import 'package:wts_task/features/auth/presentation/view/phone_auth_screen.dart';
import 'package:wts_task/features/cart/presentation/view/screens/cart_screen.dart';
import 'package:wts_task/features/cart/presentation/view/screens/checkout_screen.dart';
import 'package:wts_task/features/product/presentation/view/add_review_screen.dart';
import 'package:wts_task/features/catalog/presentation/view/catalog_screen.dart';
import 'package:wts_task/features/product/presentation/view/product_list_screen.dart';
import 'package:wts_task/features/catalog/presentation/view/sub_catalog_screen.dart';
import 'package:wts_task/features/product/presentation/view/product_reviews_screen.dart';
import 'package:wts_task/features/chat/presentation/view/support_chat_screen.dart';
import 'package:wts_task/features/profile/presentation/view/screens/edit_profile_screen.dart';
import 'package:wts_task/features/profile/presentation/view/screens/order_detail_screen.dart';
import 'package:wts_task/features/profile/presentation/view/screens/order_history_screen.dart';
import 'package:wts_task/features/profile/presentation/view/screens/profile_screen.dart';

extension GoRouterExtension on BuildContext {
  Future<void> clearStackAndNavigate(String location) async {
    while (GoRouter.of(this).canPop()) {
      GoRouter.of(this).pop();
    }
    GoRouter.of(this).go(location);
  }
}

// Ключи
final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();
final GlobalKey<NavigatorState> _catalogBranchKey = GlobalKey<NavigatorState>();
final GlobalKey<NavigatorState> _cartBranchKey = GlobalKey<NavigatorState>();
final GlobalKey<NavigatorState> _profileBranchKey = GlobalKey<NavigatorState>();

class AppRouter {
  AppRouter(this.appUser);

  final AppUser appUser;

  late final GoRouter appRouter = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/catalog',
    observers: [BotToastNavigatorObserver()],
    routes: [
      // Авторизация
      GoRoute(
        path: '/auth/phone',
        builder: (context, state) => const PhoneAuthScreen(),
      ),
      GoRoute(
        path: '/auth/otp',
        builder: (context, state) {
          final phone = state.extra as String;
          return OtpScreen(phoneNumber: phone);
        },
      ),

      // Основной интерфейс
      StatefulShellRoute.indexedStack(
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state, navigationShell) {
          return AppBottomNavBar(navigationShell: navigationShell);
        },
        branches: [
          // Каталог
          StatefulShellBranch(
            navigatorKey: _catalogBranchKey,
            routes: [
              GoRoute(
                path: '/catalog',
                builder: (context, state) => CatalogScreen(),
                routes: [
                  GoRoute(
                    path: 'category',
                    builder: (context, state) {
                      final categoryId = state.uri.queryParameters['categoryId'];
                      final catalogName = state.uri.queryParameters['catalogName'];

                      if (categoryId == null || catalogName == null) {
                        throw Exception("Missing query parameters");
                      }

                      return SubCatalogScreen(
                        categoryId: categoryId,
                        catalogName: catalogName,
                      );
                    },
                    routes: [
                      GoRoute(
                        path: 'products',
                        builder: (context, state) {
                          final categoryId = state.uri.queryParameters['categoryId'];
                          final catalogName = state.uri.queryParameters['catalogName'];

                          if (categoryId == null || catalogName == null) {
                            throw Exception("Missing query parameters");
                          }

                          return ProductListScreen(
                            categoryId: categoryId,
                            catalogName: catalogName,
                          );
                        },
                        routes: [
                          GoRoute(
                            path: 'reviews',
                            builder: (context, state) => const ProductReviewsScreen(),
                            routes: [
                              GoRoute(
                                path: 'add',
                                builder: (context, state) => const AddReviewScreen(),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),

          // Корзина
          StatefulShellBranch(
            navigatorKey: _cartBranchKey,
            routes: [
              GoRoute(
                path: '/cart',
                builder: (context, state) => const CartScreen(),
                routes: [
                  GoRoute(
                    path: 'checkout',
                    name: 'checkout',
                    builder: (context, state) => const CheckoutScreen(),
                  ),
                ],
              ),
            ],
          ),

          // Профиль
          StatefulShellBranch(
            navigatorKey: _profileBranchKey,
            routes: [
              GoRoute(
                path: '/profile',
                builder: (context, state) => const ProfileScreen(),
                routes: [
                  GoRoute(
                    path: 'edit',
                    builder: (context, state) => const EditProfileScreen(),
                  ),
                  GoRoute(
                    path: 'orders',
                    name: 'orders',
                    builder: (context, state) => const OrderHistoryScreen(),
                    routes: [
                      GoRoute(
                        path: ':id',
                        name: 'order_detail',
                        builder: (context, state) => const OrderDetailScreen(),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ],
      ),

      // Поддержка
      GoRoute(
        path: '/support',
        builder: (context, state) => const SupportChatScreen(),
      ),
    ],
    refreshListenable: appUser,
    redirect: (BuildContext context, GoRouterState state) async {
      final path = state.uri.path;
      final userSource = context.read<AuthLocalDataSource>();

      if (!await userSource.isAuthenticated() && !path.startsWith('/auth')) {
        return '/auth/phone';
      }

      return null;
    },
  );
}
