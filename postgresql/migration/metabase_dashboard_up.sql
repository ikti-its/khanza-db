SET search_path TO dashboard;
CREATE TABLE IF NOT EXISTS modernisasi_pengelolaan_blu (
    entry_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
	tanggal_entry DATE NOT NULL,
	id_user UUID NOT NULL,
	created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
	FOREIGN KEY (id_user) REFERENCES users (id)
	);
CREATE TABLE IF NOT EXISTS integrasi_data (
    id UUID PRIMARY KEY,
    ID_secret_key_dev BOOLEAN NOT NULL,
    ID_pengiriman_data_dev BOOLEAN NOT NULL,
    ID_otomasi_pengiriman BOOLEAN NOT NULL,
	ID_secret_key_prod BOOLEAN NOT NULL,
    ID_pengiriman_data_prod BOOLEAN NOT NULL,
    ID_jumlah_pengiriman_data_harian int NOT NULL,
	ID_jumlah_data_keuangan int  NOT NULL,
	ID_jumlah_data_layanan int NOT NULL,
	ID_jumlah_data_sdm int NOT NULL,
	ID_jumlah_total_data int NOT NULL,
	FOREIGN KEY (id) REFERENCES modernisasi_pengelolaan_blu (entry_id)
);

CREATE TABLE IF NOT EXISTS analitika_data (
    id UUID PRIMARY KEY,
    AD_layanan_kinerja BOOLEAN NOT NULL,
    AD_layanan_jumlah_pengguna BOOLEAN NOT NULL,
	AD_layanan_trend_pemberian_layanan BOOLEAN NOT NULL,
	AD_layanan_hasil_survey_pengguna BOOLEAN NOT NULL,
	AD_layanan_akses_PPKBLU BOOLEAN NOT NULL,
	
	AD_keuangan_realisasi_PB BOOLEAN NOT NULL,
    AD_keuangan_jumlah_kas BOOLEAN NOT NULL,
	AD_keuangan_saldo_rekening_blu BOOLEAN NOT NULL,
	AD_keuangan_analisis_data_keuangan BOOLEAN NOT NULL,
	AD_keuangan_akses_PPKBLU BOOLEAN NOT NULL,
	
	AD_sdm_komposisi_sdm BOOLEAN NOT NULL,
    AD_sdm_profil_sdm BOOLEAN NOT NULL,
	AD_sdm_analisis_kebutuhan_pegawai BOOLEAN NOT NULL,
	AD_sdm_analisis_bebas_kerja BOOLEAN NOT NULL,
	AD_sdm_analisis_kinerja_pegawai BOOLEAN NOT NULL,
	AD_sdm_training_need_analysis BOOLEAN NOT NULL,
	
	AD_jumlah_dashboard_pendukung int NOT NULL,

	AD_sdm_khusus BOOLEAN NOT NULL,
	AD_analisis_prediktif BOOLEAN NOT NULL,
   
   FOREIGN KEY (id) REFERENCES modernisasi_pengelolaan_blu (entry_id)
);