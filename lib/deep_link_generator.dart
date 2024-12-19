class DeepLinkGenerator {
  static String baseUrl = "https://inquirely-web.vercel.app";

  static String generateProductLink(String productId) {
    return "$baseUrl/product?id=$productId";
  }

  static String generateProfileLink(String userId) {
    return "$baseUrl/profile?id=$userId";
  }
}
