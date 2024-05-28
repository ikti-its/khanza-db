-- Modul C (Fathur, Ruben)
-- Jadwal Pegawai
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

CREATE OR REPLACE FUNCTION update_jadwal_pegawai_on_delete(IN pegawai_id UUID)
RETURNS VOID AS $$
BEGIN
  UPDATE jadwal_pegawai
  SET deleted_at = CURRENT_TIMESTAMP
  WHERE id_pegawai = pegawai_id;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION trigger_update_jadwal_pegawai_on_delete()
RETURNS TRIGGER AS $$
BEGIN
    PERFORM update_jadwal_pegawai_on_delete(OLD.id);
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER init_jadwal_pegawai
AFTER INSERT ON pegawai
FOR EACH ROW
EXECUTE PROCEDURE trigger_init_jadwal_pegawai();

CREATE TRIGGER update_jadwal_pegawai_on_delete
BEFORE UPDATE ON pegawai
FOR EACH ROW
WHEN (OLD.deleted_at IS NULL AND NEW.deleted_at IS NOT NULL)
EXECUTE FUNCTION trigger_update_jadwal_pegawai_on_delete();

-- Modul D (Leo)
-- Persetujuan pengajuan
CREATE OR REPLACE FUNCTION update_status_pengajuan()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.status_apoteker = 'Ditolak' OR NEW.status_keuangan = 'Ditolak' THEN
    NEW.status := 'Ditolak';
ELSIF NEW.status_apoteker = 'Disetujui' AND NEW.status_keuangan = 'Disetujui' THEN
    NEW.status := 'Disetujui';
ELSE
    NEW.status := 'Menunggu Persetujuan';
END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_update_status_pengajuan
BEFORE INSERT OR UPDATE OF status_apoteker, status_keuangan ON persetujuan_pengajuan
FOR EACH ROW
EXECUTE FUNCTION update_status_pengajuan();

-- Status Pesanan Pengajuan
CREATE OR REPLACE FUNCTION update_status_pesanan()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.status = 'Disetujui' THEN
    UPDATE pengajuan_barang_medis
    SET status_pesanan = '2'
    WHERE id = NEW.id_pengajuan;
ELSIF NEW.status = 'Ditolak' THEN
    UPDATE pengajuan_barang_medis
    SET status_pesanan = '1'
    WHERE id = NEW.id_pengajuan;
ELSE
    UPDATE pengajuan_barang_medis
    SET status_pesanan = '0'
    WHERE id = NEW.id_pengajuan;
END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER update_status_trigger
AFTER UPDATE ON persetujuan_pengajuan
FOR EACH ROW
EXECUTE FUNCTION update_status_pesanan();
