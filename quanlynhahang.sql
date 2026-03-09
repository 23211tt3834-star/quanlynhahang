CREATE DATABASE quan_ly_nha_hang;
GO

USE quan_ly_nha_hang;
GO

-- 3. Bảng Loại món ăn
CREATE TABLE loai_mon (
    id INT IDENTITY(1,1) PRIMARY KEY,
    ten_loai NVARCHAR(100) NOT NULL,
    mo_ta NVARCHAR(MAX)
);
GO

-- 4. Bảng Món ăn
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

-- 5. Bảng Nhân viên
CREATE TABLE nhan_vien (
    id INT IDENTITY(1,1) PRIMARY KEY,
    ho_ten NVARCHAR(150) NOT NULL,
    vi_tri NVARCHAR(50),
    so_dien_thoai VARCHAR(20),
    email VARCHAR(100),
    ngay_vao_lam DATE
);
GO

-- 6. Bảng Bàn
CREATE TABLE ban (
    id INT IDENTITY(1,1) PRIMARY KEY,
    so_ban VARCHAR(20) NOT NULL UNIQUE,
    so_ghe INT NOT NULL,
    trang_thai NVARCHAR(50) DEFAULT N'Trống'
);
GO

-- 7. Bảng Đơn hàng
CREATE TABLE don_hang (
    id INT IDENTITY(1,1) PRIMARY KEY,
    ban_id INT,
    nhan_vien_id INT,
    trang_thai_don NVARCHAR(50) DEFAULT N'Chờ xử lý',
    tong_tien DECIMAL(18, 0) DEFAULT 0,
    thoi_gian_tao DATETIME DEFAULT GETDATE(), -- Dùng GETDATE() thay cho CURRENT_TIMESTAMP
    CONSTRAINT FK_DonHang_Ban FOREIGN KEY (ban_id) 
        REFERENCES ban(id) ON DELETE SET NULL,
    CONSTRAINT FK_DonHang_NhanVien FOREIGN KEY (nhan_vien_id) 
        REFERENCES nhan_vien(id) ON DELETE SET NULL
);
GO

-- 8. Bảng Chi tiết đơn hàng
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

-- 9. Bảng Thanh toán
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

-- 10. Bảng Đánh giá
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