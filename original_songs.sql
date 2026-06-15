-- 데레의 오리지널 곡 (SOOP VOD)
CREATE TABLE IF NOT EXISTS original_songs (
  id BIGSERIAL PRIMARY KEY,
  title TEXT NOT NULL,
  vod_id TEXT,
  thumbnail TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW()
);
ALTER TABLE original_songs ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS "all original_songs" ON original_songs;
CREATE POLICY "all original_songs" ON original_songs FOR ALL USING (true) WITH CHECK (true);
