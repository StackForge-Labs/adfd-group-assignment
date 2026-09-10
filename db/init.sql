-- ADFD06 — schema + dữ liệu mẫu cho Contact.
-- Chuyển từ script SQL Server của thầy sang MySQL:
--   int identity  →  INT AUTO_INCREMENT
--   go            →  bỏ (chỉ là phân cách batch của SSMS, MySQL không có)
--   varchar       →  giữ nguyên, thêm charset utf8mb4 để lưu được tiếng Việt

CREATE DATABASE IF NOT EXISTS adfddb
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;

USE adfddb;

CREATE TABLE IF NOT EXISTS contacts (
  id      INT AUTO_INCREMENT PRIMARY KEY,
  name    VARCHAR(100) NOT NULL,
  email   VARCHAR(150),
  phone   VARCHAR(20)  NOT NULL,
  address VARCHAR(255)
) ENGINE = InnoDB;

-- Chỉ seed khi bảng còn rỗng, để chạy lại script không sinh dữ liệu trùng.
INSERT INTO contacts (name, email, phone, address)
SELECT * FROM (
  SELECT 'John Smith'    AS name, 'john@gmail.com'    AS email, '0901000001' AS phone, 'District 1, Ho Chi Minh City'    AS address
  UNION ALL SELECT 'Emily Johnson',  'emily@gmail.com',   '0901000002', 'District 3, Ho Chi Minh City'
  UNION ALL SELECT 'Michael Brown',  'michael@gmail.com', '0901000003', 'Thu Duc City, Ho Chi Minh City'
  UNION ALL SELECT 'Sarah Wilson',   'sarah@gmail.com',   '0901000004', 'Bien Hoa City, Dong Nai'
  UNION ALL SELECT 'David Miller',   'david@gmail.com',   '0901000005', 'Long Thanh, Dong Nai'
) AS seed
WHERE NOT EXISTS (SELECT 1 FROM contacts);

SELECT * FROM contacts;
