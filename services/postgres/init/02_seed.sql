-- ============================================
-- SeaShop — Seed Data
-- ============================================
-- Chạy sau khi Prisma migrate tạo xong schema

-- Admin account mặc định
-- Email: admin@seashop.vn
-- Password: Admin@123 (bcrypt hash, rounds=10)
-- QUAN TRỌNG: Đổi password ngay sau khi deploy!
INSERT INTO users (id, email, password_hash, full_name, role, is_active, created_at, updated_at)
VALUES (
  uuid_generate_v4(),
  'admin@seashop.vn',
  '$2b$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi',
  'Admin SeaShop',
  'ADMIN',
  true,
  NOW(),
  NOW()
) ON CONFLICT (email) DO NOTHING;

-- Categories mặc định
INSERT INTO categories (id, name, slug, description, is_active, sort_order, created_at)
VALUES
  (uuid_generate_v4(), 'Tôm', 'tom', 'Các loại tôm tươi', true, 1, NOW()),
  (uuid_generate_v4(), 'Cá', 'ca', 'Các loại cá tươi', true, 2, NOW()),
  (uuid_generate_v4(), 'Mực & Bạch tuộc', 'muc-bach-tuoc', 'Mực, bạch tuộc tươi', true, 3, NOW()),
  (uuid_generate_v4(), 'Cua & Ghẹ', 'cua-ghe', 'Cua, ghẹ sống', true, 4, NOW()),
  (uuid_generate_v4(), 'Hàu & Sò', 'hau-so', 'Hàu, sò, nghêu tươi', true, 5, NOW()),
  (uuid_generate_v4(), 'Khô & Chế biến', 'kho-che-bien', 'Hải sản khô, chế biến sẵn', true, 6, NOW())
ON CONFLICT (slug) DO NOTHING;
