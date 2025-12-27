import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class TrustNusaController extends GetxController {
  final supabase = Supabase.instance.client;

  final isLoading = false.obs;
  final hasRequested = false.obs;
  final isVerified = false.obs;

  /// ✅ ambil status verified dari profiles + apakah sudah request
  Future<void> fetchTrustStatus() async {
    final user = supabase.auth.currentUser;
    if (user == null) return;

    try {
      isLoading.value = true;

      // 1) cek verified dari profiles (kolom: isVerified)
      final profile =
          await supabase
              .from('profiles')
              .select('isVerified')
              .eq('id', user.id)
              .maybeSingle();

      isVerified.value = (profile?['isVerified'] as bool?) ?? false;

      // 2) cek apakah sudah request
      final req =
          await supabase
              .from('trust_nusa_requests')
              .select('id')
              .eq('user_id', user.id)
              .maybeSingle();

      hasRequested.value = req != null;
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  /// ✅ klik tombol Request Trust Nusa
  Future<void> requestTrustNusa() async {
    final user = supabase.auth.currentUser;
    if (user == null) {
      Get.snackbar('Gagal', 'Kamu harus login dulu');
      return;
    }

    // ✅ refresh status dulu biar data paling update (misal admin baru verify)
    await fetchTrustStatus();

    // kalau sudah verified
    if (isVerified.value) {
      Get.snackbar('Info', 'Akun kamu sudah verified');
      return;
    }

    // kalau sudah pernah request
    if (hasRequested.value) {
      Get.snackbar('Info', 'Kamu sudah mengajukan request');
      return;
    }

    try {
      isLoading.value = true;

      await supabase.from('trust_nusa_requests').insert({
        'user_id': user.id,
        'is_verified': false, // default juga false (optional)
      });

      hasRequested.value = true;
      Get.snackbar('Berhasil', 'Request Trust Nusa berhasil dikirim');
    } on PostgrestException catch (e) {
      // duplicate unique (sudah pernah request)
      if (e.code == '23505') {
        hasRequested.value = true;
        Get.snackbar('Info', 'Kamu sudah mengajukan request');
      } else {
        Get.snackbar('Error', e.message);
      }
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onInit() {
    super.onInit();
    fetchTrustStatus();
  }
}
