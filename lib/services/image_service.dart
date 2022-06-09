import 'dart:io';
import 'package:http/http.dart' as http;

class ImageService {
  var baseUrl = 'https://galerilamriau.com/api/lam-admin';

  Future<void> setImage(File image) async {
    var url = '$baseUrl/image';
    var headers = {
      "Content-Type": "multipart/form-data",
      "Bearer":
          "2wNAfr1QBPn2Qckv55u5b4GN2jrgfnC8Y7cZO04yNpXciQHrj9NaWQhs1FSMo0Jd"
    };
    var body = {"image": image};

    var response =
        await http.post(Uri.parse(url), headers: headers, body: body);
    print(response.body);

    if (response.statusCode == 200) {
      print('success upload product');
    } else {
      throw Exception("Gagal set Products");
    }
  }

  Future<void> setImages(List<File> images) async {
    var url = '$baseUrl/image';
    var headers = {
      "Content-Type": "multipart/form-data",
      "Bearer":
          "2wNAfr1QBPn2Qckv55u5b4GN2jrgfnC8Y7cZO04yNpXciQHrj9NaWQhs1FSMo0Jd"
    };

    var body = {
      'imageUrl': images.map((image) => image.path).toList(),
    };

    var response = await http.post(
      Uri.parse(url),
      headers: headers,
      body: body,
    );
    print(response.body);

    if (response.statusCode == 200) {
      print('success upload banyak gambar product');
    } else {
      throw Exception("Gagal set Products");
    }
  }
}
