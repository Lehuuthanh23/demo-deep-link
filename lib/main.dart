import 'package:flutter/material.dart';
import 'package:app_links/app_links.dart';
import 'package:get/get.dart';
import 'dart:async';

/// Deep Link Demo with GetX
/// Simple URI Scheme implementation without Branch.io

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const DeepLinkApp());
}

class DeepLinkApp extends StatelessWidget {
  const DeepLinkApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'GetX Deep Link Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      initialRoute: '/',
      getPages: [
        GetPage(name: '/', page: () => HomePage(), binding: HomeBinding()),
        GetPage(name: '/product/:id', page: () => ProductPage()),
        GetPage(name: '/promotion/:code', page: () => PromotionPage()),
      ],
      unknownRoute: GetPage(
        name: '/notfound',
        page: () => const NotFoundPage(),
      ),
      enableLog: false,
    );
  }
}

// ============================================================================
// CONTROLLER
// ============================================================================

class HomeController extends GetxController {
  final _appLinks = AppLinks();

  // Static to share across all instances
  static StreamSubscription<Uri>? _linkSubscription;
  static bool _hasProcessedInitialLink = false;
  static Timer? _navigationTimer;

  // Observable state
  var latestLink = 'No deep link yet'.obs;
  var linkHistory = <String>[].obs;

  @override
  void onInit() {
    super.onInit();
    _initDeepLinks();
  }

  /// Initialize deep link listeners
  Future<void> _initDeepLinks() async {
    // Handle initial link when app is closed - ONLY ONCE
    if (!_hasProcessedInitialLink) {
      final initialLink = await _appLinks.getInitialLink();
      if (initialLink != null) {
        debugPrint('📱 Initial link: $initialLink');
        _hasProcessedInitialLink = true;
        _handleDeepLink(initialLink);
      }
    }

    // Cancel old listener if exists (avoid duplicates)
    await _linkSubscription?.cancel();

    // Create NEW listener - only one active listener
    _linkSubscription = _appLinks.uriLinkStream.listen(
      (uri) {
        debugPrint('📱 Deep link stream: $uri');
        _handleDeepLink(uri);
      },
      onError: (err) {
        debugPrint('❌ Deep link error: $err');
      },
    );
  }

  /// Handle deep link navigation
  void _handleDeepLink(Uri uri) {
    // Update state
    latestLink.value = uri.toString();
    linkHistory.insert(
      0,
      '${DateTime.now().toString().substring(11, 19)} - $uri',
    );
    if (linkHistory.length > 10) {
      linkHistory.removeLast();
    }

    debugPrint('📱 Deep Link: $uri');
    debugPrint('   Scheme: ${uri.scheme}');
    debugPrint('   Host: ${uri.host}');
    debugPrint('   Path: ${uri.path}');
    debugPrint('   Query: ${uri.queryParameters}');

    // Navigate with GetX
    if (uri.scheme == 'demoapp' ||
        uri.scheme == 'http' ||
        uri.scheme == 'https') {
      // Cancel old timer if exists
      _navigationTimer?.cancel();

      // Delay 500ms to ensure GetX auto navigation completes
      _navigationTimer = Timer(const Duration(milliseconds: 500), () {
        // Parse path for HTTPS links from GitHub Pages
        String targetHost = uri.host;
        String targetPath = uri.path;

        // Handle GitHub Pages URL: https://lehuuthanh23.github.io/demo-deep-link/product/123
        if (uri.scheme == 'https' &&
            uri.host == 'lehuuthanh23.github.io' &&
            uri.path.startsWith('/demo-deep-link/')) {
          // Remove /demo-deep-link prefix
          targetPath = uri.path.replaceFirst('/demo-deep-link', '');
          targetHost = 'product'; // Default, will be overridden below

          // Parse the rest of the path
          final pathSegments = targetPath
              .split('/')
              .where((s) => s.isNotEmpty)
              .toList();
          if (pathSegments.isNotEmpty) {
            targetHost = pathSegments[0]; // product or promotion
            targetPath = pathSegments.length > 1
                ? '/${pathSegments.sublist(1).join('/')}'
                : '/';
          }
        }

        // Handle each deep link type
        if ((targetHost == 'product' || uri.host == 'product') &&
            (uri.pathSegments.isNotEmpty || targetPath != '/')) {
          final productId = uri.pathSegments.isNotEmpty
              ? uri.pathSegments.last
              : targetPath.split('/').where((s) => s.isNotEmpty).last;
          final routePath = '/product/$productId';

          debugPrint(
            '   → Navigate to $routePath (current: ${Get.currentRoute})',
          );

          // Smart navigation based on current route
          if (Get.currentRoute == '/' || Get.currentRoute == '/?') {
            // From home, push product
            Get.toNamed(routePath, parameters: uri.queryParameters);
          } else if (Get.currentRoute.startsWith('/product/')) {
            // Already on product, replace
            Get.offNamed(routePath, parameters: uri.queryParameters);
          } else {
            // From other route, back to home then navigate
            Get.until((route) => route.settings.name == '/');
            Get.toNamed(routePath, parameters: uri.queryParameters);
          }
        } else if ((targetHost == 'promotion' || uri.host == 'promotion') &&
            (uri.pathSegments.isNotEmpty || targetPath != '/')) {
          final promoCode = uri.pathSegments.isNotEmpty
              ? uri.pathSegments.last
              : targetPath.split('/').where((s) => s.isNotEmpty).last;
          final routePath = '/promotion/$promoCode';

          debugPrint(
            '   → Navigate to $routePath (current: ${Get.currentRoute})',
          );

          if (Get.currentRoute == '/' || Get.currentRoute == '/?') {
            Get.toNamed(routePath, parameters: uri.queryParameters);
          } else if (Get.currentRoute.startsWith('/promotion/')) {
            Get.offNamed(routePath, parameters: uri.queryParameters);
          } else {
            Get.until((route) => route.settings.name == '/');
            Get.toNamed(routePath, parameters: uri.queryParameters);
          }
        } else {
          debugPrint('   ⚠️ Unknown deep link format');
        }
      });
    }
  }

  void clearHistory() {
    linkHistory.clear();
    latestLink.value = 'No deep link yet';
  }

  @override
  void onClose() {
    _linkSubscription?.cancel();
    _navigationTimer?.cancel();
    super.onClose();
  }
}

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeController>(() => HomeController());
  }
}

// ============================================================================
// PAGES
// ============================================================================

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final controller = Get.find<HomeController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('GetX Deep Link Demo'),
        elevation: 2,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header
            Card(
              color: Colors.blue.shade50,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Icon(Icons.link, size: 48, color: Colors.blue.shade700),
                    const SizedBox(height: 8),
                    const Text(
                      'GetX Deep Link Demo',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'URI Scheme + GetX Navigation',
                      style: TextStyle(fontSize: 14),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Test links
            const Text(
              '🧪 Test Links',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),

            _buildTestLinkCard(
              title: '1. Product Link',
              link: 'demoapp://product/12345',
              description: 'Open product page ID: 12345',
              icon: Icons.shopping_bag,
              color: Colors.blue,
              onTap: () => Get.toNamed('/product/12345'),
            ),
            const SizedBox(height: 8),

            _buildTestLinkCard(
              title: '2. Product + Parameters',
              link: 'demoapp://product/12345?name=iPhone&price=999',
              description: 'Product with extra info',
              icon: Icons.shopping_cart,
              color: Colors.green,
              onTap: () => Get.toNamed(
                '/product/12345',
                parameters: {'name': 'iPhone', 'price': '999'},
              ),
            ),
            const SizedBox(height: 8),

            _buildTestLinkCard(
              title: '3. Promotion Link',
              link: 'demoapp://promotion/SUMMER50',
              description: 'Open promotion page',
              icon: Icons.local_offer,
              color: Colors.orange,
              onTap: () => Get.toNamed('/promotion/SUMMER50'),
            ),
            const SizedBox(height: 8),

            _buildTestLinkCard(
              title: '4. Custom Parameters',
              link: 'demoapp://product/99?category=electronics&discount=20',
              description: 'With multiple params',
              icon: Icons.star,
              color: Colors.purple,
              onTap: () => Get.toNamed(
                '/product/99',
                parameters: {'category': 'electronics', 'discount': '20'},
              ),
            ),

            const SizedBox(height: 20),

            // Instructions
            Card(
              color: Colors.green.shade50,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.info_outline, color: Colors.green.shade700),
                        const SizedBox(width: 8),
                        const Text(
                          'How to Test',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'ANDROID:\n'
                      '• ADB: adb shell am start -W -a android.intent.action.VIEW -d "demoapp://product/12345"\n'
                      '• Chrome: Paste link in address bar\n'
                      '• SMS: Send link to yourself\n\n'
                      'iOS:\n'
                      '• Safari: Paste link → Go\n'
                      '• Notes: Paste link → Tap\n\n'
                      'Or tap cards above to test navigation!',
                      style: TextStyle(fontSize: 13),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Latest link
            const Text(
              '📨 Latest Deep Link',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Obx(
              () => Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: SelectableText(
                  controller.latestLink.value,
                  style: const TextStyle(fontFamily: 'monospace', fontSize: 12),
                ),
              ),
            ),

            // History
            Obx(
              () => controller.linkHistory.isNotEmpty
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              '📜 Link History',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            TextButton(
                              onPressed: controller.clearHistory,
                              child: const Text('Clear'),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Container(
                          constraints: const BoxConstraints(maxHeight: 200),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade300),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: controller.linkHistory.length,
                            itemBuilder: (context, index) {
                              return Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 8,
                                ),
                                decoration: BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(
                                      color: Colors.grey.shade200,
                                    ),
                                  ),
                                ),
                                child: Text(
                                  controller.linkHistory[index],
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontFamily: 'monospace',
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    )
                  : const SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTestLinkCard({
    required String title,
    required String link,
    required String description,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 2,
      child: InkWell(
        onTap: () {
          onTap();
          Get.snackbar(
            'Navigation',
            'Navigated to: $link',
            snackPosition: SnackPosition.BOTTOM,
            duration: const Duration(seconds: 2),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: color, size: 24),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    SelectableText(
                      link,
                      style: TextStyle(
                        fontSize: 11,
                        color: color,
                        fontFamily: 'monospace',
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ProductPage extends StatelessWidget {
  ProductPage({super.key});

  final String productId = Get.parameters['id'] ?? 'unknown';
  final Map<String, String?> params = Get.parameters;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Product Details'),
        backgroundColor: Colors.blue,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.shopping_bag, size: 100, color: Colors.blue),
              const SizedBox(height: 24),
              Text(
                'Product ID: $productId',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (params.length > 1) ...[
                const SizedBox(height: 16),
                const Text(
                  'Additional Info:',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    children: params.entries
                        .where((e) => e.key != 'id')
                        .map(
                          (e) => Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '${e.key}:',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(e.value ?? ''),
                              ],
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ),
              ],
              const SizedBox(height: 16),
              const Text(
                '✅ Deep link working with GetX!',
                style: TextStyle(fontSize: 16, color: Colors.green),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton.icon(
                    onPressed: () => Get.back(),
                    icon: const Icon(Icons.arrow_back),
                    label: const Text('Back'),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton.icon(
                    onPressed: () => Get.toNamed('/'),
                    icon: const Icon(Icons.home),
                    label: const Text('Home'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PromotionPage extends StatelessWidget {
  PromotionPage({super.key});

  final String promoCode = Get.parameters['code'] ?? 'unknown';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Promotion'),
        backgroundColor: Colors.orange,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.local_offer, size: 100, color: Colors.orange),
              const SizedBox(height: 24),
              Text(
                'Promo Code:',
                style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.orange.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.orange, width: 2),
                ),
                child: Text(
                  promoCode,
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                '🎉 50% OFF!',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.orange,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                '✅ Deep link working with GetX!',
                style: TextStyle(fontSize: 16, color: Colors.green),
              ),
              const SizedBox(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton.icon(
                    onPressed: () => Get.back(),
                    icon: const Icon(Icons.arrow_back),
                    label: const Text('Back'),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton.icon(
                    onPressed: () => Get.offAllNamed('/'),
                    icon: const Icon(Icons.home),
                    label: const Text('Home'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class NotFoundPage extends StatelessWidget {
  const NotFoundPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('404')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 100, color: Colors.red),
            const SizedBox(height: 24),
            const Text(
              'Page Not Found',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: () => Get.offAllNamed('/'),
              icon: const Icon(Icons.home),
              label: const Text('Go Home'),
            ),
          ],
        ),
      ),
    );
  }
}
