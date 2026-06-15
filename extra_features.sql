-- =============================================
-- 추가 기능: 문의 / 댓글 / 여러 이미지
-- Supabase SQL Editor에서 한 번 실행
-- =============================================

-- 문의함
CREATE TABLE IF NOT EXISTS inquiries (
  id BIGSERIAL PRIMARY KEY,
  nickname TEXT,
  message TEXT NOT NULL,
  created_at TIMESTAMPTZ DEFAULT NOW()
);
ALTER TABLE inquiries ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS "all inquiries" ON inquiries;
CREATE POLICY "all inquiries" ON inquiries FOR ALL USING (true) WITH CHECK (true);

-- 일기 댓글
CREATE TABLE IF NOT EXISTS comments (
  id BIGSERIAL PRIMARY KEY,
  diary_id BIGINT NOT NULL,
  nickname TEXT,
  message TEXT NOT NULL,
  created_at TIMESTAMPTZ DEFAULT NOW()
);
ALTER TABLE comments ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS "all comments" ON comments;
CREATE POLICY "all comments" ON comments FOR ALL USING (true) WITH CHECK (true);

-- 공지/일기 여러 이미지 (JSON 배열)
ALTER TABLE notice ADD COLUMN IF NOT EXISTS images JSONB DEFAULT '[]'::jsonb;
ALTER TABLE diary  ADD COLUMN IF NOT EXISTS images JSONB DEFAULT '[]'::jsonb;
