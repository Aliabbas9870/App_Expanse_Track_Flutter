import 'dart:ui';

import 'package:get/get.dart';

class RatingController extends GetxController {
  var rating = 0.0.obs;
  var comment = ''.obs;
  var ratingsList = <Map<String, dynamic>>[].obs;

  void updateRating(double newRating) {
    rating.value = newRating;
  }

  void updateComment(String newComment) {
    comment.value = newComment;
  }

  void submitRating() {
    if (rating.value > 0) {
      ratingsList.add({
        'rating': rating.value,
        'comment': comment.value,
        'timestamp': DateTime.now().toIso8601String(),
      });
      Get.snackbar('Success', 'Rating submitted successfully',
          backgroundColor: Color(0xff38D3AE));
    } else {
      Get.snackbar('Error', 'Please provide a rating');
    }
  }
}
