import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:xnusa_mobile/app/modules/profile_page/controllers/profile_page_controller.dart';
import 'package:xnusa_mobile/widgets/dialog/choose_button_dialog.dart';

class EditProfilePageController extends GetxController {
  final supabase = Supabase.instance.client;
  // Text Controllers
  final nameController = TextEditingController();
  final bioController = TextEditingController();
  final displayNameController = TextEditingController();
  final addressController = TextEditingController();

  // Observable variables
  final isLoading = false.obs;
  final showInstagramBadge = true.obs;
  final isProfilePublic = true.obs;
  final profileImageUrl = ''.obs;
  final profileController = Get.put(ProfilePageController());
  final interests = <String>[].obs;

  // Original values untuk detect changes
  String originalDisplayName = '';
  String originalAddress = '';
  String originalBio = '';

  @override
  void onInit() {
    super.onInit();
    loadProfileData();
  }

  @override
  void onClose() {
    nameController.dispose();
    bioController.dispose();
    displayNameController.dispose();
    addressController.dispose();
    super.onClose();
  }

  // Load existing profile data
  void loadProfileData() {
    nameController.text = 'Dito';
    bioController.text =
        '${profileController.profileData['bio'] ?? 'Write your bio here...'}';
    displayNameController.text =
        '${profileController.profileData['display_name'] ?? 'John Doe'}';
    addressController.text =
        '${profileController.profileData['address'] ?? 'Jln Telekomunikasi'}';

    // Save original values
    originalDisplayName = displayNameController.text;
    originalAddress = addressController.text;
    originalBio = bioController.text;
  }

  // Check if any field has been modified
  bool hasUnsavedChanges() {
    return displayNameController.text.trim() != originalDisplayName ||
        addressController.text.trim() != originalAddress ||
        bioController.text.trim() != originalBio;
  }

  // Handle navigation to request verified page
  void navigateToRequestVerified() {
    if (hasUnsavedChanges()) {
      // _showSaveChangesDialog();
      showChooseButtonDialog(
        title: "Unsaved Changes",
        description:
            "You have unsaved changes. Would you like to save them before proceeding?",
        onDiscard: () {
          Get.back(); // Close dialog
          Get.toNamed('/request-verified-page'); // Navigate without saving
        },
        onSave: () async {
          Get.back(); // Close dialog
          await saveProfile(); // Save changes
          // Only navigate if save was successful
          if (!isLoading.value) {
            Get.toNamed('/request-verified-page');
          }
        },
        discardText: "Discard",
        saveText: "Save & Continue",
      );
    } else {
      Get.toNamed('/request-verified-page');
    }
  }

  // Show dialog when there are unsaved changes
  // Show dialog when there are unsaved changes
  // void _showSaveChangesDialog() {
  //   Get.dialog(
  //     AlertDialog(
  //       alignment: Alignment.center,
  //       backgroundColor: ColorApp.white,
  //       title: Text(
  //         'Unsaved Changes',
  //         style: TypographyApp.headline1.copyWith(fontSize: SizeApp.h16),
  //         textAlign: TextAlign.center,
  //       ),
  //       content: Text(
  //         'You have unsaved changes. Would you like to save them before proceeding?',
  //         style: TypographyApp.label.copyWith(
  //           fontWeight: FontWeight.w200,
  //           color: ColorApp.darkGrey,
  //         ),
  //         textAlign: TextAlign.center,
  //       ),
  //       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
  //       actions: [
  //         Row(
  //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //           children: [
  //             TextButton(
  //               onPressed: () {
  //                 Get.back(); // Close dialog
  //                 Get.toNamed(
  //                   '/request-verified-page',
  //                 ); // Navigate without saving
  //               },
  //               child: const Text(
  //                 'Discard',
  //                 style: TextStyle(
  //                   color: Colors.red,
  //                   fontWeight: FontWeight.w600,
  //                 ),
  //               ),
  //             ),
  //             ElevatedButton(
  //               onPressed: () async {
  //                 Get.back(); // Close dialog
  //                 await saveProfile(); // Save changes
  //                 // Only navigate if save was successful
  //                 if (!isLoading.value) {
  //                   Get.toNamed('/request-verified-page');
  //                 }
  //               },
  //               style: ElevatedButton.styleFrom(
  //                 backgroundColor: Colors.black,
  //                 foregroundColor: Colors.white,
  //                 shape: RoundedRectangleBorder(
  //                   borderRadius: BorderRadius.circular(8),
  //                 ),
  //                 padding: const EdgeInsets.symmetric(
  //                   horizontal: 20,
  //                   vertical: 12,
  //                 ),
  //               ),
  //               child: const Text(
  //                 'Save & Continue',
  //                 style: TextStyle(fontWeight: FontWeight.w600),
  //               ),
  //             ),
  //           ],
  //         ),
  //       ],
  //       actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
  //     ),
  //     barrierDismissible: true, // User can tap outside to cancel
  //   );
  // }

  // Toggle Instagram badge
  void toggleInstagramBadge(bool value) {
    showInstagramBadge.value = value;
  }

  // Toggle profile privacy
  void toggleProfilePrivacy() {
    isProfilePublic.value = !isProfilePublic.value;
  }

  // Save profile changes
  Future<void> saveProfile() async {
    isLoading.value = true;

    try {
      final user = supabase.auth.currentUser;
      if (user == null) return;

      await supabase
          .from('profiles')
          .update({
            'display_name': displayNameController.text.trim(),
            'address': addressController.text.trim(),
            'bio': bioController.text.trim(),
          })
          .eq('id', user.id);

      profileController.fetchProfile();
      Get.back();
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to update profile: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Pick profile image
  Future<void> pickProfileImage() async {
    // TODO: Implement image picker
    // Example using image_picker package:
    // final ImagePicker picker = ImagePicker();
    // final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    // if (image != null) {
    //   profileImageUrl.value = image.path;
    // }
  }

  // Navigate to links page
  void navigateToLinks() {
    // TODO: Navigate to links management page
    Get.toNamed('/links');
  }
}
