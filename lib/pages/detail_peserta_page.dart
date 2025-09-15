import 'package:flutter/material.dart';
import '../data/models/peserta_model.dart';

class DetailPesertaPage extends StatelessWidget {
  final PesertaModel peserta;

  const DetailPesertaPage({super.key, required this.peserta});

  Widget _infoCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
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
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1F2937),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionCard(
    String title,
    IconData icon,
    Color color,
    List<Widget> children,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: color,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Row(
              children: [
                Icon(icon, color: Colors.white, size: 20),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(children: children),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text(
          'Detail Peserta',
          style: TextStyle(fontWeight: FontWeight.w600, color: Colors.white),
        ),
        backgroundColor: const Color(0xFF1E40AF),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Header Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF3B82F6), Color(0xFF1E40AF)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF3B82F6).withOpacity(0.3),
                    blurRadius: 15,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Center(
                      child: Text(
                        peserta.namaLengkap[0].toUpperCase(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 32,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    peserta.namaLengkap,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'NISN: ${peserta.nisn}',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Data Pribadi Section
            _sectionCard(
              "Data Pribadi",
              Icons.person,
              const Color(0xFF3B82F6),
              [
                _infoCard(
                  "Jenis Kelamin",
                  peserta.jenisKelamin,
                  Icons.wc,
                  const Color(0xFF3B82F6),
                ),
                const SizedBox(height: 12),
                _infoCard(
                  "Agama",
                  peserta.agama,
                  Icons.church,
                  const Color(0xFF3B82F6),
                ),
                const SizedBox(height: 12),
                _infoCard(
                  "Tempat, Tanggal Lahir",
                  peserta.ttl,
                  Icons.calendar_today,
                  const Color(0xFF3B82F6),
                ),
                const SizedBox(height: 12),
                _infoCard(
                  "No HP/Telp",
                  peserta.noHp,
                  Icons.phone,
                  const Color(0xFF3B82F6),
                ),
                const SizedBox(height: 12),
                _infoCard(
                  "NIK",
                  peserta.nik,
                  Icons.credit_card,
                  const Color(0xFF3B82F6),
                ),
              ],
            ),

            // Alamat Section
            _sectionCard("Alamat", Icons.home, const Color(0xFF10B981), [
              _infoCard(
                "Jalan",
                peserta.jalan,
                Icons.straighten,
                const Color(0xFF10B981),
              ),
              const SizedBox(height: 12),
              _infoCard(
                "RT/RW",
                peserta.rtRw,
                Icons.home,
                const Color(0xFF10B981),
              ),
              const SizedBox(height: 12),
              _infoCard(
                "Dusun",
                peserta.dusun,
                Icons.location_pin,
                const Color(0xFF10B981),
              ),
              const SizedBox(height: 12),
              _infoCard(
                "Desa",
                peserta.desa,
                Icons.location_city,
                const Color(0xFF10B981),
              ),
              const SizedBox(height: 12),
              _infoCard(
                "Kecamatan",
                peserta.kecamatan,
                Icons.apartment,
                const Color(0xFF10B981),
              ),
              const SizedBox(height: 12),
              _infoCard(
                "Kabupaten",
                peserta.kabupaten,
                Icons.account_balance,
                const Color(0xFF10B981),
              ),
              const SizedBox(height: 12),
              _infoCard(
                "Provinsi",
                peserta.provinsi,
                Icons.map,
                const Color(0xFF10B981),
              ),
              const SizedBox(height: 12),
              _infoCard(
                "Kode Pos",
                peserta.kodePos,
                Icons.local_post_office,
                const Color(0xFF10B981),
              ),
            ]),

            // Orang Tua/Wali Section
            _sectionCard(
              "Orang Tua / Wali",
              Icons.family_restroom,
              const Color(0xFF8B5CF6),
              [
                _infoCard(
                  "Nama Ayah",
                  peserta.namaAyah,
                  Icons.man,
                  const Color(0xFF8B5CF6),
                ),
                const SizedBox(height: 12),
                _infoCard(
                  "Nama Ibu",
                  peserta.namaIbu,
                  Icons.woman,
                  const Color(0xFF8B5CF6),
                ),
                const SizedBox(height: 12),
                _infoCard(
                  "Nama Wali",
                  peserta.namaWali.isEmpty ? "-" : peserta.namaWali,
                  Icons.person_outline,
                  const Color(0xFF8B5CF6),
                ),
                const SizedBox(height: 12),
                _infoCard(
                  "Alamat Orang Tua/Wali",
                  peserta.alamatOrtu,
                  Icons.home,
                  const Color(0xFF8B5CF6),
                ),
              ],
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
