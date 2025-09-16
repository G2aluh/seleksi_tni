import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/peserta_model.dart';

class SupabaseService {
  final supabase = Supabase.instance.client;

  Future<List<PesertaModel>> getPeserta() async {
  try {
    // Cek koneksi (opsional, sudah ditangani di UI)
    final response = await supabase.from('peserta_tni').select();
    return (response as List).map((e) => PesertaModel.fromMap(e)).toList();
  } catch (e) {
    if (e is PostgrestException) {
      throw Exception('Error server: ${e.message}');
    } else {
      throw Exception('Terjadi kesalahan saat memuat data: $e');
    }
  }
}

  Future<void> addPeserta(PesertaModel peserta) async {
    await supabase.from('peserta_tni').insert(peserta.toMap());
  }

  Future<void> updatePeserta(int id, PesertaModel peserta) async {
    await supabase.from('peserta_tni').update(peserta.toMap()).eq('id', id);
  }

  Future<void> deletePeserta(int id) async {
    await supabase.from('peserta_tni').delete().eq('id', id);
  }
  Future<List<String>> getDusunSuggestions(String query) async {
  final response = await supabase
      .from('data_dusun')
      .select('dusun')
      .ilike('dusun', '%$query%')
      .limit(10); // Batasi hasil untuk performa
  return (response as List).map((e) => e['dusun'] as String).toList();
}

Future<Map<String, dynamic>?> getDusunDetails(String dusun) async {
  final response = await supabase
      .from('data_dusun')
      .select('id, kabupaten, kecamatan, desa, kode_pos')
      .eq('dusun', dusun)
      .maybeSingle();
  return response;
}
}
