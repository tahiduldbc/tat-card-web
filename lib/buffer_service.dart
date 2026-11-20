import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;

class BufferService {
  // --dart-define দিয়ে দিবা, কোডে সরাসরি Key রাখবা না
  static const apiKey = String.fromEnvironment('BUFFER_API_KEY');
  static const channelId = String.fromEnvironment('BUFFER_CHANNEL_ID');
  static const imgbbKey = String.fromEnvironment('IMGBB_API_KEY');

  // ১. JPG Bytes -> Public URL
  static Future<String> uploadToImgBB(Uint8List jpgBytes) async {
    if (imgbbKey.isEmpty) {
      throw Exception('Image upload is not configured. Set up a secure server-side upload endpoint.');
    }
    final res = await http.post(
      Uri.parse('https://api.imgbb.com/1/upload?key=$imgbbKey'),
      body: {'image': base64Encode(jpgBytes)},
    );
    final data = jsonDecode(res.body);
    if (data['success'] != true) throw Exception('Image upload failed');
    return data['data']['display_url'] as String;
  }

  // ২. Buffer দিয়ে ShareNow
  static Future<void> publishNow({
    required String text,
    required String imageUrl,
  }) async {
    // jsonEncode দিয়ে বাংলা টেক্সটের কোটেশন সমস্যা থেকে বাঁচছি
    final query = '''
    mutation CreatePost {
      createPost(input: {
        text: ${jsonEncode(text)},
        channelId: "$channelId",
        schedulingType: automatic,
        mode: shareNow,
        assets: [{ image: { url: ${jsonEncode(imageUrl)} } }],
        metadata: {
          facebook: { type: post }
        }
      }) {
        ... on PostActionSuccess { post { id text } }
        ... on MutationError { message }
      }
    }
    ''';

    final res = await http.post(
      Uri.parse('https://api.buffer.com'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $apiKey',
      },
      body: jsonEncode({'query': query}),
    );

    final body = jsonDecode(res.body);
    if (body['data']?['createPost']?['message'] != null) {
      throw Exception(body['data']['createPost']['message']);
    }
  }
}