CREATE DATABASE quanlynhahang;
GO

USE quanlynhahang;
GO

-- Bảng Loại món ăn
CREATE TABLE loai_mon (
    id INT IDENTITY(1,1) PRIMARY KEY,
    ten_loai NVARCHAR(100) NOT NULL,
    mo_ta NVARCHAR(MAX)
);
GO

-- Bảng Món ăn
CREATE TABLE mon_an (
    id INT IDENTITY(1,1) PRIMARY KEY,
    loai_mon_id INT NOT NULL,
    ten_mon NVARCHAR(200) NOT NULL,
    mo_ta NVARCHAR(MAX),
    gia_ban DECIMAL(18, 0) NOT NULL,
    hinh_anh NVARCHAR(255),
    trang_thai_ban BIT DEFAULT 1, -- 1 là đang bán, 0 là ngừng bán
    CONSTRAINT FK_MonAn_LoaiMon FOREIGN KEY (loai_mon_id) 
        REFERENCES loai_mon(id) ON DELETE CASCADE
);
GO

-- Bảng Nhân viên
CREATE TABLE nhan_vien (
    id INT IDENTITY(1,1) PRIMARY KEY,
    ho_ten NVARCHAR(150) NOT NULL,
    vi_tri NVARCHAR(50),
    so_dien_thoai VARCHAR(20),
    email VARCHAR(100),
    ngay_vao_lam DATE
);
GO

-- Bảng Bàn
CREATE TABLE ban (
    id INT IDENTITY(1,1) PRIMARY KEY,
    so_ban VARCHAR(20) NOT NULL UNIQUE,
    so_ghe INT NOT NULL,
    trang_thai NVARCHAR(50) DEFAULT N'Trống'
);
GO

-- Bảng Hạng thành viên
CREATE TABLE hang_thanh_vien (
    id INT IDENTITY(1,1) PRIMARY KEY,
    ten_hang NVARCHAR(50) NOT NULL,
    phan_tram_giam_gia INT DEFAULT 0,
    diem_toi_thieu INT DEFAULT 0
);
GO

-- Bảng Khách hàng
CREATE TABLE khach_hang (
    id INT IDENTITY(1,1) PRIMARY KEY,
    ten_khach_hang NVARCHAR(255) NOT NULL,
    so_dien_thoai VARCHAR(20) UNIQUE NOT NULL,
    diem_tich_luy INT DEFAULT 0,
    hang_thanh_vien_id INT,
    CONSTRAINT FK_KhachHang_HangThanhVien FOREIGN KEY (hang_thanh_vien_id) 
        REFERENCES hang_thanh_vien(id) ON DELETE SET NULL
);
GO
-- Bảng Đơn hàng
CREATE TABLE don_hang (
    id INT IDENTITY(1,1) PRIMARY KEY,
    ban_id INT,
    nhan_vien_id INT,
    khach_hang_id INT, -- CỘT MỚI THÊM
    trang_thai_don NVARCHAR(50) DEFAULT N'Chờ xử lý',
    tong_tien DECIMAL(18, 0) DEFAULT 0,
    thoi_gian_tao DATETIME DEFAULT GETDATE(),
    CONSTRAINT FK_DonHang_Ban FOREIGN KEY (ban_id) 
        REFERENCES ban(id) ON DELETE SET NULL,
    CONSTRAINT FK_DonHang_NhanVien FOREIGN KEY (nhan_vien_id) 
        REFERENCES nhan_vien(id) ON DELETE SET NULL,
    CONSTRAINT FK_DonHang_KhachHang FOREIGN KEY (khach_hang_id)
        REFERENCES khach_hang(id) ON DELETE SET NULL
);
GO

-- Bảng Chi tiết đơn hàng
CREATE TABLE chi_tiet_don_hang (
    id INT IDENTITY(1,1) PRIMARY KEY,
    don_hang_id INT NOT NULL,
    mon_an_id INT NOT NULL,
    so_luong INT NOT NULL,
    gia_luc_ban DECIMAL(18, 0) NOT NULL,
    ghi_chu NVARCHAR(255),
    CONSTRAINT FK_CTDH_DonHang FOREIGN KEY (don_hang_id) 
        REFERENCES don_hang(id) ON DELETE CASCADE,
    CONSTRAINT FK_CTDH_MonAn FOREIGN KEY (mon_an_id) 
        REFERENCES mon_an(id) ON DELETE CASCADE
);
GO

-- Bảng Thanh toán
CREATE TABLE thanh_toan (
    id INT IDENTITY(1,1) PRIMARY KEY,
    don_hang_id INT NOT NULL UNIQUE,
    phuong_thuc NVARCHAR(50),
    trang_thai_thanh_toan NVARCHAR(50) DEFAULT N'Chưa thanh toán',
    thoi_gian_thanh_toan DATETIME,
    CONSTRAINT FK_ThanhToan_DonHang FOREIGN KEY (don_hang_id) 
        REFERENCES don_hang(id) ON DELETE CASCADE
);
GO

-- Bảng Đánh giá
CREATE TABLE danh_gia (
    id INT IDENTITY(1,1) PRIMARY KEY,
    mon_an_id INT NOT NULL,
    ten_khach_hang NVARCHAR(100),
    diem_danh_gia INT CHECK (diem_danh_gia BETWEEN 1 AND 5),
    noi_dung NVARCHAR(MAX),
    thoi_gian_tao DATETIME DEFAULT GETDATE(),
    CONSTRAINT FK_DanhGia_MonAn FOREIGN KEY (mon_an_id) 
        REFERENCES mon_an(id) ON DELETE CASCADE
);
GO

CREATE TABLE dat_ban (
    id INT IDENTITY(1,1) PRIMARY KEY,
	ban_id INT NULL,
    ten_khach_hang NVARCHAR(150) NOT NULL,
    so_dien_thoai VARCHAR(20) NOT NULL,
    ngay_dat DATE NOT NULL,
    gio_dat TIME NOT NULL,
    so_nguoi INT NOT NULL,
    ghi_chu NVARCHAR(MAX) NULL,
    tong_tien_coc DECIMAL(18,0) DEFAULT 0,
    trang_thai VARCHAR(50) DEFAULT 'ChoXacNhan', -- ChoXacNhan, DaCoc, HoanThanh, DaHuy
    thoi_gian_tao DATETIME DEFAULT GETDATE()
	CONSTRAINT FK_DatBan_Ban FOREIGN KEY (ban_id) 
        REFERENCES ban(id) ON DELETE SET NULL,
);
GO


GO

-- 1. LOẠI MÓN ĂN (loai_mon)
INSERT INTO loai_mon (ten_loai, mo_ta) VALUES
(N'Khai Vị', N'Các món ăn nhẹ kích thích vị giác đầu bữa'),
(N'Món Chính', N'Các món ăn no, cung cấp năng lượng chính'),
(N'Lẩu & Nướng', N'Các món lẩu và nướng tại bàn'),
(N'Nước Uống', N'Đồ uống có cồn và không cồn'),
(N'Tráng Miệng', N'Đồ ngọt, trái cây kết thúc bữa ăn');
GO

-- 2. MÓN ĂN (mon_an)
INSERT INTO mon_an (loai_mon_id, ten_mon, mo_ta, gia_ban, hinh_anh, trang_thai_ban) VALUES
(1, N'Súp Cua Bào Ngư', N'Súp cua tuyết nấu cùng bào ngư thượng hạng', 120000, 'sup_cua.jpg', 1),
(1, N'Salad Cá Hồi Sốt Chanh Dây', N'Cá hồi Na Uy tươi sống trộn salad rau mầm', 150000, 'salad_ca_hoi.jpg', 1),
(1, N'Gỏi Ngó Sen Tôm Thịt', N'Tôm sú và thịt ba chỉ bóp gỏi chua ngọt', 95000, 'goi_ngo_sen.jpg', 1),
(1, N'Chả Giò Hải Sản Sốt Mayonnaise', N'Chả giò chiên giòn nhân tôm mực', 85000, 'cha_gio.jpg', 1),
(2, N'Bò Bít Tết Sốt Tiêu Đen', N'Thịt thăn bò Úc nướng kèm khoai tây', 250000, 'bo_bit_tet.jpg', 1),
(2, N'Cá Hồi Áp Chảo Măng Tây', N'Cá hồi phi lê áp chảo bơ tỏi', 220000, 'ca_hoi_ap_chao.jpg', 1),
(2, N'Tôm Hùm Nướng Phô Mai', N'Tôm hùm baby nướng phô mai kéo sợi', 350000, 'tom_hum.jpg', 1),
(2, N'Gà Quay Da Giòn', N'Gà ta quay lu da giòn rụm', 180000, 'ga_quay.jpg', 1),
(2, N'Cua Rang Me', N'Cua biển thịt chắc xào sốt me chua ngọt', 280000, 'cua_rang_me.jpg', 1),
(2, N'Cơm Chiên Hải Sản Lá É', N'Cơm chiên tôm mực thơm lừng vị lá é', 110000, 'com_chien.jpg', 1),
(3, N'Lẩu Thái Tomyum Hải Sản', N'Lẩu chua cay chuẩn vị Thái Lan', 350000, 'lau_thai.jpg', 1),
(3, N'Lẩu Gà Lá Giang', N'Lẩu gà ta nấu lá giang chua thanh', 280000, 'lau_ga.jpg', 1),
(3, N'Sườn Heo Nướng Tảng BBQ', N'Sườn non nướng tảng khổng lồ', 320000, 'suon_nuong.jpg', 1),
(4, N'Rượu Vang Đỏ Chile', N'Chai 750ml, độ cồn 13.5%', 850000, 'vang_do.jpg', 1),
(4, N'Bia Heineken Xanh', N'Lon 330ml ướp lạnh', 35000, 'heineken.jpg', 1),
(4, N'Nước Ép Dưa Hấu', N'Nước ép trái cây tươi 100%', 45000, 'nuoc_ep.jpg', 1),
(4, N'Trà Đào Cam Sả', N'Trà thanh mát giải nhiệt', 50000, 'tra_dao.jpg', 1),
(5, N'Bánh Tiramisu Ý', N'Bánh ngọt kem phô mai cà phê', 65000, 'tiramisu.jpg', 1),
(5, N'Chè Khúc Bạch', N'Chè ngọt thanh, béo ngậy hạnh nhân', 45000, 'che_khuc_bach.jpg', 1),
(5, N'Trái Cây Thập Cẩm', N'Dưa hấu, xoài, thanh long, táo', 80000, 'trai_cay.jpg', 1);
GO

-- 3. NHÂN VIÊN (nhan_vien)
INSERT INTO nhan_vien (ho_ten, vi_tri, so_dien_thoai, email, ngay_vao_lam) VALUES
(N'Trần Đại C', N'Quản lý', '0900111222', 'quanly@nhahang.com', '2023-05-10'),
(N'Lê Đầu Bếp', N'Bếp trưởng', '0988777666', 'beptruong@nhahang.com', '2023-06-01'),
(N'Nguyễn Thị Phục Vụ', N'Nhân viên phục vụ', '0933444555', 'phucvu1@nhahang.com', '2024-01-15'),
(N'Phạm Văn Chạy Bàn', N'Nhân viên phục vụ', '0911222333', 'phucvu2@nhahang.com', '2024-02-20'),
(N'Hoàng Thu Ngân', N'Thu ngân', '0977888999', 'thungan@nhahang.com', '2023-11-05');
GO

-- 4. BÀN (ban)
INSERT INTO ban (so_ban, so_ghe, trang_thai) VALUES
('T1-01', 4, N'Trống'), ('T1-02', 4, N'Đang phục vụ'), ('T1-03', 6, N'Trống'),
('T2-01', 2, N'Đang phục vụ'), ('T2-02', 4, N'Đã đặt'), ('T2-03', 8, N'Trống'),
('VIP-1', 10, N'Đang phục vụ'), ('VIP-2', 12, N'Trống');
GO

-- 5. ĐƠN HÀNG (don_hang)
INSERT INTO don_hang (ban_id, nhan_vien_id, trang_thai_don, tong_tien, thoi_gian_tao) VALUES
(2, 3, N'Đã hoàn thành', 640000, '2024-03-09 18:30:00'), -- T1-02
(4, 4, N'Chờ xử lý', 390000, GETDATE()),               -- T2-01
(7, 3, N'Đang phục vụ', 1450000, GETDATE());            -- VIP-1
GO

-- 6. CHI TIẾT ĐƠN HÀNG (chi_tiet_don_hang)
INSERT INTO chi_tiet_don_hang (don_hang_id, mon_an_id, so_luong, gia_luc_ban, ghi_chu) VALUES
(1, 2, 2, 150000, N'Không bỏ hành'),
(1, 7, 1, 350000, N'Nướng chín kỹ'),
(2, 11, 1, 350000, N'Cay ít'),
(2, 16, 1, 40000, N'Ít đá'),
(3, 14, 1, 850000, N'Mở nắp sẵn'),
(3, 5, 2, 250000, N'Medium rare'),
(3, 1, 1, 100000, N'');
GO

-- 7. THANH TOÁN 
INSERT INTO thanh_toan (don_hang_id, phuong_thuc, trang_thai_thanh_toan, thoi_gian_thanh_toan) VALUES
(1, N'Chuyển khoản', N'Đã thanh toán', '2024-03-09 19:45:00');
GO

-- 8. ĐÁNH GIÁ (danh_gia)
INSERT INTO danh_gia (mon_an_id, ten_khach_hang, diem_danh_gia, noi_dung, thoi_gian_tao) VALUES
(5, N'Anh Tuấn', 5, N'Bò bít tết siêu mềm, sốt đậm đà, 10 điểm!', GETDATE()),
(11, N'Chị Thảo', 4, N'Lẩu Thái ngon nhưng hơi cay so với mình.', GETDATE()),
(7, N'Hải Đăng', 5, N'Tôm hùm phô mai béo ngậy, ăn đáng đồng tiền bát gạo.', GETDATE()),
(18, N'Ngọc Linh', 5, N'Tiramisu chuẩn vị Ý, không bị ngọt gắt, rất thích.', GETDATE()),
(1, N'Bác Hùng', 3, N'Súp cua hơi nguội khi mang ra bàn.', GETDATE());
GO

INSERT INTO dat_ban (ten_khach_hang, so_dien_thoai, ngay_dat, gio_dat, so_nguoi, ghi_chu, tong_tien_coc, trang_thai, thoi_gian_tao) VALUES
(N'Lê Thị Lan', '0901234567', '2026-03-20', '19:00:00', 2, N'Kỷ niệm ngày cưới, chuẩn bị giùm nến và hoa hồng. Xin xếp bàn góc tối lãng mạn.', 500000, 'DaCoc', GETDATE()),
(N'Trần Phan Trọng', '0988777666', '2026-03-18', '18:30:00', 15, N'Tiệc công ty, chuẩn bị sẵn 3 thùng Heineken ướp lạnh trước. Cần xuất hóa đơn VAT.', 2000000, 'DaCoc', GETDATE()),
(N'Nguyễn Thị Thanh Lịch', '0911222333', '2026-03-25', '11:30:00', 4, N'Gia đình có trẻ em, nhờ chuẩn bị 1 ghế em bé. Dị ứng đậu phộng.', 0, 'ChoXacNhan', GETDATE()),
(N'Phạm Sếp Tổng', '0999888777', '2026-03-22', '20:00:00', 8, N'Tiệc tiếp đối tác quan trọng. Vui lòng xếp phòng VIP-2.', 1000000, 'HoanThanh', '2026-03-10 14:00:00'),
(N'Hoàng Văn Thanh', '0933444555', '2026-03-19', '19:30:00', 6, N'Hủy do trời mưa ngập đường không đi được.', 0, 'DaHuy', '2026-03-15 09:00:00');
GO
--  HẠNG THÀNH VIÊN
INSERT INTO hang_thanh_vien (ten_hang, phan_tram_giam_gia, diem_toi_thieu) VALUES
(N'Đồng', 0, 0),
(N'Bạc', 5, 100),
(N'Vàng', 10, 500),
(N'Kim Cương', 15, 1000);
GO

--  KHÁCH HÀNG
INSERT INTO khach_hang (ten_khach_hang, so_dien_thoai, diem_tich_luy, hang_thanh_vien_id) VALUES
(N'Nguyễn Văn Khách VIP', '0999999999', 600, 3), -- Hạng Vàng
(N'Trần Thị Mới Quen', '0888888888', 150, 2), -- Hạng Bạc
(N'Lê Vãng Lai', '0777777777', 10, 1); -- Hạng Đồng
GO