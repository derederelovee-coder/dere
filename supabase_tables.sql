-- =============================================
-- 리데레 팬페이지 Supabase 테이블 생성 SQL
-- Supabase → SQL Editor에 전체 복붙 후 실행!
-- =============================================

-- ── 1. 일정(schedule) 테이블 ──
CREATE TABLE IF NOT EXISTS schedule (
  id         BIGSERIAL PRIMARY KEY,
  title      TEXT NOT NULL,
  date       DATE NOT NULL,
  time       TEXT,
  type       TEXT DEFAULT '일반',   -- 일반 / 특별 / 콜라보 / 휴방
  note       TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- ── 2. 노래(song) 테이블 ──
CREATE TABLE IF NOT EXISTS song (
  id         BIGSERIAL PRIMARY KEY,
  title      TEXT NOT NULL,
  artist     TEXT NOT NULL,
  genre      TEXT,
  sung_date  DATE,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- ── 3. 업보(work) 테이블 ──
CREATE TABLE IF NOT EXISTS work (
  id          BIGSERIAL PRIMARY KEY,
  title       TEXT NOT NULL,
  description TEXT,
  category    TEXT,
  event_date  DATE,
  created_at  TIMESTAMPTZ DEFAULT NOW()
);

-- ── 공개 읽기(RLS) 설정 ──
-- 방문자는 읽기만, 쓰기는 anon key로 제어
ALTER TABLE schedule ENABLE ROW LEVEL SECURITY;
ALTER TABLE song     ENABLE ROW LEVEL SECURITY;
ALTER TABLE work     ENABLE ROW LEVEL SECURITY;

-- 누구나 읽기 가능
CREATE POLICY "public read schedule" ON schedule FOR SELECT USING (true);
CREATE POLICY "public read song"     ON song     FOR SELECT USING (true);
CREATE POLICY "public read work"     ON work     FOR SELECT USING (true);

-- anon 키로 삽입/삭제 가능 (관리자 페이지용)
CREATE POLICY "anon insert schedule" ON schedule FOR INSERT WITH CHECK (true);
CREATE POLICY "anon delete schedule" ON schedule FOR DELETE USING (true);
CREATE POLICY "anon insert song"     ON song     FOR INSERT WITH CHECK (true);
CREATE POLICY "anon delete song"     ON song     FOR DELETE USING (true);
CREATE POLICY "anon insert work"     ON work     FOR INSERT WITH CHECK (true);
CREATE POLICY "anon delete work"     ON work     FOR DELETE USING (true);

-- ── 샘플 데이터 (선택사항) ──
INSERT INTO schedule (title, date, time, type, note) VALUES
  ('첫 방송 기념 노래방', '2026-06-20', '오후 8시', '특별', '구독자 선곡 받아요!'),
  ('주간 게임 방송', '2026-06-23', '오후 9시', '일반', NULL);

INSERT INTO song (title, artist, genre, sung_date) VALUES
  ('밤편지', '아이유', '발라드', '2026-06-01'),
  ('봄날', 'BTS', '발라드', '2026-06-01'),
  ('사랑하기 때문에', '유재하', '발라드', '2026-06-05');

INSERT INTO work (title, description, category, event_date) VALUES
  ('방송 중 고양이 乱入', '방송 중 고양이가 키보드 위에 올라와 채팅창 도배함', '동물', '2026-06-10'),
  ('게임 보스한테 30분 털림', '초보자 구간에서 30분 동안 같은 보스한테 계속 패배', '게임', '2026-06-12');

-- ── 4. 프로필(profile) 테이블 ──
-- 메인 페이지 전체 프로필을 JSONB 한 칸(id=1)에 저장
CREATE TABLE IF NOT EXISTS profile (
  id         BIGINT PRIMARY KEY,
  data       JSONB NOT NULL DEFAULT '{}'::jsonb,
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

ALTER TABLE profile ENABLE ROW LEVEL SECURITY;

-- 누구나 읽기 (메인 페이지에서 불러오기 위해 필수)
CREATE POLICY "public read profile"   ON profile FOR SELECT USING (true);
-- anon 키로 저장(업서트) 가능 (관리자 페이지용)
CREATE POLICY "anon insert profile"   ON profile FOR INSERT WITH CHECK (true);
CREATE POLICY "anon update profile"   ON profile FOR UPDATE USING (true) WITH CHECK (true);

-- ── 5. 공지·일기 이미지 컬럼 추가 ──
-- (이미 테이블이 있으면 컬럼만 추가됨)
ALTER TABLE notice ADD COLUMN IF NOT EXISTS image_url TEXT;
ALTER TABLE diary  ADD COLUMN IF NOT EXISTS image_url TEXT;
