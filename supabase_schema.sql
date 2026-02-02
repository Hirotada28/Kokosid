-- Kokosid Supabase Database Schema
-- エンドツーエンド暗号化対応のPostgreSQLスキーマ

-- ==================== Users Table ====================

CREATE TABLE IF NOT EXISTS users (
    id BIGSERIAL PRIMARY KEY,
    uuid TEXT NOT NULL UNIQUE,
    auth_user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    name TEXT,
    timezone TEXT DEFAULT 'Asia/Tokyo',
    onboarding_completed BOOLEAN DEFAULT FALSE,
    preferred_language TEXT DEFAULT 'ja',
    notifications_enabled BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    last_active_at TIMESTAMPTZ,
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    CONSTRAINT users_uuid_auth_user_id_key UNIQUE (uuid, auth_user_id)
);

-- インデックス
CREATE INDEX IF NOT EXISTS idx_users_uuid ON users(uuid);
CREATE INDEX IF NOT EXISTS idx_users_auth_user_id ON users(auth_user_id);

-- Row Level Security (RLS)
ALTER TABLE users ENABLE ROW LEVEL SECURITY;

-- ユーザーは自分のデータのみアクセス可能
CREATE POLICY "Users can view their own data"
    ON users FOR SELECT
    USING (auth.uid() = auth_user_id);

CREATE POLICY "Users can insert their own data"
    ON users FOR INSERT
    WITH CHECK (auth.uid() = auth_user_id);

CREATE POLICY "Users can update their own data"
    ON users FOR UPDATE
    USING (auth.uid() = auth_user_id)
    WITH CHECK (auth.uid() = auth_user_id);

CREATE POLICY "Users can delete their own data"
    ON users FOR DELETE
    USING (auth.uid() = auth_user_id);

-- ==================== Tasks Table ====================

CREATE TABLE IF NOT EXISTS tasks (
    id BIGSERIAL PRIMARY KEY,
    uuid TEXT NOT NULL UNIQUE,
    user_uuid TEXT NOT NULL,
    auth_user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    encrypted_title TEXT NOT NULL,
    encrypted_description TEXT,
    original_task_uuid TEXT,
    is_micro_task BOOLEAN DEFAULT FALSE,
    estimated_minutes INTEGER,
    encrypted_context TEXT,
    completed_at TIMESTAMPTZ,
    due_date TIMESTAMPTZ,
    priority TEXT DEFAULT 'medium',
    status TEXT DEFAULT 'pending',
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    CONSTRAINT tasks_uuid_auth_user_id_key UNIQUE (uuid, auth_user_id)
);

-- インデックス
CREATE INDEX IF NOT EXISTS idx_tasks_uuid ON tasks(uuid);
CREATE INDEX IF NOT EXISTS idx_tasks_user_uuid ON tasks(user_uuid);
CREATE INDEX IF NOT EXISTS idx_tasks_auth_user_id ON tasks(auth_user_id);
CREATE INDEX IF NOT EXISTS idx_tasks_status ON tasks(status);
CREATE INDEX IF NOT EXISTS idx_tasks_completed_at ON tasks(completed_at);
CREATE INDEX IF NOT EXISTS idx_tasks_created_at ON tasks(created_at);

-- Row Level Security (RLS)
ALTER TABLE tasks ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can view their own tasks"
    ON tasks FOR SELECT
    USING (auth.uid() = auth_user_id);

CREATE POLICY "Users can insert their own tasks"
    ON tasks FOR INSERT
    WITH CHECK (auth.uid() = auth_user_id);

CREATE POLICY "Users can update their own tasks"
    ON tasks FOR UPDATE
    USING (auth.uid() = auth_user_id)
    WITH CHECK (auth.uid() = auth_user_id);

CREATE POLICY "Users can delete their own tasks"
    ON tasks FOR DELETE
    USING (auth.uid() = auth_user_id);

-- ==================== Journal Entries Table ====================

CREATE TABLE IF NOT EXISTS journal_entries (
    id BIGSERIAL PRIMARY KEY,
    uuid TEXT NOT NULL UNIQUE,
    user_uuid TEXT NOT NULL,
    auth_user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    encrypted_content TEXT,
    audio_url TEXT,
    transcription TEXT,
    emotion_detected TEXT,
    emotion_confidence DOUBLE PRECISION,
    ai_reflection TEXT,
    encrypted_ai_response TEXT,
    is_encrypted BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    synced_at TIMESTAMPTZ,
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    CONSTRAINT journal_entries_uuid_auth_user_id_key UNIQUE (uuid, auth_user_id)
);

-- インデックス
CREATE INDEX IF NOT EXISTS idx_journal_entries_uuid ON journal_entries(uuid);
CREATE INDEX IF NOT EXISTS idx_journal_entries_user_uuid ON journal_entries(user_uuid);
CREATE INDEX IF NOT EXISTS idx_journal_entries_auth_user_id ON journal_entries(auth_user_id);
CREATE INDEX IF NOT EXISTS idx_journal_entries_created_at ON journal_entries(created_at);
CREATE INDEX IF NOT EXISTS idx_journal_entries_emotion_detected ON journal_entries(emotion_detected);

-- Row Level Security (RLS)
ALTER TABLE journal_entries ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can view their own journal entries"
    ON journal_entries FOR SELECT
    USING (auth.uid() = auth_user_id);

CREATE POLICY "Users can insert their own journal entries"
    ON journal_entries FOR INSERT
    WITH CHECK (auth.uid() = auth_user_id);

CREATE POLICY "Users can update their own journal entries"
    ON journal_entries FOR UPDATE
    USING (auth.uid() = auth_user_id)
    WITH CHECK (auth.uid() = auth_user_id);

CREATE POLICY "Users can delete their own journal entries"
    ON journal_entries FOR DELETE
    USING (auth.uid() = auth_user_id);

-- ==================== Self Esteem Scores Table ====================

CREATE TABLE IF NOT EXISTS self_esteem_scores (
    id BIGSERIAL PRIMARY KEY,
    uuid TEXT NOT NULL UNIQUE,
    user_uuid TEXT NOT NULL,
    auth_user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    score DOUBLE PRECISION NOT NULL,
    calculation_basis_json TEXT,
    completion_rate DOUBLE PRECISION,
    positive_emotion_ratio DOUBLE PRECISION,
    streak_score DOUBLE PRECISION,
    engagement_score DOUBLE PRECISION,
    measured_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    CONSTRAINT self_esteem_scores_uuid_auth_user_id_key UNIQUE (uuid, auth_user_id)
);

-- インデックス
CREATE INDEX IF NOT EXISTS idx_self_esteem_scores_uuid ON self_esteem_scores(uuid);
CREATE INDEX IF NOT EXISTS idx_self_esteem_scores_user_uuid ON self_esteem_scores(user_uuid);
CREATE INDEX IF NOT EXISTS idx_self_esteem_scores_auth_user_id ON self_esteem_scores(auth_user_id);
CREATE INDEX IF NOT EXISTS idx_self_esteem_scores_measured_at ON self_esteem_scores(measured_at);

-- Row Level Security (RLS)
ALTER TABLE self_esteem_scores ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can view their own scores"
    ON self_esteem_scores FOR SELECT
    USING (auth.uid() = auth_user_id);

CREATE POLICY "Users can insert their own scores"
    ON self_esteem_scores FOR INSERT
    WITH CHECK (auth.uid() = auth_user_id);

CREATE POLICY "Users can update their own scores"
    ON self_esteem_scores FOR UPDATE
    USING (auth.uid() = auth_user_id)
    WITH CHECK (auth.uid() = auth_user_id);

CREATE POLICY "Users can delete their own scores"
    ON self_esteem_scores FOR DELETE
    USING (auth.uid() = auth_user_id);

-- ==================== Deletion Requests Table ====================

CREATE TABLE IF NOT EXISTS deletion_requests (
    id BIGSERIAL PRIMARY KEY,
    user_uuid TEXT NOT NULL,
    auth_user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    requested_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    scheduled_deletion_at TIMESTAMPTZ NOT NULL,
    status TEXT DEFAULT 'pending',
    completed_at TIMESTAMPTZ,
    CONSTRAINT deletion_requests_user_uuid_auth_user_id_key UNIQUE (user_uuid, auth_user_id)
);

-- インデックス
CREATE INDEX IF NOT EXISTS idx_deletion_requests_user_uuid ON deletion_requests(user_uuid);
CREATE INDEX IF NOT EXISTS idx_deletion_requests_auth_user_id ON deletion_requests(auth_user_id);
CREATE INDEX IF NOT EXISTS idx_deletion_requests_status ON deletion_requests(status);
CREATE INDEX IF NOT EXISTS idx_deletion_requests_scheduled_deletion_at ON deletion_requests(scheduled_deletion_at);

-- Row Level Security (RLS)
ALTER TABLE deletion_requests ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can view their own deletion requests"
    ON deletion_requests FOR SELECT
    USING (auth.uid() = auth_user_id);

CREATE POLICY "Users can insert their own deletion requests"
    ON deletion_requests FOR INSERT
    WITH CHECK (auth.uid() = auth_user_id);

-- ==================== Triggers ====================

-- updated_at自動更新トリガー関数
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- 各テーブルにトリガーを設定
CREATE TRIGGER update_users_updated_at
    BEFORE UPDATE ON users
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_tasks_updated_at
    BEFORE UPDATE ON tasks
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_journal_entries_updated_at
    BEFORE UPDATE ON journal_entries
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_self_esteem_scores_updated_at
    BEFORE UPDATE ON self_esteem_scores
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

-- ==================== Functions ====================

-- 削除リクエストの自動処理関数
CREATE OR REPLACE FUNCTION process_deletion_requests()
RETURNS void AS $$
BEGIN
    -- 30日経過した削除リクエストを処理
    UPDATE deletion_requests
    SET status = 'completed',
        completed_at = NOW()
    WHERE status = 'pending'
    AND scheduled_deletion_at <= NOW();
    
    -- 完了した削除リクエストに対応するデータを削除
    DELETE FROM tasks
    WHERE user_uuid IN (
        SELECT user_uuid FROM deletion_requests
        WHERE status = 'completed'
    );
    
    DELETE FROM journal_entries
    WHERE user_uuid IN (
        SELECT user_uuid FROM deletion_requests
        WHERE status = 'completed'
    );
    
    DELETE FROM self_esteem_scores
    WHERE user_uuid IN (
        SELECT user_uuid FROM deletion_requests
        WHERE status = 'completed'
    );
    
    DELETE FROM users
    WHERE uuid IN (
        SELECT user_uuid FROM deletion_requests
        WHERE status = 'completed'
    );
END;
$$ LANGUAGE plpgsql;

-- ==================== Comments ====================

COMMENT ON TABLE users IS 'ユーザー情報テーブル';
COMMENT ON TABLE tasks IS 'タスク情報テーブル（エンドツーエンド暗号化）';
COMMENT ON TABLE journal_entries IS '日記エントリテーブル（エンドツーエンド暗号化）';
COMMENT ON TABLE self_esteem_scores IS '自己肯定感スコアテーブル';
COMMENT ON TABLE deletion_requests IS 'アカウント削除リクエストテーブル（GDPR準拠）';

COMMENT ON COLUMN tasks.encrypted_title IS 'AES-256で暗号化されたタスクタイトル';
COMMENT ON COLUMN tasks.encrypted_description IS 'AES-256で暗号化されたタスク説明';
COMMENT ON COLUMN journal_entries.encrypted_content IS 'AES-256で暗号化された日記内容';
COMMENT ON COLUMN journal_entries.encrypted_ai_response IS 'AES-256で暗号化されたAI応答';
