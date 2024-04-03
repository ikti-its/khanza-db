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

CREATE INDEX IF NOT EXISTS idx_akun_foto ON akun (foto);
CREATE INDEX IF NOT EXISTS idx_akun_role ON akun (role);
CREATE INDEX IF NOT EXISTS idx_akun_updated_at ON akun (updated_at);
CREATE INDEX IF NOT EXISTS idx_akun_deleted_at ON akun (deleted_at);

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

CREATE INDEX IF NOT EXISTS idx_pegawai_jenis_kelamin ON pegawai (jenis_kelamin);
CREATE INDEX IF NOT EXISTS idx_pegawai_id_jabatan ON pegawai (id_jabatan);
CREATE INDEX IF NOT EXISTS idx_pegawai_id_departemen ON pegawai (id_departemen);
CREATE INDEX IF NOT EXISTS idx_pegawai_id_status_aktif ON pegawai (id_status_aktif);
CREATE INDEX IF NOT EXISTS idx_pegawai_jenis_pegawai ON pegawai (jenis_pegawai);
CREATE INDEX IF NOT EXISTS idx_pegawai_tanggal_masuk ON pegawai (tanggal_masuk);
CREATE INDEX IF NOT EXISTS idx_pegawai_updated_at ON pegawai (updated_at);
CREATE INDEX IF NOT EXISTS idx_pegawai_deleted_at ON pegawai (deleted_at);

CREATE TRIGGER init_jadwal_pegawai
AFTER INSERT ON pegawai
FOR EACH ROW
EXECUTE PROCEDURE trigger_init_jadwal_pegawai();

-- Alamat
CREATE TABLE IF NOT EXISTS alamat (
    id_akun UUID PRIMARY KEY,
    alamat VARCHAR(255) NOT NULL,
    alamat_lat NUMERIC NOT NULL DEFAULT 7.2575,
    alamat_lon NUMERIC NOT NULL DEFAULT 112.7521,
    kota VARCHAR(255) NOT NULL,
    kode_pos VARCHAR(5) NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    deleted_at TIMESTAMP WITH TIME ZONE,
    updater UUID,
    FOREIGN KEY (id_akun) REFERENCES akun (id),
    FOREIGN KEY (updater) REFERENCES akun (id)
);

CREATE INDEX IF NOT EXISTS idx_alamat_alamat ON alamat (alamat);
CREATE INDEX IF NOT EXISTS idx_alamat_alamat_lat ON alamat (alamat_lat);
CREATE INDEX IF NOT EXISTS idx_alamat_alamat_lon ON alamat (alamat_lon);
CREATE INDEX IF NOT EXISTS idx_alamat_kode_pos ON alamat (kode_pos);
CREATE INDEX IF NOT EXISTS idx_alamat_updated_at ON alamat (updated_at);
CREATE INDEX IF NOT EXISTS idx_alamat_deleted_at ON alamat (deleted_at);

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

CREATE INDEX IF NOT EXISTS idx_berkas_pegawai_agama ON berkas_pegawai (agama);
CREATE INDEX IF NOT EXISTS idx_berkas_pegawai_pendidikan ON berkas_pegawai (pendidikan);
CREATE INDEX IF NOT EXISTS idx_berkas_pegawai_ktp ON berkas_pegawai (ktp);
CREATE INDEX IF NOT EXISTS idx_berkas_pegawai_kk ON berkas_pegawai (kk);
CREATE INDEX IF NOT EXISTS idx_berkas_pegawai_npwp ON berkas_pegawai (npwp);
CREATE INDEX IF NOT EXISTS idx_berkas_pegawai_bpjs ON berkas_pegawai (bpjs);
CREATE INDEX IF NOT EXISTS idx_berkas_pegawai_ijazah ON berkas_pegawai (ijazah);
CREATE INDEX IF NOT EXISTS idx_berkas_pegawai_skck ON berkas_pegawai (skck);
CREATE INDEX IF NOT EXISTS idx_berkas_pegawai_str ON berkas_pegawai (str);
CREATE INDEX IF NOT EXISTS idx_berkas_pegawai_serkom ON berkas_pegawai (serkom);

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

CREATE INDEX IF NOT EXISTS idx_foto_pegawai_foto ON foto_pegawai (foto);
CREATE INDEX IF NOT EXISTS idx_foto_pegawai_updated_at ON foto_pegawai (updated_at);
CREATE INDEX IF NOT EXISTS idx_foto_pegawai_deleted_at ON foto_pegawai (deleted_at);

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

CREATE INDEX IF NOT EXISTS idx_jadwal_pegawai_id_pegawai ON jadwal_pegawai (id_pegawai);
CREATE INDEX IF NOT EXISTS idx_jadwal_pegawai_id_shift ON jadwal_pegawai (id_shift);
CREATE INDEX IF NOT EXISTS idx_jadwal_pegawai_id_hari ON jadwal_pegawai (id_hari);
CREATE INDEX IF NOT EXISTS idx_jadwal_pegawai_updated_at ON jadwal_pegawai (updated_at);
CREATE INDEX IF NOT EXISTS idx_jadwal_pegawai_deleted_at ON jadwal_pegawai (deleted_at);

CREATE OR REPLACE FUNCTION default_jadwal_pegawai(IN new_id UUID)
RETURNS VOID AS $$
BEGIN
    INSERT INTO jadwal_pegawai (id_pegawai, id_hari, id_shift)
    SELECT new_id, hari.id, 'NA'
    FROM ref.hari;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION trigger_init_jadwal_pegawai()
RETURNS TRIGGER AS $$
BEGIN
    PERFORM default_jadwal_pegawai(NEW.id);
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

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

CREATE INDEX IF NOT EXISTS idx_presensi_id_pegawai ON presensi (id_pegawai);
CREATE INDEX IF NOT EXISTS idx_presensi_id_jadwal_pegawai ON presensi (id_jadwal_pegawai);
CREATE INDEX IF NOT EXISTS idx_presensi_tanggal ON presensi (tanggal);
CREATE INDEX IF NOT EXISTS idx_presensi_jam_masuk ON presensi (jam_masuk);
CREATE INDEX IF NOT EXISTS idx_presensi_jam_pulang ON presensi (jam_pulang);
CREATE INDEX IF NOT EXISTS idx_presensi_keterangan ON presensi (keterangan);
CREATE INDEX IF NOT EXISTS idx_presensi_updated_at ON presensi (updated_at);
CREATE INDEX IF NOT EXISTS idx_presensi_deleted_at ON presensi (deleted_at);

CREATE OR REPLACE FUNCTION check_keterangan_presensi()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.jam_masuk IS NOT NULL AND NEW.jam_pulang IS NOT NULL THEN
        SELECT s.nama INTO NEW.keterangan
        FROM ref.shift s
        JOIN jadwal_pegawai jp ON jp.id_shift = s.id
        WHERE jp.id = NEW.id_jadwal_pegawai;

        IF NEW.jam_masuk > ref.shift.jam_masuk THEN
            NEW.keterangan := NEW.keterangan || ' (Terlambat)';
        END IF;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER set_keterangan_presensi
BEFORE UPDATE ON presensi
FOR EACH ROW
EXECUTE PROCEDURE check_keterangan_presensi();

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

CREATE INDEX IF NOT EXISTS idx_cuti_id_pegawai ON cuti (id_pegawai);
CREATE INDEX IF NOT EXISTS idx_cuti_tanggal_mulai ON cuti (tanggal_mulai);
CREATE INDEX IF NOT EXISTS idx_cuti_tanggal_selesai ON cuti (tanggal_selesai);
CREATE INDEX IF NOT EXISTS idx_cuti_id_alasan_cuti ON cuti (id_alasan_cuti);
CREATE INDEX IF NOT EXISTS idx_cuti_status ON cuti (status);
CREATE INDEX IF NOT EXISTS idx_cuti_updated_at ON cuti (updated_at);
CREATE INDEX IF NOT EXISTS idx_cuti_deleted_at ON cuti (deleted_at);

-- Modul D (Leo)
-- Barang Medis
CREATE TYPE sik.jenis_barang_medis AS ENUM ('Obat', 'Alat Kesehatan', 'Bahan Habis Pakai', 'Darah');

CREATE TABLE IF NOT EXISTS sik.barang_medis (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    nama VARCHAR(100) NOT NULL,
    jenis jenis_barang_medis NOT NULL,
    harga FLOAT NOT NULL DEFAULT 0,
    stok INT NOT NULL DEFAULT 0,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    deleted_at TIMESTAMP WITH TIME ZONE,
    updater UUID,
    FOREIGN KEY (updater) REFERENCES akun (id)
);
    CREATE INDEX IF NOT EXISTS idx_barang_medis_jenis ON barang_medis (jenis);
    CREATE INDEX IF NOT EXISTS idx_barang_medis_updated_at ON barang_medis (updated_at);
    CREATE INDEX IF NOT EXISTS idx_barang_medis_deleted_at ON barang_medis (deleted_at);

-- Obat
CREATE TYPE sik.satuan_obat AS ENUM ('tablet', 'kapsul', 'ampul', 'botol', 'tube', 'vial', 'injeksi');

CREATE TABLE IF NOT EXISTS sik.obat (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    id_barang_medis UUID NOT NULL,
    id_industri_farmasi INT NOT NULL,
    kandungan VARCHAR(100) NOT NULL,
    id_satuan_besar satuan_obat NOT NULL,
    id_satuan_kecil satuan_obat NOT NULL,
    isi INT NOT NULL,
    kapasitas INT NOT NULL,
    id_jenis INT NOT NULL,
    id_kategori INT NOT NULL,
    id_golongan INT NOT NULL,
    kadaluwarsa DATE NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    deleted_at TIMESTAMP WITH TIME ZONE,
    updater UUID,
    FOREIGN KEY (id_barang_medis) REFERENCES barang_medis (id),
    FOREIGN KEY (id_industri_farmasi) REFERENCES ref.industri_farmasi (id),
    FOREIGN KEY (id_jenis) REFERENCES ref.jenis_obat (id),
    FOREIGN KEY (id_kategori) REFERENCES ref.kategori_obat (id),
    FOREIGN KEY (id_golongan) REFERENCES ref.golongan_obat (id),
    FOREIGN KEY (updater) REFERENCES akun (id)
);

CREATE INDEX IF NOT EXISTS idx_obat_id_barang_medis ON obat (id_barang_medis);
CREATE INDEX IF NOT EXISTS idx_obat_id_industri_farmasi ON obat (id_industri_farmasi);
CREATE INDEX IF NOT EXISTS idx_obat_kadaluwarsa ON obat (kadaluwarsa);
CREATE INDEX IF NOT EXISTS idx_obat_updated_at ON obat (updated_at);
CREATE INDEX IF NOT EXISTS idx_obat_deleted_at ON obat (deleted_at);

-- Alat Kesehatan
CREATE TYPE merek_alat_kesehatan AS ENUM ('Omron','Philips', 'GE Healthcare', 'Siemens Healthineers', 'Medtronic', 'Johnson & Johnson', 'Becton, Dickinson and Company (BD)', 'Stryker', 'Boston Scientific', 'Olympus Corporation', 'Roche Diagnostics');

CREATE TABLE IF NOT EXISTS sik.alat_kesehatan (
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

CREATE INDEX IF NOT EXISTS idx_alat_kesehatan_merek ON alat_kesehatan (merek);
CREATE INDEX IF NOT EXISTS idx_alat_kesehatan_updated_at ON alat_kesehatan (updated_at);
CREATE INDEX IF NOT EXISTS idx_alat_kesehatan_deleted_at ON alat_kesehatan (deleted_at);

-- Bahan Habis Pakai
CREATE TYPE satuan_bahan_habis_pakai AS ENUM ('pasang', 'kotak', 'paket', 'item', 'botol', 'tabung', 'ml');

CREATE TABLE IF NOT EXISTS sik.bahan_habis_pakai (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    id_barang_medis UUID NOT NULL,
    satuan satuan_bahan_habis_pakai_medis NOT NULL,
    jumlah INT NOT NULL,
    kadaluwarsa DATE NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    deleted_at TIMESTAMP WITH TIME ZONE,
    updater UUID,
    FOREIGN KEY (id_barang_medis) REFERENCES barang_medis (id),
    FOREIGN KEY (updater) REFERENCES akun (id)
);

CREATE INDEX IF NOT EXISTS idx_bahan_habis_pakai_updated_at ON bahan_habis_pakai (updated_at);
CREATE INDEX IF NOT EXISTS idx_bahan_habis_pakai_deleted_at ON bahan_habis_pakai (deleted_at);

-- Darah
CREATE TABLE IF NOT EXISTS sik.darah (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    id_barang_medis UUID NOT NULL,
    keterangan TEXT,
    kadaluwarsa DATE NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    deleted_at TIMESTAMP WITH TIME ZONE,
    updater UUID,
    FOREIGN KEY (id_barang_medis) REFERENCES barang_medis (id),
    FOREIGN KEY (updater) REFERENCES akun (id)
);

CREATE INDEX IF NOT EXISTS idx_darah_updated_at ON darah (updated_at);
CREATE INDEX IF NOT EXISTS idx_darah_deleted_at ON darah (deleted_at);

-- Pengajuan Barang Medis
CREATE TYPE status_pesanan AS ENUM ('0', '1', '2', '3', '4', '5'); -- Menunggu persetujuan,  Pengajuan Ditolak, Pengajuan disetujui, Dalam pemesanan, Barang telah sampai, Tagihan telah dibayar

CREATE TABLE IF NOT EXISTS sik.pengajuan_barang_medis (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    tanggal_pengajuan DATE DEFAULT CURRENT_DATE,
    nomor_pengajuan VARCHAR(20) NOT NULL UNIQUE,
    id_supplier INT NOT NULL,
    id_pegawai UUID NOT NULL, 
    diskon_persen FLOAT NOT NULL,
    diskon_jumlah FLOAT NOT NULL,
    pajak_persen FLOAT NOT NULL,
    pajak_jumlah FLOAT NOT NULL,
    materai FLOAT NOT NULL,
    catatan VARCHAR(255),
    status_pesanan status_pesanan NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    deleted_at TIMESTAMP WITH TIME ZONE,
    updater UUID,
    FOREIGN KEY (id_supplier) REFERENCES ref.supplier_barang_medis (id),
    FOREIGN KEY (id_pegawai) REFERENCES pegawai (id),
    FOREIGN KEY (updater) REFERENCES akun (id)
);
CREATE INDEX IF NOT EXISTS idx_pengajuan_barang_medis_tanggal_pengajuan ON pengajuan_barang_medis (tanggal_pengajuan);
CREATE INDEX IF NOT EXISTS idx_pengajuan_barang_medis_id_supplier ON pengajuan_barang_medis (id_supplier);
CREATE INDEX IF NOT EXISTS idx_pengajuan_barang_medis_id_pegawai ON pengajuan_barang_medis (id_pegawai);
CREATE INDEX IF NOT EXISTS idx_pengajuan_barang_medis_updated_at ON pengajuan_barang_medis (updated_at);
CREATE INDEX IF NOT EXISTS idx_pengajuan_barang_medis_deleted_at ON pengajuan_barang_medis (deleted_at);

-- Persetujuan pengajuan
CREATE TYPE status_persetujuan AS ENUM ('Disetujui', 'Ditolak');

CREATE TABLE IF NOT EXISTS sik.persetujuan_pengajuan (
    id_pengajuan UUID PRIMARY KEY,
    status status_persetujuan NOT NULL,
    status_apoteker status_persetujuan,
    status_keuangan status_persetujuan,
    id_apoteker UUID,
    id_keuangan UUID,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    deleted_at TIMESTAMP WITH TIME ZONE,
    updater UUID,
    FOREIGN KEY (id_pengajuan) REFERENCES pengajuan_barang_medis (id),
    FOREIGN KEY (id_apoteker) REFERENCES pegawai (id),
    FOREIGN KEY (id_keuangan) REFERENCES pegawai (id),
    FOREIGN KEY (updater) REFERENCES akun (id)
);

CREATE INDEX IF NOT EXISTS idx_persetujuan_pengajuan_status_keuangan ON persetujuan_pengajuan (status_keuangan);
CREATE INDEX IF NOT EXISTS idx_persetujuan_pengajuan_status_apoteker ON persetujuan_pengajuan (status_apoteker);
CREATE INDEX IF NOT EXISTS idx_persetujuan_pengajuan_id_apoteker ON persetujuan_pengajuan (id_apoteker);
CREATE INDEX IF NOT EXISTS idx_persetujuan_pengajuan_id_keuangan ON persetujuan_pengajuan (id_keuangan);
CREATE INDEX IF NOT EXISTS idx_persetujuan_pengajuan_updated_at ON persetujuan_pengajuan (updated_at);
CREATE INDEX IF NOT EXISTS idx_persetujuan_pengajuan_deleted_at ON persetujuan_pengajuan (deleted_at);

CREATE OR REPLACE FUNCTION update_status_pengajuan()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.status_apoteker IS NULL OR NEW.status_keuangan IS NULL THEN
        NEW.status := 'Menunggu Persetujuan';
    ELSIF NEW.status_apoteker = 'Ditolak' OR NEW.status_keuangan = 'Ditolak' THEN
        NEW.status := 'Ditolak';
    ELSIF NEW.status_apoteker = 'Disetujui' AND NEW.status_keuangan = 'Disetujui' THEN
        NEW.status := 'Disetujui';
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_update_status_pengajuan
BEFORE INSERT OR UPDATE OF status_apoteker, status_keuangan ON persetujuan_pengajuan
FOR EACH ROW
EXECUTE FUNCTION update_status_pengajuan();

-- Pesanan Barang Medis
CREATE TABLE IF NOT EXISTS sik.pesanan_barang_medis (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    id_pengajuan UUID NOT NULL,
    id_barang_medis UUID NOT NULL,
    harga_satuan FLOAT NOT NULL,
    jumlah_pesanan INT NOT NULL,
    jumlah_diterima INT NOT NULL DEFAULT 0,
    kadaluwarsa DATE NOT NULL,
    no_batch VARCHAR(20),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP, 
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP, 
    deleted_at TIMESTAMP WITH TIME ZONE,
    updater UUID, 
    FOREIGN KEY (id_pengajuan) REFERENCES pengajuan_barang_medis (id),
    FOREIGN KEY (id_barang_medis) REFERENCES barang_medis (id),
    FOREIGN KEY (updater) REFERENCES akun (id)
);

CREATE INDEX IF NOT EXISTS idx_pesanan_barang_medis_id_pengajuan ON pesanan_barang_medis (id_pengajuan);
CREATE INDEX IF NOT EXISTS idx_pesanan_barang_medis_id_barang_medis ON pesanan_barang_medis (id_barang_medis);
CREATE INDEX IF NOT EXISTS idx_pesanan_barang_medis_updated_at ON pesanan_barang_medis (updated_at);
CREATE INDEX IF NOT EXISTS idx_pesanan_barang_medis_deleted_at ON pesanan_barang_medis (deleted_at);


-- Pemesanan Barang Medis
CREATE TABLE IF NOT EXISTS sik.pemesanan_barang_medis (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    tanggal_pesan DATE NOT NULL,
    no_pemesanan VARCHAR(20) NOT NULL,
    id_pengajuan UUID NOT NULL,
    id_pegawai UUID NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    deleted_at TIMESTAMP WITH TIME ZONE,
    updater UUID, 
    FOREIGN KEY (id_pengajuan) REFERENCES pengajuan_barang_medis (id),
    FOREIGN KEY (id_pegawai) REFERENCES pegawai (id),
    FOREIGN KEY (updater) REFERENCES akun (id)
);

CREATE INDEX IF NOT EXISTS idx_pemesanan_barang_medis_id_pengajuan ON pemesanan_barang_medis (id_pengajuan);
CREATE INDEX IF NOT EXISTS idx_pemesanan_barang_medis_id_pegawai ON pemesanan_barang_medis (id_pegawai);
CREATE INDEX IF NOT EXISTS idx_pemesanan_barang_medis_id_updated_at ON pemesanan_barang_medis (updated_at);
CREATE INDEX IF NOT EXISTS idx_pemesanan_barang_medis_id_deleted_at ON pemesanan_barang_medis (deleted_at);

-- Penerimaan Barang Medis
CREATE TABLE IF NOT EXISTS sik.penerimaan_barang_medis (
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

CREATE INDEX IF NOT EXISTS idx_penerimaan_barang_medis_id_pengajuan ON penerimaan_barang_medis (id_pengajuan);
CREATE INDEX IF NOT EXISTS idx_penerimaan_barang_medis_id_pemesanan ON penerimaan_barang_medis (id_pemesanan);
CREATE INDEX IF NOT EXISTS idx_penerimaan_barang_medis_id_ruangan ON penerimaan_barang_medis (id_ruangan);
CREATE INDEX IF NOT EXISTS idx_penerimaan_barang_medis_id_pegawai ON penerimaan_barang_medis (id_pegawai);
CREATE INDEX IF NOT EXISTS idx_penerimaan_barang_medis_updated_at ON penerimaan_barang_medis (updated_at);
CREATE INDEX IF NOT EXISTS idx_penerimaan_barang_medis_deleted_at ON penerimaan_barang_medis (deleted_at);

-- Bayar Tagihan Barang Medis
CREATE TABLE IF NOT EXISTS sik.tagihan_barang_medis (
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

CREATE INDEX IF NOT EXISTS idx_tagihan_barang_medis_id_pengajuan ON tagihan_barang_medis (id_pengajuan);
CREATE INDEX IF NOT EXISTS idx_tagihan_barang_medis_id_pemesanan ON tagihan_barang_medis (id_pemesanan);
CREATE INDEX IF NOT EXISTS idx_tagihan_barang_medis_id_penerimaan ON tagihan_barang_medis (id_penerimaan);
CREATE INDEX IF NOT EXISTS idx_tagihan_barang_medis_tanggal_bayar ON tagihan_barang_medis (tanggal_bayar);
CREATE INDEX IF NOT EXISTS idx_tagihan_barang_medis_id_pegawai ON tagihan_barang_medis (id_pegawai);
CREATE INDEX IF NOT EXISTS idx_tagihan_barang_medis_id_akun_bayar ON tagihan_barang_medis (id_akun_bayar);
CREATE INDEX IF NOT EXISTS idx_tagihan_barang_medis_updated_at ON tagihan_barang_medis (updated_at);
CREATE INDEX IF NOT EXISTS idx_tagihan_barang_medis_deleted_at ON tagihan_barang_medis (deleted_at);

-- Stok Keluar Barang Medis
CREATE TABLE IF NOT EXISTS sik.stok_keluar_barang_medis (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    no_keluar VARCHAR(20) NOT NULL,
    id_barang_medis UUID NOT NULL,
    id_pegawai UUID NOT NULL, 
    tanggal_stok_keluar DATE NOT NULL DEFAULT CURRENT_DATE,
    jumlah_keluar INT NOT NULL,
    keterangan VARCHAR(255), 
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    deleted_at TIMESTAMP WITH TIME ZONE,
    updater UUID, 
    FOREIGN KEY (id_pegawai) REFERENCES pegawai (id),
    FOREIGN KEY (updater) REFERENCES akun (id)
);

CREATE INDEX IF NOT EXISTS idx_stok_keluar_barang_medis_tanggal_stok_keluar ON stok_keluar_barang_medis (tanggal_stok_keluar);
CREATE INDEX IF NOT EXISTS idx_stok_keluar_barang_medis_id_pegawai ON stok_keluar_barang_medis (id_pegawai);
CREATE INDEX IF NOT EXISTS idx_stok_keluar_barang_medis_updated_at ON stok_keluar_barang_medis (updated_at);
CREATE INDEX IF NOT EXISTS idx_stok_keluar_barang_medis_deleted_at ON stok_keluar_barang_medis (deleted_at);
