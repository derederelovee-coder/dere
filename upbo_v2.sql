-- =============================================
-- 리데레 업보 시스템 v2 (시청자 / 타입 / 카운트)
-- Supabase → SQL Editor → 전체 실행
-- 기존 work 테이블은 더 이상 안 쓰지만 지우진 않음 (남겨둬도 무방)
-- =============================================

-- 시청자
CREATE TABLE IF NOT EXISTS viewers (
  id         BIGSERIAL PRIMARY KEY,
  nickname   TEXT NOT NULL,
  soop_id    TEXT,
  memo       TEXT,
  sort_order INT DEFAULT 0,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- 업보 타입(종류)
CREATE TABLE IF NOT EXISTS upbo_types (
  id         BIGSERIAL PRIMARY KEY,
  name       TEXT NOT NULL,
  category   TEXT DEFAULT '일반',   -- '일반' 또는 '이벤트'
  sort_order INT DEFAULT 0,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- 시청자별 업보 카운트 (시청자 × 타입 = 횟수)
CREATE TABLE IF NOT EXISTS upbo_counts (
  id         BIGSERIAL PRIMARY KEY,
  viewer_id  BIGINT NOT NULL,
  type_id    BIGINT NOT NULL,
  count      INT DEFAULT 0,
  updated_at TIMESTAMPTZ DEFAULT NOW(),
  UNIQUE (viewer_id, type_id)
);

-- RLS
ALTER TABLE viewers     ENABLE ROW LEVEL SECURITY;
ALTER TABLE upbo_types  ENABLE ROW LEVEL SECURITY;
ALTER TABLE upbo_counts ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "all viewers" ON viewers;
DROP POLICY IF EXISTS "all types" ON upbo_types;
DROP POLICY IF EXISTS "all counts" ON upbo_counts;
CREATE POLICY "all viewers"  ON viewers     FOR ALL USING (true) WITH CHECK (true);
CREATE POLICY "all types"    ON upbo_types  FOR ALL USING (true) WITH CHECK (true);
CREATE POLICY "all counts"   ON upbo_counts FOR ALL USING (true) WITH CHECK (true);
