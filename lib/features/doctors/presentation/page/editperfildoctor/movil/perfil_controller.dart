import 'package:get/get.dart';
import 'package:flutter/material.dart';

class PerfilController extends GetxController {
  final userName = 'Flor Morales'.obs;
  final userHandle = '@florm_'.obs;
  final reviewCount = 1.obs;
  final followersCount = 20.obs;
  final followingCount = 32.obs;
  
  final currentImagePage = 0.obs;
  final pageController = PageController();
  
  final reviews = <ReviewModel>[].obs;
  
  @override
  void onInit() {
    super.onInit();
    loadInitialData();
  }
  
  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }
  
  void loadInitialData() {
    reviews.add(
      ReviewModel(
        userName: 'Flor Morales',
        date: '16/03/2025',
        title: '¡Encantada con el doctor!',
        content: 'Te explica súper bien todo el tratamiento, resuelve todas tus dudas, es amable y usa productos de calidad. Me encantaron los resultados.',
        images: [
          'assets/icons/FOTOGRAFIA.png',
        ],
        userRole: 'Dr. Juan González',
        rating: 5.0,
        reactions: 12,
      ),
    );
  }
  
  void onImagePageChanged(int page) {
    currentImagePage.value = page;
  }
  
  void goToImagePage(int page) {
    pageController.animateToPage(
      page,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }
  
  void nextImagePage() {
    if (currentImagePage.value < getTotalPages() - 1) {
      goToImagePage(currentImagePage.value + 1);
    }
  }
  
  void previousImagePage() {
    if (currentImagePage.value > 0) {
      goToImagePage(currentImagePage.value - 1);
    }
  }
  
  int getTotalPages([List<String>? images]) {
    if (images == null || images.isEmpty) return 0;
    return (images.length / 2).ceil();
  }
  
  void updateUserName(String name) {
    userName.value = name;
  }
  
  void updateUserHandle(String handle) {
    userHandle.value = handle;
  }
  
  void incrementFollowers() {
    followersCount.value++;
  }
  
  void decrementFollowers() {
    if (followersCount.value > 0) {
      followersCount.value--;
    }
  }
  
  void incrementFollowing() {
    followingCount.value++;
  }
  
  void decrementFollowing() {
    if (followingCount.value > 0) {
      followingCount.value--;
    }
  }
  
  void addReview(ReviewModel review) {
    reviews.add(review);
    reviewCount.value = reviews.length;
  }
  
  void removeReview(int index) {
    if (index >= 0 && index < reviews.length) {
      reviews.removeAt(index);
      reviewCount.value = reviews.length;
    }
  }
  
  void updateReview(int index, ReviewModel review) {
    if (index >= 0 && index < reviews.length) {
      reviews[index] = review;
    }
  }
  
  String getReviewCountText() {
    return reviewCount.value == 1 
        ? '${reviewCount.value} reseña creada'
        : '${reviewCount.value} reseñas creadas';
  }
  
  String getFollowersText() {
    return '${followersCount.value} seguidores';
  }
  
  String getFollowingText() {
    return '${followingCount.value} Seguidos';
  }
  
  void resetImagePage() {
    currentImagePage.value = 0;
    if (pageController.hasClients) {
      pageController.animateToPage(
        0,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }
}

class ReviewModel {
  final String userName;
  final String date;
  final String title;
  final String content;
  final List<String> images;
  final String userRole;
  final double rating;
  final int reactions;
  
  ReviewModel({
    required this.userName,
    required this.date,
    required this.title,
    required this.content,
    required this.images,
    required this.userRole,
    required this.rating,
    required this.reactions,
  });
  
  ReviewModel copyWith({
    String? userName,
    String? date,
    String? title,
    String? content,
    List<String>? images,
    String? userRole,
    double? rating,
    int? reactions,
  }) {
    return ReviewModel(
      userName: userName ?? this.userName,
      date: date ?? this.date,
      title: title ?? this.title,
      content: content ?? this.content,
      images: images ?? this.images,
      userRole: userRole ?? this.userRole,
      rating: rating ?? this.rating,
      reactions: reactions ?? this.reactions,
    );
  }
}