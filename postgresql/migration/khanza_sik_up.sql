-- Akun
CREATE TABLE IF NOT EXISTS akun (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    email VARCHAR(255) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    foto VARCHAR(255) NOT NULL,
    role INT NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    deleted_at TIMESTAMP WITH TIME ZONE,
    updater UUID,
    FOREIGN KEY (role) REFERENCES ref.role (id)
);

-- Modul C (Fathur, Ruben)
-- Pegawai
CREATE TYPE jenis_kelamin AS ENUM ('L', 'P');
CREATE TYPE jenis_pegawai AS ENUM ('Tetap', 'Kontrak', 'Magang', 'Istimewa');

CREATE TABLE IF NOT EXISTS pegawai (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    id_akun UUID NOT NULL UNIQUE,
    nip VARCHAR(10) NOT NULL UNIQUE,
    nama VARCHAR(255) NOT NULL,
    jenis_kelamin jenis_kelamin NOT NULL,
    id_jabatan INT NOT NULL,
    id_departemen INT NOT NULL,
    id_status_aktif VARCHAR(2) NOT NULL,
    jenis_pegawai jenis_pegawai NOT NULL,
    telepon VARCHAR(255) NOT NULL,
    tanggal_masuk DATE NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    deleted_at TIMESTAMP WITH TIME ZONE,
    updater UUID,
    FOREIGN KEY (id_akun) REFERENCES akun (id),
    FOREIGN KEY (id_jabatan) REFERENCES ref.jabatan (id),
    FOREIGN KEY (id_departemen) REFERENCES ref.departemen (id),
    FOREIGN KEY (id_status_aktif) REFERENCES ref.status_aktif_pegawai (id),
    FOREIGN KEY (updater) REFERENCES akun (id)
);

-- Alamat
CREATE TABLE IF NOT EXISTS alamat (
    id_akun UUID PRIMARY KEY,
    alamat VARCHAR(255) NOT NULL,
    alamat_lat NUMERIC NOT NULL DEFAULT 7.2575,
    alamat_lon NUMERIC NOT NULL DEFAULT 112.7521,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    deleted_at TIMESTAMP WITH TIME ZONE,
    updater UUID,
    FOREIGN KEY (id_akun) REFERENCES akun (id),
    FOREIGN KEY (updater) REFERENCES akun (id)
);

-- Berkas Pegawai (Dokumen)
CREATE TYPE agama AS ENUM ('Islam', 'Kristen', 'Katolik', 'Hindu', 'Buddha', 'Konghucu', 'Lainnya');
CREATE TYPE pendidikan AS ENUM ('Tidak Sekolah', 'SD', 'SMP', 'SMA', 'D3', 'D4', 'S1', 'S2', 'S3');

CREATE TABLE IF NOT EXISTS berkas_pegawai (
    id_pegawai UUID PRIMARY KEY,
    nik VARCHAR(16) NOT NULL UNIQUE,
    tempat_lahir VARCHAR(255) NOT NULL,
    tanggal_lahir DATE NOT NULL,
    agama agama NOT NULL,
    pendidikan pendidikan NOT NULL,
    ktp VARCHAR(255) NOT NULL,
    kk VARCHAR(255) NOT NULL,
    npwp VARCHAR(255) NOT NULL,
    bpjs VARCHAR(255),
    ijazah VARCHAR(255),
    skck VARCHAR(255),
    str VARCHAR(255),
    serkom VARCHAR(255),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    deleted_at TIMESTAMP WITH TIME ZONE,
    updater UUID,
    FOREIGN KEY (id_pegawai) REFERENCES pegawai (id),
    FOREIGN KEY (updater) REFERENCES akun (id)
);

-- Foto (Untuk keperluan presensi)
CREATE TABLE IF NOT EXISTS foto_pegawai (
    id_pegawai UUID PRIMARY KEY,
    foto VARCHAR(255) NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    deleted_at TIMESTAMP WITH TIME ZONE,
    updater UUID,
    FOREIGN KEY (id_pegawai) REFERENCES pegawai (id),
    FOREIGN KEY (updater) REFERENCES akun (id)
);

-- Jadwal Pegawai
CREATE TABLE IF NOT EXISTS jadwal_pegawai (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    id_pegawai UUID NOT NULL,
    id_hari INT NOT NULL,
    id_shift VARCHAR(2) NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    deleted_at TIMESTAMP WITH TIME ZONE,
    updater UUID,
    FOREIGN KEY (id_pegawai) REFERENCES pegawai (id),
    FOREIGN KEY (id_hari) REFERENCES ref.hari (id),
    FOREIGN KEY (id_shift) REFERENCES ref.shift (id),
    FOREIGN KEY (updater) REFERENCES akun (id)
);

-- Presensi
CREATE TABLE IF NOT EXISTS presensi (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    id_pegawai UUID NOT NULL,
    id_jadwal_pegawai UUID NOT NULL,
    tanggal DATE DEFAULT CURRENT_DATE,
    jam_masuk TIME WITH TIME ZONE,
    jam_pulang TIME WITH TIME ZONE,
    keterangan VARCHAR(50),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    deleted_at TIMESTAMP WITH TIME ZONE,
    updater UUID,
    FOREIGN KEY (id_pegawai) REFERENCES pegawai (id),
    FOREIGN KEY (id_jadwal_pegawai) REFERENCES jadwal_pegawai (id),
    FOREIGN KEY (updater) REFERENCES akun (id)
);

-- Cuti
CREATE TABLE IF NOT EXISTS cuti (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    id_pegawai UUID NOT NULL,
    tanggal_mulai DATE NOT NULL,
    tanggal_selesai DATE NOT NULL,
    id_alasan_cuti VARCHAR(2) NOT NULL,
    status BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    deleted_at TIMESTAMP WITH TIME ZONE,
    updater UUID,
    FOREIGN KEY (id_pegawai) REFERENCES pegawai (id),
    FOREIGN KEY (id_alasan_cuti) REFERENCES ref.alasan_cuti (id),
    FOREIGN KEY (updater) REFERENCES akun (id)
);

-- Modul D (Leo)
-- Barang Medis
CREATE TYPE sik.jenis_barang_medis AS ENUM ('Obat', 'Alat Kesehatan', 'Bahan Habis Pakai', 'Darah');

CREATE TABLE IF NOT EXISTS barang_medis (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    nama VARCHAR(100) NOT NULL,
    jenis jenis_barang_medis NOT NULL,
    id_satuan INT NOT NULL DEFAULT 1,
    harga FLOAT NOT NULL DEFAULT 0,
    stok INT NOT NULL DEFAULT 0,
    stok_minimum INT NOT NULL DEFAULT -1,
    notifikasi_kadaluwarsa_hari INT NOT NULL DEFAULT -1,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    deleted_at TIMESTAMP WITH TIME ZONE,
    updater UUID,
    FOREIGN KEY (id_satuan) REFERENCES ref.satuan_barang_medis (id),
    FOREIGN KEY (updater) REFERENCES akun (id)
);

-- Obat
CREATE TABLE IF NOT EXISTS obat (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    id_barang_medis UUID NOT NULL,
    id_industri_farmasi INT NOT NULL,
    kandungan VARCHAR(100) NOT NULL,
    id_satuan_kecil INT NOT NULL DEFAULT 1,
    isi INT NOT NULL,
    kapasitas INT NOT NULL,
    id_jenis INT NOT NULL,
    id_kategori INT NOT NULL,
    id_golongan INT NOT NULL,
    kadaluwarsa DATE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    deleted_at TIMESTAMP WITH TIME ZONE,
    updater UUID,
    FOREIGN KEY (id_barang_medis) REFERENCES barang_medis (id),
    FOREIGN KEY (id_satuan_kecil) REFERENCES ref.satuan_barang_medis (id),
    FOREIGN KEY (id_industri_farmasi) REFERENCES ref.industri_farmasi (id),
    FOREIGN KEY (id_jenis) REFERENCES ref.jenis_obat (id),
    FOREIGN KEY (id_kategori) REFERENCES ref.kategori_obat (id),
    FOREIGN KEY (id_golongan) REFERENCES ref.golongan_obat (id),
    FOREIGN KEY (updater) REFERENCES akun (id)
);

-- Alat Kesehatan
CREATE TYPE merek_alat_kesehatan AS ENUM ('Omron','Philips', 'GE Healthcare', 'Siemens Healthineers', 'Medtronic', 'Johnson & Johnson', 'Becton, Dickinson and Company (BD)', 'Stryker', 'Boston Scientific', 'Olympus Corporation', 'Roche Diagnostics');

CREATE TABLE IF NOT EXISTS alat_kesehatan (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    id_barang_medis UUID NOT NULL,
    merek merek_alat_kesehatan NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    deleted_at TIMESTAMP WITH TIME ZONE,
    updater UUID,
    FOREIGN KEY (id_barang_medis) REFERENCES barang_medis (id),
    FOREIGN KEY (updater) REFERENCES akun (id)
);

-- Bahan Habis Pakai
CREATE TABLE IF NOT EXISTS bahan_habis_pakai (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    id_barang_medis UUID NOT NULL,
    jumlah INT NOT NULL,
    kadaluwarsa DATE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    deleted_at TIMESTAMP WITH TIME ZONE,
    updater UUID,
    FOREIGN KEY (id_barang_medis) REFERENCES barang_medis (id),
    FOREIGN KEY (updater) REFERENCES akun (id)
);

-- Darah
CREATE TYPE jenis_darah AS ENUM ('Whole Blood (WB)', 'Packed Red Cell (PRC)', 'Thrombocyte Concentrate (TC)', 'Fresh Frozen Plasma (FFP)', 'Cryoprecipitate atau AHF', 'Leucodepleted (LD)', 'Leucoreduced (LR)');
CREATE TABLE IF NOT EXISTS darah (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    id_barang_medis UUID NOT NULL,
    jenis jenis_darah NOT NULL,
    keterangan TEXT,
    kadaluwarsa DATE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    deleted_at TIMESTAMP WITH TIME ZONE,
    updater UUID,
    FOREIGN KEY (id_barang_medis) REFERENCES barang_medis (id),
    FOREIGN KEY (updater) REFERENCES akun (id)
);

-- Pengajuan Barang Medis
CREATE TYPE status_pesanan AS ENUM ('0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '10'); -- Menunggu persetujuan,  Pengajuan Ditolak, Pengajuan disetujui, Dalam pemesanan, Barang telah sampai, Tagihan belum lunas, Tagihan telah dibayar

CREATE TABLE IF NOT EXISTS pengajuan_barang_medis (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    tanggal_pengajuan DATE DEFAULT CURRENT_DATE,
    nomor_pengajuan VARCHAR(20) NOT NULL UNIQUE,
    id_pegawai UUID NOT NULL, 
    diskon_persen FLOAT NOT NULL DEFAULT 0,
    diskon_jumlah FLOAT NOT NULL DEFAULT 0,
    pajak_persen FLOAT NOT NULL DEFAULT 0,
    pajak_jumlah FLOAT NOT NULL DEFAULT 0,
    materai FLOAT NOT NULL DEFAULT 0,
    catatan VARCHAR(255),
    status_pesanan status_pesanan NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    deleted_at TIMESTAMP WITH TIME ZONE,
    updater UUID,
    FOREIGN KEY (id_pegawai) REFERENCES pegawai (id),
    FOREIGN KEY (updater) REFERENCES akun (id)
);

-- Persetujuan pengajuan
CREATE TYPE status_persetujuan AS ENUM ('Menunggu Persetujuan', 'Disetujui', 'Ditolak');

CREATE TABLE IF NOT EXISTS persetujuan_pengajuan (
    id_pengajuan UUID PRIMARY KEY,
    status status_persetujuan NOT NULL DEFAULT 'Menunggu Persetujuan',
    status_apoteker status_persetujuan NOT NULL DEFAULT 'Menunggu Persetujuan',
    status_keuangan status_persetujuan NOT NULL DEFAULT 'Menunggu Persetujuan',
    id_apoteker UUID,
    id_keuangan UUID,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    deleted_at TIMESTAMP WITH TIME ZONE,
    updater UUID,
    FOREIGN KEY (id_pengajuan) REFERENCES pengajuan_barang_medis (id),
    FOREIGN KEY (id_apoteker) REFERENCES akun (id),
    FOREIGN KEY (id_keuangan) REFERENCES akun (id),
    FOREIGN KEY (updater) REFERENCES akun (id)
);

-- Pesanan Barang Medis
CREATE TABLE IF NOT EXISTS pesanan_barang_medis (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    id_pengajuan UUID NOT NULL,
    id_barang_medis UUID NOT NULL,
    id_satuan INT NOT NULL DEFAULT 1,
    harga_satuan_pengajuan FLOAT NOT NULL DEFAULT 0,
    harga_satuan_pemesanan FLOAT NOT NULL DEFAULT 0,
    jumlah_pesanan INT NOT NULL,
    jumlah_diterima INT NOT NULL DEFAULT 0,
    kadaluwarsa DATE,
    no_batch VARCHAR(20),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP, 
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP, 
    deleted_at TIMESTAMP WITH TIME ZONE,
    updater UUID, 
    FOREIGN KEY (id_pengajuan) REFERENCES pengajuan_barang_medis (id),
    FOREIGN KEY (id_satuan) REFERENCES ref.satuan_barang_medis (id),
    FOREIGN KEY (id_barang_medis) REFERENCES barang_medis (id),
    FOREIGN KEY (updater) REFERENCES akun (id)
);

-- Pemesanan Barang Medis
CREATE TABLE IF NOT EXISTS pemesanan_barang_medis (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    tanggal_pesan DATE NOT NULL,
    no_pemesanan VARCHAR(20) NOT NULL,
    id_pengajuan UUID NOT NULL,
    id_supplier INT NOT NULL,
    id_pegawai UUID NOT NULL,
    diskon_persen FLOAT NOT NULL DEFAULT 0,
    diskon_jumlah FLOAT NOT NULL DEFAULT 0,
    pajak_persen FLOAT NOT NULL DEFAULT 0,
    pajak_jumlah FLOAT NOT NULL DEFAULT 0,
    materai FLOAT NOT NULL DEFAULT 0,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    deleted_at TIMESTAMP WITH TIME ZONE,
    updater UUID, 
    FOREIGN KEY (id_pengajuan) REFERENCES pengajuan_barang_medis (id),
    FOREIGN KEY (id_supplier) REFERENCES ref.supplier_barang_medis (id),
    FOREIGN KEY (id_pegawai) REFERENCES pegawai (id),
    FOREIGN KEY (updater) REFERENCES akun (id)
);

-- Penerimaan Barang Medis
CREATE TABLE IF NOT EXISTS penerimaan_barang_medis (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    id_pengajuan UUID NOT NULL,
    id_pemesanan UUID NOT NULL,
    no_faktur VARCHAR(20) NOT NULL,
    tanggal_datang DATE NOT NULL,
    tanggal_faktur DATE NOT NULL,
    tanggal_jthtempo DATE NOT NULL,
    id_pegawai UUID NOT NULL, 
    id_ruangan INT NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    deleted_at TIMESTAMP WITH TIME ZONE,
    updater UUID, 
    FOREIGN KEY (id_pengajuan) REFERENCES pengajuan_barang_medis (id),
    FOREIGN KEY (id_pemesanan) REFERENCES pemesanan_barang_medis (id),
    FOREIGN KEY (id_pegawai) REFERENCES pegawai (id),
    FOREIGN KEY (id_ruangan) REFERENCES ref.ruangan (id),
    FOREIGN KEY (updater) REFERENCES akun (id)
);

-- Bayar Tagihan Barang Medis
CREATE TABLE IF NOT EXISTS tagihan_barang_medis (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    id_pengajuan UUID NOT NULL,
    id_pemesanan UUID NOT NULL,
    id_penerimaan UUID NOT NULL,
    tanggal_bayar DATE NOT NULL,
    jumlah_bayar FLOAT NOT NULL,
    id_pegawai UUID NOT NULL, 
    keterangan VARCHAR(255),
    no_bukti VARCHAR(50) NOT NULL,
    id_akun_bayar INT NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    deleted_at TIMESTAMP WITH TIME ZONE,
    updater UUID, 
    FOREIGN KEY (id_pengajuan) REFERENCES pengajuan_barang_medis (id),
    FOREIGN KEY (id_pemesanan) REFERENCES pemesanan_barang_medis (id),
    FOREIGN KEY (id_penerimaan) REFERENCES penerimaan_barang_medis (id),
    FOREIGN KEY (id_pegawai) REFERENCES pegawai (id),
    FOREIGN KEY (id_akun_bayar) REFERENCES ref.akun_bayar (id),
    FOREIGN KEY (updater) REFERENCES akun (id)
);

-- Stok Keluar Barang Medis
CREATE TABLE IF NOT EXISTS stok_keluar_barang_medis (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    no_keluar VARCHAR(20) NOT NULL,
    id_pegawai UUID NOT NULL, 
    tanggal_stok_keluar DATE NOT NULL DEFAULT CURRENT_DATE,
    keterangan VARCHAR(255), 
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    deleted_at TIMESTAMP WITH TIME ZONE,
    updater UUID, 
    FOREIGN KEY (id_pegawai) REFERENCES pegawai (id),
    FOREIGN KEY (updater) REFERENCES akun (id)
);


--Transaksi Keluar Barang Medis
CREATE TABLE IF NOT EXISTS transaksi_keluar_barang_medis (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    id_stok_keluar UUID NOT NULL,
    id_barang_medis UUID NOT NULL,
    no_batch VARCHAR (20),
    no_faktur VARCHAR(20),
    jumlah_keluar INT NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    deleted_at TIMESTAMP WITH TIME ZONE,
    updater UUID, 
    FOREIGN KEY (id_stok_keluar) REFERENCES stok_keluar_barang_medis (id),
    FOREIGN KEY (id_barang_medis) REFERENCES barang_medis (id),
    FOREIGN KEY (updater) REFERENCES akun (id)
);
