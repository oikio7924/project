-- DAEYANG dm-web 전용 테이블 (공사현황 / 설정 — 기존 dy_* 테이블은 그대로 사용)
-- 적용: mysql -u root -p monitering < db/schema.sql

SET NAMES utf8mb4;

-- 공사현황 실무담당자
CREATE TABLE IF NOT EXISTS dm_construction_contacts (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  code VARCHAR(32) NOT NULL,
  name VARCHAR(50) NOT NULL,
  dept VARCHAR(100) NOT NULL DEFAULT '',
  position VARCHAR(50) NOT NULL DEFAULT '',
  phone VARCHAR(30) NOT NULL DEFAULT '',
  sort_order INT NOT NULL DEFAULT 0,
  UNIQUE KEY uk_dm_construction_contacts_code (code)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 공사현황 (site_id = dy_power_plant.DPP_KEYNO)
CREATE TABLE IF NOT EXISTS dm_construction (
  site_id INT UNSIGNED NOT NULL PRIMARY KEY,
  current_step TINYINT UNSIGNED NOT NULL DEFAULT 1,
  operator_business VARCHAR(255) NOT NULL DEFAULT '',
  operator_address VARCHAR(500) NOT NULL DEFAULT '',
  operator_phone VARCHAR(30) NOT NULL DEFAULT '',
  operator_email VARCHAR(255) NOT NULL DEFAULT '',
  permit_plant_name VARCHAR(255) NOT NULL DEFAULT '',
  permit_capacity VARCHAR(50) NOT NULL DEFAULT '',
  permit_location VARCHAR(255) NOT NULL DEFAULT '',
  permit_install_type VARCHAR(50) NOT NULL DEFAULT '',
  permit_received_at DATE NULL,
  permit_expected_at DATE NULL,
  selected_contact_id INT UNSIGNED NULL,
  updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 설정 (지도 API 키 등 dm-web 전용)
CREATE TABLE IF NOT EXISTS dm_settings (
  setting_key VARCHAR(64) NOT NULL PRIMARY KEY,
  setting_value TEXT NULL,
  updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
