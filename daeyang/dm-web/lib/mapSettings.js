/**
 * 맵 API 키 — DB(dm_settings) 우선, 없으면 .env
 */
const MAP_KEYS = {
  google: "map_google_key",
  naver: "map_naver_key",
  kakao: "map_kakao_key",
};

async function ensureSettingsTable(db) {
  await db.execute(
    "CREATE TABLE IF NOT EXISTS dm_settings (" +
      "setting_key VARCHAR(64) NOT NULL PRIMARY KEY," +
      "setting_value TEXT NULL," +
      "updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP" +
      ") ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci"
  );
}

async function getSetting(db, key) {
  const [rows] = await db.execute("SELECT setting_value FROM dm_settings WHERE setting_key = ? LIMIT 1", [key]);
  return rows.length ? String(rows[0].setting_value || "") : "";
}

async function setSetting(db, key, value) {
  await db.execute(
    "INSERT INTO dm_settings (setting_key, setting_value) VALUES (?,?) ON DUPLICATE KEY UPDATE setting_value = VALUES(setting_value)",
    [key, value || ""]
  );
}

function fromEnv() {
  return {
    google: process.env.GOOGLE_MAP_KEY || process.env.MAP_GOOGLE_KEY || "",
    naver: process.env.NAVER_MAP_KEY || process.env.MAP_NAVER_KEY || "",
    kakao: process.env.KAKAO_MAP_KEY || process.env.DAUM_MAP_KEY || process.env.MAP_KAKAO_KEY || "",
  };
}

async function getMapKeys(db) {
  const env = fromEnv();
  if (!db) return env;
  const google = await getSetting(db, MAP_KEYS.google);
  const naver = await getSetting(db, MAP_KEYS.naver);
  const kakao = await getSetting(db, MAP_KEYS.kakao);
  return {
    google: google || env.google,
    naver: naver || env.naver,
    kakao: kakao || env.kakao,
  };
}

async function saveMapKeys(db, keys) {
  await setSetting(db, MAP_KEYS.google, keys.google || "");
  await setSetting(db, MAP_KEYS.naver, keys.naver || "");
  await setSetting(db, MAP_KEYS.kakao, keys.kakao || "");
}

async function seedMapKeysFromEnv(db) {
  await ensureSettingsTable(db);
  const env = fromEnv();
  if (env.google && !(await getSetting(db, MAP_KEYS.google))) await setSetting(db, MAP_KEYS.google, env.google);
  if (env.naver && !(await getSetting(db, MAP_KEYS.naver))) await setSetting(db, MAP_KEYS.naver, env.naver);
  if (env.kakao && !(await getSetting(db, MAP_KEYS.kakao))) await setSetting(db, MAP_KEYS.kakao, env.kakao);
}

module.exports = {
  MAP_KEYS,
  ensureSettingsTable,
  getMapKeys,
  saveMapKeys,
  seedMapKeysFromEnv,
  fromEnv,
};
