CREATE DATABASE tugasprak3no2;

USE tugasprak3no2;

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
	(5, 162, '2016-06-17', 150000, 'transfer', 'gagal'),
	(3, 178, '2016-06-25', 150000, 'tunai', 'berhasil');

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
	
SELECT * FROM siswa;
SELECT * FROM kelas;
SELECT * FROM pendaftaran;
SELECT * FROM pembayaran;
SELECT * FROM penempatan_kelas;

#1
DELIMITER //

CREATE PROCEDURE UpdateDataMaster(
    IN p_id INT,
    IN p_nilai_baru VARCHAR(50),
    OUT p_status VARCHAR(100)
)
BEGIN
    DECLARE v_cek INT;
    
    SELECT COUNT(*) INTO v_cek FROM siswa WHERE id_siswa = p_id;
    
    IF v_cek > 0 THEN
        UPDATE siswa SET nama_lengkap = p_nilai_baru WHERE id_siswa = p_id;
        SET p_status = 'Update berhasil';
    ELSE
        SET p_status = 'ID tidak ditemukan';
    END IF;
END //

DELIMITER ;
CALL UpdateDataMaster ('206609', @status);
SELECT * FROM siswa;


DROP PROCEDURE UpdateDataMaster;

#2
DELIMITER //

CREATE PROCEDURE CountTransaksi(
    OUT total_transaksi INT
)
BEGIN
    SELECT COUNT(*) INTO total_transaksi FROM pembayaran;
END //

DELIMITER ;
CALL CountTransaksi(@total);
SELECT @total AS total_transaksi;


#3
DELIMITER //

CREATE PROCEDURE GetDataMasterByID(
    IN p_id INT,
    OUT p_nama_lengkap VARCHAR(50),
    OUT p_email VARCHAR(100)
)
BEGIN
    SELECT nama_lengkap, email 
    INTO p_nama_lengkap, p_email
    FROM siswa
    WHERE id_siswa = p_id;
END //

DELIMITER ;
CALL GetDataMasterByID(206612, @nama_lengkap, @email);
SELECT @nama_lengkap AS nama_lengkap, @email AS email;


#4
DELIMITER //

CREATE PROCEDURE UpdateFieldTransaksi(
    IN p_id INT,
    INOUT p_metode VARCHAR(50),
    INOUT p_status VARCHAR(20)
)
BEGIN
    DECLARE v_metode_lama VARCHAR(50);
    DECLARE v_status_lama ENUM('berhasil','gagal');

    SELECT metode_pembayaran, status_pembayaran 
    INTO v_metode_lama, v_status_lama
    FROM pembayaran
    WHERE id_pembayaran = p_id;

    IF p_metode IS NULL OR p_metode = '' THEN
        SET p_metode = v_metode_lama;
    END IF;

    IF p_status IS NULL OR p_status = '' THEN
        SET p_status = v_status_lama;
    END IF;

    UPDATE pembayaran
    SET metode_pembayaran = p_metode,
        status_pembayaran = p_status
    WHERE id_pembayaran = p_id;
END //

DELIMITER ;
CALL UpdateFieldTransaksi(123, @metode, @status);
SELECT @metode AS metode_pembayaran, @status AS status_pembayaran;


#5
DELIMITER //

CREATE PROCEDURE DeleteEntriesByIDMaster(
    IN p_id INT
)
BEGIN
    DELETE FROM siswa WHERE id_siswa = p_id;
END //

DELIMITER ;
CALL DeleteEntriesByIDMaster(206612);
SELECT * FROM siswa;
