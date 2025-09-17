import 'package:flutter/material.dart';
import 'package:seleksi_tni/widgets/errror_koneksi.dart';
import '../data/models/peserta_model.dart';
import '../data/service/supabase_service.dart';
import 'detail_peserta_page.dart';
import 'form_peserta_page.dart';
import '../widgets/custom_toast.dart';

/// Halaman utama: menampilkan list peserta dan aksi CRUD.
class PesertaListPage extends StatefulWidget {
  const PesertaListPage({super.key});

  @override
  State<PesertaListPage> createState() => _PesertaListPageState();
}

/// State untuk mengelola fetching data dan aksi pada list peserta.
class _PesertaListPageState extends State<PesertaListPage> {
  final SupabaseService _supabaseService = SupabaseService();
  List<PesertaModel> _pesertaList = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadPeserta();
  }

 /// Memuat data peserta dari Supabase dan menangani error koneksi/server.
 Future<void> _loadPeserta() async {
  setState(() {
    _isLoading = true;
  });

  try {
    final peserta = await _supabaseService.getPeserta();
    setState(() {
      _pesertaList = peserta;
      _isLoading = false;
    });
  } catch (e) {
  setState(() {
    _isLoading = false;
  });

  if (e.toString().contains("SocketException")) {
    // Tidak ada internet
    showNoInternetDialog(context, _loadPeserta);
  } else {
    // Masalah koneksi Supabase
    showSupabaseErrorDialog(context, e.toString(), _loadPeserta);
  }
}

}


  /// Menghapus peserta dan refresh list dengan notifikasi.
  Future<void> _deletePeserta(int id) async {
    try {
      await _supabaseService.deletePeserta(id);
      _loadPeserta();
      if (mounted) {
        CustomToast.warning(context, 'Data berhasil dihapus');
      }
    } catch (e) {
      if (mounted) {
        CustomToast.error(context, 'Error: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text(
          'Daftar Peserta Seleksi TNI',
          style: TextStyle(fontWeight: FontWeight.w600, color: Colors.white),
        ),
        backgroundColor: const Color(0xFF1E40AF),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF3B82F6)),
              ),
            )
          : _pesertaList.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.people_outline, size: 64, color: Colors.grey[400]),
                  const SizedBox(height: 16),
                  Text(
                    'Belum ada data peserta',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Tekan tombol + untuk menambah peserta baru',
                    style: TextStyle(fontSize: 14, color: Colors.grey[500]),
                  ),
                ],
              ),
            )
          : RefreshIndicator(
              onRefresh: _loadPeserta,
              color: const Color(0xFF3B82F6),
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: _pesertaList.length,
                itemBuilder: (context, index) {
                  final peserta = _pesertaList[index];
                  return Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(12),
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => DetailPesertaPage(peserta: peserta),
                          ),
                        ).then((_) => _loadPeserta()),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            children: [
                              // Avatar
                              Container(
                                width: 50,
                                height: 50,
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    colors: [
                                      Color(0xFF3B82F6),
                                      Color(0xFF1E40AF),
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Center(
                                  child: Text(
                                    peserta.namaLengkap[0].toUpperCase(),
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 16),

                              // Info peserta
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      peserta.namaLengkap,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 16,
                                        color: Color(0xFF1F2937),
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.badge,
                                          size: 12,
                                          color: Colors.grey[600],
                                        ),
                                        const SizedBox(width: 6),
                                        Text(
                                          'NISN: ${peserta.nisn}',
                                          style: TextStyle(
                                            fontSize: 13,
                                            color: Colors.grey[600],
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 2),
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.phone,
                                          size: 12,
                                          color: Colors.grey[600],
                                        ),
                                        const SizedBox(width: 6),
                                        Text(
                                          peserta.noHp,
                                          style: TextStyle(
                                            fontSize: 13,
                                            color: Colors.grey[600],
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 2),
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.location_on,
                                          size: 12,
                                          color: Colors.grey[600],
                                        ),
                                        const SizedBox(width: 6),
                                        Expanded(
                                          child: Text(
                                            '${peserta.desa}, ${peserta.kecamatan}',
                                            style: TextStyle(
                                              fontSize: 13,
                                              color: Colors.grey[600],
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),

                              // Menu button
                              PopupMenuButton<String>(
                                onSelected: (value) async {
                                  if (value == 'edit') {
                                    final result = await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) =>
                                            FormPesertaPage(peserta: peserta),
                                      ),
                                    );
                                    if (result == true) {
                                      _loadPeserta();
                                      if (mounted) {
                                        CustomToast.success(
                                          context,
                                          'Data berhasil diperbarui',
                                        );
                                      }
                                    }
                                  } else if (value == 'delete') {
                                    _showDeleteDialog(peserta);
                                  }
                                },
                                color: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                elevation: 6,
                                icon: Icon(
                                  Icons.more_horiz,
                                  size: 20,
                                  color: Colors.grey[700],
                                ),
                                itemBuilder: (context) => [
                                  PopupMenuItem(
                                    value: 'edit',
                                    child: Row(
                                      children: const [
                                        Icon(
                                          Icons.edit_rounded,
                                          size: 18,
                                          color: Color(0xFF2563EB),
                                        ),
                                        SizedBox(width: 12),
                                        Text('Edit'),
                                      ],
                                    ),
                                  ),
                                  const PopupMenuDivider(height: 6),
                                  PopupMenuItem(
                                    value: 'delete',
                                    child: Row(
                                      children: const [
                                        Icon(
                                          Icons.delete_rounded,
                                          size: 18,
                                          color: Color(0xFFEF4444),
                                        ),
                                        SizedBox(width: 12),
                                        Text('Hapus'),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
      floatingActionButton: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF3B82F6).withOpacity(0.3),
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: FloatingActionButton(
          onPressed: () async {
            final result = await Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const FormPesertaPage()),
            );
            if (result == true) {
              _loadPeserta();
            }
          },
          backgroundColor: const Color(0xFF3B82F6),
          child: Icon(Icons.add, color: Colors.white),
        ),
      ),
    );
  }

  void _showDeleteDialog(PesertaModel peserta) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        
        title: Row(
          children: [
            Icon(Icons.warning, color: Colors.orange[600], size: 24),
            const SizedBox(width: 12),
            const Text(
              'Konfirmasi Hapus',
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
            ),
          ],
        ),
        content: Text(
          'Apakah Anda yakin ingin menghapus data ${peserta.namaLengkap}?',
          style: const TextStyle(fontSize: 16),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            style: TextButton.styleFrom(foregroundColor: Colors.grey[600]),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _deletePeserta(peserta.id!);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFEF4444),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
  }
}
