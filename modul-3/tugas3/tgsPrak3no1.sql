CREATE DATABASE tugasprak3no1;

USE tugasprak3no1;

#1 nambah namausaha dan jumlah karyawan
DELIMITER //
CREATE PROCEDURE AddUMKM(
	IN u_umkm VARCHAR(200), 
	IN u_karyawan INT)
BEGIN
	INSERT INTO umkm(nama_usaha, jumlah_karyawan)
	VALUES (u_umkm, u_karyawan);
END//
DELIMITER ;

CALL AddUMKM('Pecel Lele Pak Kumis', 5);
CALL AddUMKM('Kopi Senja Subang', 3);
CALL AddUMKM('Batik Cirebon Klasik', 10);
CALL AddUMKM('Keripik Pisang Lembang', 7);
CALL AddUMKM('Tas Rajut Garut', 4);
SELECT nama_usaha, jumlah_karyawan FROM umkm;


#2memperbarui nama kategori
DELIMITER //
CREATE PROCEDURE UpdateKategoriUMKM(
    IN p_id_kategori INT,
    IN p_nama_baru VARCHAR(100)
)
BEGIN
    UPDATE kategori_umkm
    SET nama_kategori = p_nama_baru
    WHERE id_kategori = p_id_kategori;
END //
DELIMITER ;
CALL UpdateKategoriUMKM(6, 'ikan laut');
SELECT * FROM Kategori_UMKM;

#3menghapus DATA berdasarkan id
DELIMITER //
CREATE PROCEDURE DeletePemilikUMKM(
	IN p_id_pemilik INT)
BEGIN
  -- Memperbarui data di tabel umkm jika id_pemilik yang akan dihapus ada
  UPDATE umkm SET id_pemilik = NULL WHERE id_pemilik = p_id_pemilik;
  -- Menghapus data dari tabel pemilik_umkm berdasarkan id_pemilik
  DELETE FROM pemilik_umkm WHERE id_pemilik = p_id_pemilik;
END //
DELIMITER ;
CALL DeletePemilikUMKM(3);
SELECT * FROM pemilik_umkm;

DROP PROCEDURE DeletePemilikUMKM;

#4menambahkan produk dengan menerima parameter id,nama,harga
DELIMITER //
CREATE PROCEDURE AddProduk(
  IN p_id_umkm INT, 
  IN p_nama_produk VARCHAR(200), 
  IN p_harga DECIMAL(15,0)
)
BEGIN
  INSERT INTO produk_umkm(id_umkm, nama_produk, harga)
  VALUES (p_id_umkm, p_nama_produk, p_harga);
END //
DELIMITER ;
CALL AddProduk(4, 'pastel keju', 25000);
SELECT id_umkm, nama_produk, harga FROM produk_umkm;

#5 menerima parameter id dan mengembalikan DATA sesuai id yg diberikan OUT
DELIMITER //
CREATE PROCEDURE GetUMKMByID(
  IN p_id_umkm INT,
  OUT p_nama_usaha VARCHAR(200),
  OUT p_alamat_usaha VARCHAR(255)
)
BEGIN
  SELECT nama_usaha, alamat_usaha
  INTO p_nama_usaha, p_alamat_usaha
  FROM umkm
  WHERE id_umkm = p_id_umkm;
END //
DELIMITER ;
CALL GetUMKMByID(8,@nama, @alamat);
SELECT @nama AS nama_usaha, @alamat AS alamat_usaha;