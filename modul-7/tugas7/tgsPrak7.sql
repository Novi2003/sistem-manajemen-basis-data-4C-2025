CREATE DATABASE tugasprak7;

USE tugasprak7;

DROP DATABASE tugasprak7;

SHOW TABLES;

CREATE TABLE siswa(
	id_siswa INT PRIMARY KEY,
	nama_lengkap VARCHAR(50) NOT NULL,
	tanggal_lahir DATE NOT NULL,
	jenis_kelamin ENUM('laki-laki', 'perempuan') NOT NULL,
	alamat VARCHAR(50) NOT NULL,
	no_hp VARCHAR(50) NOT NULL,
	email VARCHAR(100) NOT NULL
);

CREATE TABLE kelas(
	id_kelas VARCHAR(10) PRIMARY KEY,
	nama_kelas VARCHAR(50) NOT NULL,
	tingkatan INT NOT NULL,
	jurusan VARCHAR(50) NOT NULL
);

CREATE TABLE pendaftaran(
	id_pendaftaran INT PRIMARY KEY,
	id_siswa INT NOT NULL,
	tanggal_daftar DATE NOT NULL,
	status_pendaftaran ENUM('diterima', 'tidak diterima') NOT NULL,
	FOREIGN KEY (id_siswa) REFERENCES siswa (id_siswa)
);

CREATE TABLE pembayaran(
	id_pembayaran INT PRIMARY KEY,
	id_pendaftaran INT NOT NULL,
	tanggal_bayar DATE NOT NULL,
	jumlah DECIMAL(10, 2) NOT NULL,
	metode_pembayaran VARCHAR(50) NOT NULL,
	status_pembayaran ENUM('berhasil','gagal') NOT NULL,
	FOREIGN KEY (id_pendaftaran) REFERENCES pendaftaran (id_pendaftaran)
);

CREATE TABLE penempatan_kelas(
	id_penempatan VARCHAR(10) PRIMARY KEY,
	id_siswa INT NOT NULL,
	id_kelas VARCHAR(10) NOT NULL,
	tanggal_penempatan DATE NOT NULL,
	FOREIGN KEY (id_siswa) REFERENCES siswa (id_siswa),
	FOREIGN KEY (id_kelas) REFERENCES kelas (id_kelas)
);

INSERT INTO siswa VALUES
	(206612, 'siti aini', '2003-10-12', 'perempuan', 'waru', '085940075787', 'aini@gmail.com'),
	(206687, 'ahmad alghazali', '2005-10-17', 'laki-laki', 'pakong', '083123924456', 'ahmdalgha@gmail.com'),
	(206613, 'zehroh', '2003-05-23', 'perempuan', 'pamekasan', '082964246567', 'zehroh@gmail.com');


INSERT INTO kelas VALUES
	(001, 'X ips 2',10, 'ips'),
	(002, 'XI ipa 3', 11, 'ipa'),
	(003, 'XII bhs 1', 12, 'bhs');
	

INSERT INTO pendaftaran VALUES
	(123, 206612, '2016-06-20', 'diterima'),
	(162, 206687, '2016-06-12', 'diterima'),
	(178, 206613, '2016-06-25', 'tidak diterima');
	
INSERT INTO pembayaran VALUES
	(2, 123, '2016-06-22', 150000, 'tunai', 'berhasil'),
	(5, 162, '2016-06-17', 150000, 'transfer', 'gagal'),
	(3, 178, '2016-06-25', 150000, 'tunai', 'berhasil');
	
INSERT INTO penempatan_kelas VALUES
	('M11', 206612, 001, '2016-07-05'),
	('M12', 206687, 002, '2016-07-05'),
	('M13', 206613, 003, '2016-07-05');

SELECT * FROM siswa;
SELECT * FROM kelas;
SELECT * FROM pendaftaran;
SELECT * FROM pembayaran;
SELECT * FROM penempatan_kelas;

#1 
-- cek noHp before insert
DELIMITER //
CREATE TRIGGER cek_panjang_nohp
BEFORE INSERT ON siswa
FOR EACH ROW
BEGIN
    IF NEW.no_hp REGEXP '[^0-9]' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 
        'Nomor HP hanya boleh mengandung angka.';
    END IF;
END //

INSERT INTO siswa VALUES
	(206617, 'novi', '2003-10-03', 'perempuan', 'pmk', '085890f54237', 'novi@gmail.com');

-- status pendaftaran tidak boleh null before update
DELIMITER //
CREATE TRIGGER before_update_pendaftaran
BEFORE UPDATE ON pendaftaran
FOR EACH ROW
BEGIN
    IF NEW.status_pendaftaran IS NULL THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Status pendaftaran tidak boleh NULL.';
    END IF;
END;
//
DELIMITER ;

UPDATE pendaftaran
SET status_pendaftaran = NULL
WHERE id_pendaftaran = 123;

-- tidak bisa hapus siswa yg sdh di tetapkan kelasnya
DELIMITER //
CREATE TRIGGER before_delete_siswa
BEFORE DELETE ON siswa
FOR EACH ROW
BEGIN
    IF EXISTS (
        SELECT 1 FROM penempatan_kelas
        WHERE id_siswa = OLD.id_siswa
    ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Siswa tidak dapat dihapus karena sudah ditempatkan di kelas.';
    END IF;
END;
//
DELIMITER ;
DELETE FROM siswa WHERE id_siswa= 206612;

#2
-- after insert(di after ke tabel sendiri)
DELIMITER //
CREATE TRIGGER after_insert_siswa
AFTER INSERT ON siswa
FOR EACH ROW
BEGIN
	INSERT INTO pendaftaran VALUES
	(2,new.id_siswa,CURDATE(),status_pendaftaran);
END //

DROP TRIGGER after_insert_siswa;

INSERT INTO siswa VALUES
	(206650, 'bb', '2023-11-04', 'laki-laki', 'krajan', '085236893456', 'bb@gmail.com');

SELECT * FROM siswa;
SELECT * FROM pendaftaran;

-- after update
CREATE TABLE log_pendaftaran (
    id_log INT AUTO_INCREMENT PRIMARY KEY,
    id_pendaftaran INT,
    status_lama VARCHAR(20),
    status_baru VARCHAR(20),
    waktu_log DATETIME
);
DELIMITER //
CREATE TRIGGER after_update_pendaftaran
AFTER UPDATE ON pendaftaran
FOR EACH ROW
BEGIN
    IF OLD.status_pendaftaran <> NEW.status_pendaftaran THEN
        INSERT INTO log_pendaftaran (id_pendaftaran, status_lama, status_baru, waktu_log)
        VALUES (NEW.id_pendaftaran, OLD.status_pendaftaran, NEW.status_pendaftaran, NOW());
    END IF;
END;
//
DELIMITER ;
UPDATE pendaftaran
SET status_pendaftaran = 'tidak diterima'
WHERE id_pendaftaran = 1;


SELECT * FROM pendaftaran;
SELECT NOW();

-- after delete
CREATE TABLE log_pendaftaran_terhapus (
    id_log INT AUTO_INCREMENT PRIMARY KEY,
    id_pendaftaran INT,
    id_siswa INT,
    tanggal_daftar DATE,
    status_pendaftaran VARCHAR(20),
    waktu_penghapusan DATETIME
);
DELIMITER //
CREATE TRIGGER after_delete_pendaftaran
AFTER DELETE ON pendaftaran
FOR EACH ROW
BEGIN
    INSERT INTO log_pendaftaran_terhapus (
        id_pendaftaran,
        id_siswa,
        tanggal_daftar,
        status_pendaftaran,
        waktu_penghapusan
    ) VALUES (
        OLD.id_pendaftaran,
        OLD.id_siswa,
        OLD.tanggal_daftar,
        OLD.status_pendaftaran,
        NOW()
    );
END //
DELIMITER ;
DELETE FROM pendaftaran WHERE id_pendaftaran = 1;

SELECT * FROM pendaftaran;
