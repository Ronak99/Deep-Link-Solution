import 'package:deep_link_solution/deep_link_generator.dart';
import 'package:deep_link_solution/deep_link_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // Configure named routes
      routes: {
        '/': (context) => const LandingPage(),
        '/home': (context) => const MockPage(text: "HOME"),
        '/product': (context) => const MockPage(text: "PRODUCT"),
        '/profile': (context) => const MockPage(text: "PROFILE"),
      },
    );
  }
}

void _shareViaWhatsApp(String link) async {
  // String whatsappUrl = 'https://www.google.com';
  // String whatsappUrl = 'whatsapp://send?text=$link';
  if (await canLaunchUrl(Uri.parse(link))) {
    await launchUrl(Uri.parse(link));
  }
}

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  final _deepLinkService = DeepLinkService();

  @override
  void initState() {
    super.initState();

    // Initialize deep linking
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _deepLinkService.initUniLinks(context);
    });
  }

  @override
  void dispose() {
    _deepLinkService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const UserView(),
            const SizedBox(height: 12),
            const ProductView(),
          ],
        ),
      ),
    );
  }
}

class UserView extends StatefulWidget {
  const UserView({super.key});

  @override
  State<UserView> createState() => _UserViewState();
}

class _UserViewState extends State<UserView> {
  String? uid;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.purple.withOpacity(.15),
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        children: [
          const Text("User Page"),
          const SizedBox(height: 10),
          TextField(
            decoration: const InputDecoration(hintText: "Provide User ID"),
            onChanged: (value) {
              setState(() {
                uid = value;
              });
            },
          ),
          const SizedBox(height: 10),
          TextButton(
            child: const Text("Share User Profile"),
            onPressed: () {
              String link = DeepLinkGenerator.generateProfileLink(uid!);
              Clipboard.setData(ClipboardData(text: link));
            },
          ),
        ],
      ),
    );
  }
}

class ProductView extends StatefulWidget {
  const ProductView({super.key});

  @override
  State<ProductView> createState() => _ProductViewState();
}

class _ProductViewState extends State<ProductView> {
  String? uid;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.purple.withOpacity(.15),
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        children: [
          const Text("Product Page"),
          const SizedBox(height: 10),
          TextField(
            decoration: const InputDecoration(hintText: "Provide Product ID"),
            onChanged: (value) {
              setState(() {
                uid = value;
              });
            },
          ),
          const SizedBox(height: 10),
          TextButton(
            child: const Text("Share Product"),
            onPressed: () {
              String link = DeepLinkGenerator.generateProductLink(uid!);
              Clipboard.setData(ClipboardData(text: link));
            },
          ),
        ],
      ),
    );
  }
}

class MockPage extends StatelessWidget {
  final String text;

  const MockPage({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    // Retrieve the arguments
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;
    final String? productId = args?['productId'];
    final String? userId = args?['userId'];

    return Scaffold(
      appBar: AppBar(title: Text("$text Page")),
      body: Center(
        child: productId != null
            ? Text("Showing Details for product: $productId")
            : Text("Showing Details for user: $userId"),
      ),
    );
  }
}
