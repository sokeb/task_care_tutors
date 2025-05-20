import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HomeController extends GetxController{
  String? _imageUrl;
  final isLoading = false.obs;
  var selectedDate = DateTime.now();

   get imageUrl => _imageUrl;

  @override
  void onInit() {
    super.onInit();
    fetchNasaImage();
  }

  Future<void> fetchNasaImage() async {
    isLoading.value = true;
    final dateStr = "${selectedDate.year}-${selectedDate.month.toString().padLeft(2, '0')}-${selectedDate.day.toString().padLeft(2, '0')}";
    final url = Uri.parse(
        'https://api.nasa.gov/planetary/apod?api_key=18QBwoiRpbFgeYBSl3PxFHi2aoJjrt7lIindJfng&date=$dateStr');

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        _imageUrl = data['url'];
      }
      update();
    } catch (e) {
      Get.snackbar('Error', 'Failed to fetch image: $e',
          snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading.value = false;
    }
  }

  void updateDate(DateTime date) {
    selectedDate = date;
  }


}
