-- modernisasi_pengelolaan_blu table
INSERT INTO modernisasi_pengelolaan_blu (tanggal_entry, id_user,entry_id) VALUES ('2024-04-18', '0616c5af-32a0-4e0c-8802-b35ed6543802','550e8400-e29b-41d4-a716-446655440000');

-- integrasi_data table
INSERT INTO integrasi_data (id, ID_secret_key_dev, ID_pengiriman_data_dev, ID_otomasi_pengiriman, ID_secret_key_prod, ID_pengiriman_data_prod, ID_jumlah_pengiriman_data_harian, ID_jumlah_data_keuangan, ID_jumlah_data_layanan, ID_jumlah_data_sdm, ID_jumlah_total_data) 
VALUES ('550e8400-e29b-41d4-a716-446655440000', TRUE, TRUE, TRUE, TRUE, TRUE, 365, 2, 10, 5, 17);

-- analitika_data table
INSERT INTO analitika_data (id, AD_layanan_kinerja, AD_layanan_jumlah_pengguna, AD_layanan_trend_pemberian_layanan, AD_layanan_hasil_survey_pengguna, AD_layanan_akses_PPKBLU, AD_keuangan_realisasi_PB, AD_keuangan_jumlah_kas, AD_keuangan_saldo_rekening_blu, AD_keuangan_analisis_data_keuangan, AD_keuangan_akses_PPKBLU, AD_sdm_komposisi_sdm, AD_sdm_profil_sdm, AD_sdm_analisis_kebutuhan_pegawai, AD_sdm_analisis_bebas_kerja, AD_sdm_analisis_kinerja_pegawai, AD_sdm_training_need_analysis, AD_jumlah_dashboard_pendukung, AD_sdm_khusus, AD_analisis_prediktif) 
VALUES ('550e8400-e29b-41d4-a716-446655440000', TRUE, TRUE, TRUE, TRUE, TRUE, TRUE, TRUE, TRUE, TRUE, TRUE, TRUE, TRUE, TRUE, TRUE, TRUE, TRUE, 2, TRUE, TRUE);

-- sistem_informasi_manajemen table
INSERT INTO sistem_informasi_manajemen (id, sim_keuangan_penerimaan_BLU, sim_keuangan_keuangan_BLU, sim_keuangan_pencatatan_blu, sim_layanan_pencatatan_blu, sim_layanan_integrasi_keuangan, sim_sdm_pencatatan_sdm, sim_sdm_kinerja_sdm, sim_mobile_layanan) 
VALUES ('550e8400-e29b-41d4-a716-446655440000', TRUE, TRUE, TRUE, TRUE, TRUE, TRUE, TRUE, TRUE);

-- website table
INSERT INTO website (id, web_uji_performa_akses, web_informasi_profil_BLU, web_informasi_layanan_BLU, web_fitur_pengaduan, web_survey_layanan, web_SEO) 
VALUES ('550e8400-e29b-41d4-a716-446655440000', 0.87, TRUE, TRUE, TRUE, TRUE, TRUE);
