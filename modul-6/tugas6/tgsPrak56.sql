CREATE DATABASE tugasprak56;

USE tugasprak56;

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

INSERT INTO siswa VALUES
	(206612, 'siti aini', '2003-10-12', 'perempuan', 'waru', '085940075787', 'aini@gmail.com'),
	(206687, 'ahmad alghazali', '2005-10-17', 'laki-laki', 'pakong', '083123924456', 'ahmdalgha@gmail.com'),
	(206613, 'zehroh', '2003-05-23', 'perempuan', 'pamekasan', '082964246567', 'zehroh@gmail.com');

CREATE TABLE kelas(
	id_kelas VARCHAR(10) PRIMARY KEY,
	nama_kelas VARCHAR(50) NOT NULL,
	tingkatan INT NOT NULL,
	jurusan VARCHAR(50) NOT NULL
);

INSERT INTO kelas VALUES
	(001, 'X ips 2',10, 'ips'),
	(002, 'XI ipa 3', 11, 'ipa'),
	(003, 'XII bhs 1', 12, 'bhs');
	

CREATE TABLE pendaftaran(
	id_pendaftaran INT PRIMARY KEY,
	id_siswa INT NOT NULL,
	tanggal_daftar DATE NOT NULL,
	status_pendaftaran ENUM('diterima', 'tidak diterima') NOT NULL,
	FOREIGN KEY (id_siswa) REFERENCES siswa (id_siswa)
);


INSERT INTO pendaftaran VALUES
	(123, 206612, '2016-06-20', 'diterima'),
	(162, 206687, '2016-06-12', 'diterima'),
	(178, 206613, '2016-06-25', 'tidak diterima');
	
INSERT INTO pendaftaran VALUES
	(125, 206616, '2025-09-12', 'diterima'),
	(156, 206698, '2023-10-03', 'tidak diterima'),
	(192, 206620, '2024-02-23', 'diterima'),
	(145, 206623, '2025-05-25', 'diterima');
	
SELECT * FROM pendaftaran;

CREATE TABLE pembayaran(
	id_pembayaran INT PRIMARY KEY,
	id_pendaftaran INT NOT NULL,
	tanggal_bayar DATE NOT NULL,
	jumlah DECIMAL(10, 2) NOT NULL,
	metode_pembayaran VARCHAR(50) NOT NULL,
	status_pembayaran ENUM('berhasil','gagal') NOT NULL,
	FOREIGN KEY (id_pendaftaran) REFERENCES pendaftaran (id_pendaftaran)
);

INSERT INTO pembayaran VALUES
	(2, 123, '2016-06-22', 150000, 'tunai', 'berhasil'),
	(3, 178, '2016-06-25', 150000, 'tunai', 'berhasil');
	
INSERT INTO pembayaran VALUES
	(4, 123, '2025-04-22', 150000, 'tunai', 'berhasil'),
	(8, 162, '2025-03-17', 150000, 'transfer', 'gagal'),
	(9, 178, '2025-05-25', 150000, 'tunai', 'berhasil');

CREATE TABLE penempatan_kelas(
	id_penempatan VARCHAR(10) PRIMARY KEY,
	id_siswa INT NOT NULL,
	id_kelas VARCHAR(10) NOT NULL,
	tanggal_penempatan DATE NOT NULL,
	FOREIGN KEY (id_siswa) REFERENCES siswa (id_siswa),
	FOREIGN KEY (id_kelas) REFERENCES kelas (id_kelas)
);

INSERT INTO penempatan_kelas VALUES
	('M11', 206612, 001, '2016-07-05'),
	('M12', 206687, 002, '2016-07-05'),
	('M13', 206613, 003, '2016-07-05');
	
CREATE TABLE spp (
    id_spp INT PRIMARY KEY,
    id_siswa INT NOT NULL,
    nominal DECIMAL(10,2) NOT NULL,
    tanggal_bayar DATE NOT NULL,
    FOREIGN KEY (id_siswa) REFERENCES siswa(id_siswa)
);    

DROP TABLE spp;

INSERT INTO spp VALUES
(1, 206612, 500000.00, '2024-01-10'),
(2, 206687, 500000.00, '2024-02-12'),
(3, 206613, 500000.00, '2024-03-15'),
(4, 206616, 500000.00, '2024-04-18'),
(5, 206698, 500000.00, '2024-05-20'),
(6, 206620, 500000.00, '2024-06-10'),
(7, 206623, 500000.00, '2024-07-01');
	
SELECT * FROM siswa;
SELECT * FROM kelas;
SELECT * FROM pendaftaran;
SELECT * FROM pembayaran;
SELECT * FROM penempatan_kelas;
SELECT * FROM spp;

INSERT INTO siswa VALUES
	(206616, 'novi', '2023-10-13', 'perempuan', 'jakarta', '085234987457', 'novi@gmail.com'),
	(206698, 'mila', '2024-07-10', 'perempuan', 'krajan', '081987346823', 'mila@gmail.com'),
	(206620, 'alif', '2022-11-04', 'laki-laki', 'bekasi', '083245876389', 'alif@gmail.com'),
	(206623, 'agus', '2025-05-30', 'laki-laki', 'bogor', '087345287954', 'agus@gmail.com');
	
SELECT * FROM siswa;

#1
DELIMITER //

CREATE PROCEDURE tampilkansiswa()
BEGIN
  SELECT * FROM pendaftaran
  WHERE tanggal_daftar < DATE(NOW() - INTERVAL 3 MONTH);
END //

DELIMITER ;

CALL tampilkansiswa;
DROP PROCEDURE tampilkansiswa;

#2
DELIMITER //

CREATE PROCEDURE hapusPembayaranLama()
BEGIN
  DELETE FROM pembayaran
  WHERE tanggal_bayar < DATE(CURRENT_TIMESTAMP - INTERVAL 1 YEAR)
    AND status_pembayaran = 'berhasil';
    
END //

DELIMITER ;
CALL hapusPembayaranLama;
SELECT * FROM pembayaran;

#3
DELIMITER //

CREATE PROCEDURE ubahStatuspendaftaran()
BEGIN
SELECT * FROM pendaftaran;
  UPDATE pendaftaran
  SET status_pendaftaran = 'diterima'
  WHERE status_pendaftaran = 'tidak diterima'
  ORDER BY tanggal_daftar;
END //

DELIMITER ;
CALL ubahStatuspendaftaran;

DROP PROCEDURE ubahStatuspendaftaran;

#4
DELIMITER //

CREATE PROCEDURE editEmailSiswa(
  IN sid INT,
  IN emailBaru VARCHAR(100)
)
BEGIN
  UPDATE siswa
  SET email = emailBaru
  WHERE id_siswa = sid
    AND NOT EXISTS (
      SELECT * FROM pendaftaran
      WHERE pendaftaran.id_siswa = siswa.id_siswa
    );
END //

DELIMITER ;
CALL editEmailSiswa(206698, 'jamilah@gmail.com');
SELECT * FROM siswa;
CALL editEmailSiswa(206623, 'novi_baru@gmail.com');
DROP PROCEDURE editEmailSiswa;


CREATE TABLE spp

#5


#6
DELIMITER //

CREATE PROCEDURE hitung_transaksi_berhasil()
BEGIN
    DECLARE total INT DEFAULT 0;
    DECLARE done INT DEFAULT FALSE;
    DECLARE cur CURSOR FOR 
        SELECT id_pembayaran FROM pembayaran 
        WHERE status_pembayaran = 'gagal'
        AND tanggal_bayar >= DATE_SUB(CURDATE(), INTERVAL 2 MONTH);
    
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

    OPEN cur;

    transaksi_loop: LOOP
        FETCH cur INTO total;
        IF done THEN
            LEAVE transaksi_loop;
        END IF;

        SET total = total + 1;
    END LOOP;

    CLOSE cur;

    SELECT CONCAT('Jumlah transaksi berhasil 1 bulan terakhir: ', total) AS hasil;
END //

DELIMITER ;
call hitung_transaksi_berhasil;
drop procedure hitung_transaksi_berhasil;


