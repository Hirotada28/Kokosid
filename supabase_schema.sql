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


-- ==================== Monetization System Schema ====================
-- 収益化システム用のテーブル定義

-- ==================== Subscriptions Table ====================

CREATE TABLE IF NOT EXISTS subscriptions (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id BIGINT NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    auth_user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    plan TEXT NOT NULL CHECK (plan IN ('free', 'pro')),
    status TEXT NOT NULL CHECK (status IN ('none', 'active', 'cancelled', 'expired', 'gracePeriod')),
    start_date TIMESTAMPTZ NOT NULL,
    end_date TIMESTAMPTZ,
    next_renewal_date TIMESTAMPTZ,
    cancelled_at TIMESTAMPTZ,
    grace_period_end TIMESTAMPTZ,
    platform_product_id TEXT,
    platform_transaction_id TEXT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- インデックス
CREATE INDEX IF NOT EXISTS idx_subscriptions_user_id ON subscriptions(user_id);
CREATE INDEX IF NOT EXISTS idx_subscriptions_auth_user_id ON subscriptions(auth_user_id);
CREATE INDEX IF NOT EXISTS idx_subscriptions_status ON subscriptions(status);
CREATE INDEX IF NOT EXISTS idx_subscriptions_next_renewal_date ON subscriptions(next_renewal_date);

-- Row Level Security (RLS)
ALTER TABLE subscriptions ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can view their own subscriptions"
    ON subscriptions FOR SELECT
    USING (auth.uid() = auth_user_id);

CREATE POLICY "Users can insert their own subscriptions"
    ON subscriptions FOR INSERT
    WITH CHECK (auth.uid() = auth_user_id);

CREATE POLICY "Users can update their own subscriptions"
    ON subscriptions FOR UPDATE
    USING (auth.uid() = auth_user_id)
    WITH CHECK (auth.uid() = auth_user_id);

-- ==================== Gem Transactions Table ====================

CREATE TABLE IF NOT EXISTS gem_transactions (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id BIGINT NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    auth_user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    transaction_id TEXT NOT NULL UNIQUE,
    type TEXT NOT NULL CHECK (type IN ('grant', 'consume', 'stake', 'return', 'forfeit', 'expire')),
    amount INTEGER NOT NULL,
    source TEXT NOT NULL CHECK (source IN ('purchase', 'subscription', 'promotion', 'refund')),
    reason TEXT,
    related_entity_id TEXT,
    expiry_date TIMESTAMPTZ,
    timestamp TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- インデックス
CREATE INDEX IF NOT EXISTS idx_gem_transactions_user_id ON gem_transactions(user_id);
CREATE INDEX IF NOT EXISTS idx_gem_transactions_auth_user_id ON gem_transactions(auth_user_id);
CREATE INDEX IF NOT EXISTS idx_gem_transactions_timestamp ON gem_transactions(timestamp);
CREATE INDEX IF NOT EXISTS idx_gem_transactions_expiry_date ON gem_transactions(expiry_date);
CREATE INDEX IF NOT EXISTS idx_gem_transactions_type ON gem_transactions(type);

-- Row Level Security (RLS)
ALTER TABLE gem_transactions ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can view their own gem transactions"
    ON gem_transactions FOR SELECT
    USING (auth.uid() = auth_user_id);

CREATE POLICY "Users can insert their own gem transactions"
    ON gem_transactions FOR INSERT
    WITH CHECK (auth.uid() = auth_user_id);

-- ==================== Commitment Tasks Table ====================

CREATE TABLE IF NOT EXISTS commitment_tasks (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    task_id TEXT NOT NULL,
    user_id BIGINT NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    auth_user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    staked_gems INTEGER NOT NULL CHECK (staked_gems IN (1, 3, 5)),
    companion_level TEXT NOT NULL CHECK (companion_level IN ('none', 'quiet', 'moderate', 'intensive')),
    status TEXT NOT NULL CHECK (status IN ('pending', 'inProgress', 'completed', 'failed')),
    pre_execution_support_at TIMESTAMPTZ,
    mid_execution_support_at TIMESTAMPTZ,
    post_execution_support_at TIMESTAMPTZ,
    completed_at TIMESTAMPTZ,
    achievement_score DOUBLE PRECISION,
    score_multiplier DOUBLE PRECISION,
    honesty_bonus DOUBLE PRECISION,
    failed_at TIMESTAMPTZ,
    was_honest_failure BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- インデックス
CREATE INDEX IF NOT EXISTS idx_commitment_tasks_task_id ON commitment_tasks(task_id);
CREATE INDEX IF NOT EXISTS idx_commitment_tasks_user_id ON commitment_tasks(user_id);
CREATE INDEX IF NOT EXISTS idx_commitment_tasks_auth_user_id ON commitment_tasks(auth_user_id);
CREATE INDEX IF NOT EXISTS idx_commitment_tasks_status ON commitment_tasks(status);
CREATE INDEX IF NOT EXISTS idx_commitment_tasks_created_at ON commitment_tasks(created_at);

-- Row Level Security (RLS)
ALTER TABLE commitment_tasks ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can view their own commitment tasks"
    ON commitment_tasks FOR SELECT
    USING (auth.uid() = auth_user_id);

CREATE POLICY "Users can insert their own commitment tasks"
    ON commitment_tasks FOR INSERT
    WITH CHECK (auth.uid() = auth_user_id);

CREATE POLICY "Users can update their own commitment tasks"
    ON commitment_tasks FOR UPDATE
    USING (auth.uid() = auth_user_id)
    WITH CHECK (auth.uid() = auth_user_id);

-- ==================== Golden Successes Table ====================

CREATE TABLE IF NOT EXISTS golden_successes (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id BIGINT NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    auth_user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    task_id TEXT NOT NULL,
    task_title TEXT NOT NULL,
    task_description TEXT,
    staked_gems INTEGER NOT NULL DEFAULT 5,
    achievement_score DOUBLE PRECISION NOT NULL,
    emotion_at_completion TEXT,
    encrypted_companion_log TEXT,
    encrypted_reflection TEXT,
    achieved_at TIMESTAMPTZ NOT NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- インデックス
CREATE INDEX IF NOT EXISTS idx_golden_successes_user_id ON golden_successes(user_id);
CREATE INDEX IF NOT EXISTS idx_golden_successes_auth_user_id ON golden_successes(auth_user_id);
CREATE INDEX IF NOT EXISTS idx_golden_successes_achieved_at ON golden_successes(achieved_at);
CREATE INDEX IF NOT EXISTS idx_golden_successes_task_id ON golden_successes(task_id);

-- Row Level Security (RLS)
ALTER TABLE golden_successes ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can view their own golden successes"
    ON golden_successes FOR SELECT
    USING (auth.uid() = auth_user_id);

CREATE POLICY "Users can insert their own golden successes"
    ON golden_successes FOR INSERT
    WITH CHECK (auth.uid() = auth_user_id);

CREATE POLICY "Users can update their own golden successes"
    ON golden_successes FOR UPDATE
    USING (auth.uid() = auth_user_id)
    WITH CHECK (auth.uid() = auth_user_id);

-- ==================== Honesty Scores Table ====================

CREATE TABLE IF NOT EXISTS honesty_scores (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id BIGINT NOT NULL REFERENCES users(id) ON DELETE CASCADE UNIQUE,
    auth_user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    current_score INTEGER NOT NULL DEFAULT 50 CHECK (current_score >= 0 AND current_score <= 100),
    history_json TEXT NOT NULL DEFAULT '[]',
    last_updated TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- インデックス
CREATE INDEX IF NOT EXISTS idx_honesty_scores_user_id ON honesty_scores(user_id);
CREATE INDEX IF NOT EXISTS idx_honesty_scores_auth_user_id ON honesty_scores(auth_user_id);

-- Row Level Security (RLS)
ALTER TABLE honesty_scores ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can view their own honesty scores"
    ON honesty_scores FOR SELECT
    USING (auth.uid() = auth_user_id);

CREATE POLICY "Users can insert their own honesty scores"
    ON honesty_scores FOR INSERT
    WITH CHECK (auth.uid() = auth_user_id);

CREATE POLICY "Users can update their own honesty scores"
    ON honesty_scores FOR UPDATE
    USING (auth.uid() = auth_user_id)
    WITH CHECK (auth.uid() = auth_user_id);

-- ==================== Salvage Sessions Table ====================

CREATE TABLE IF NOT EXISTS salvage_sessions (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    session_id TEXT NOT NULL UNIQUE,
    user_id BIGINT NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    auth_user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    task_id TEXT NOT NULL,
    encrypted_content TEXT NOT NULL,
    status TEXT NOT NULL CHECK (status IN ('inProgress', 'completed', 'abandoned')),
    started_at TIMESTAMPTZ NOT NULL,
    completed_at TIMESTAMPTZ,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- インデックス
CREATE INDEX IF NOT EXISTS idx_salvage_sessions_user_id ON salvage_sessions(user_id);
CREATE INDEX IF NOT EXISTS idx_salvage_sessions_auth_user_id ON salvage_sessions(auth_user_id);
CREATE INDEX IF NOT EXISTS idx_salvage_sessions_started_at ON salvage_sessions(started_at);
CREATE INDEX IF NOT EXISTS idx_salvage_sessions_status ON salvage_sessions(status);
CREATE INDEX IF NOT EXISTS idx_salvage_sessions_session_id ON salvage_sessions(session_id);

-- Row Level Security (RLS)
ALTER TABLE salvage_sessions ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can view their own salvage sessions"
    ON salvage_sessions FOR SELECT
    USING (auth.uid() = auth_user_id);

CREATE POLICY "Users can insert their own salvage sessions"
    ON salvage_sessions FOR INSERT
    WITH CHECK (auth.uid() = auth_user_id);

CREATE POLICY "Users can update their own salvage sessions"
    ON salvage_sessions FOR UPDATE
    USING (auth.uid() = auth_user_id)
    WITH CHECK (auth.uid() = auth_user_id);

-- ==================== Payment Transactions Table ====================

CREATE TABLE IF NOT EXISTS payment_transactions (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id BIGINT NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    auth_user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    transaction_id TEXT NOT NULL UNIQUE,
    amount DECIMAL(10, 2) NOT NULL,
    currency TEXT NOT NULL DEFAULT 'JPY',
    type TEXT NOT NULL CHECK (type IN ('subscription', 'gem_purchase')),
    platform TEXT NOT NULL CHECK (platform IN ('ios', 'android', 'web')),
    platform_receipt TEXT,
    status TEXT NOT NULL CHECK (status IN ('pending', 'completed', 'failed', 'refunded')),
    timestamp TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- インデックス
CREATE INDEX IF NOT EXISTS idx_payment_transactions_user_id ON payment_transactions(user_id);
CREATE INDEX IF NOT EXISTS idx_payment_transactions_auth_user_id ON payment_transactions(auth_user_id);
CREATE INDEX IF NOT EXISTS idx_payment_transactions_timestamp ON payment_transactions(timestamp);
CREATE INDEX IF NOT EXISTS idx_payment_transactions_status ON payment_transactions(status);
CREATE INDEX IF NOT EXISTS idx_payment_transactions_transaction_id ON payment_transactions(transaction_id);

-- Row Level Security (RLS)
ALTER TABLE payment_transactions ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can view their own payment transactions"
    ON payment_transactions FOR SELECT
    USING (auth.uid() = auth_user_id);

CREATE POLICY "Users can insert their own payment transactions"
    ON payment_transactions FOR INSERT
    WITH CHECK (auth.uid() = auth_user_id);

-- ==================== Monetization Triggers ====================

-- subscriptionsテーブルのupdated_at自動更新
CREATE TRIGGER update_subscriptions_updated_at
    BEFORE UPDATE ON subscriptions
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

-- commitment_tasksテーブルのupdated_at自動更新
CREATE TRIGGER update_commitment_tasks_updated_at
    BEFORE UPDATE ON commitment_tasks
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

-- ==================== Monetization Functions ====================

-- ジェム残高を計算する関数
CREATE OR REPLACE FUNCTION calculate_gem_balance(p_user_id BIGINT)
RETURNS TABLE(
    available_gems INTEGER,
    pending_gems INTEGER,
    unlimited_gems INTEGER,
    earliest_expiry TIMESTAMPTZ
) AS $
DECLARE
    v_available INTEGER := 0;
    v_pending INTEGER := 0;
    v_unlimited INTEGER := 0;
    v_earliest TIMESTAMPTZ := NULL;
BEGIN
    -- 利用可能ジェム（有効期限内、ステークされていない）
    SELECT COALESCE(SUM(amount), 0)
    INTO v_available
    FROM gem_transactions
    WHERE user_id = p_user_id
    AND type IN ('grant', 'return')
    AND (expiry_date IS NULL OR expiry_date > NOW());
    
    -- 消費されたジェムを減算
    SELECT COALESCE(SUM(ABS(amount)), 0)
    INTO v_available
    FROM gem_transactions
    WHERE user_id = p_user_id
    AND type IN ('consume', 'forfeit', 'expire');
    
    v_available := v_available - COALESCE((
        SELECT SUM(ABS(amount))
        FROM gem_transactions
        WHERE user_id = p_user_id
        AND type IN ('consume', 'forfeit', 'expire')
    ), 0);
    
    -- ステーク中ジェム
    SELECT COALESCE(SUM(amount), 0)
    INTO v_pending
    FROM gem_transactions
    WHERE user_id = p_user_id
    AND type = 'stake'
    AND related_entity_id IN (
        SELECT task_id FROM commitment_tasks
        WHERE user_id = p_user_id
        AND status IN ('pending', 'inProgress')
    );
    
    -- 無期限ジェム
    SELECT COALESCE(SUM(amount), 0)
    INTO v_unlimited
    FROM gem_transactions
    WHERE user_id = p_user_id
    AND type = 'grant'
    AND source = 'subscription'
    AND expiry_date IS NULL;
    
    -- 最も早い有効期限
    SELECT MIN(expiry_date)
    INTO v_earliest
    FROM gem_transactions
    WHERE user_id = p_user_id
    AND expiry_date IS NOT NULL
    AND expiry_date > NOW();
    
    RETURN QUERY SELECT v_available, v_pending, v_unlimited, v_earliest;
END;
$ LANGUAGE plpgsql;

-- 期限切れジェムを削除する関数
CREATE OR REPLACE FUNCTION expire_old_gems()
RETURNS void AS $
BEGIN
    -- 期限切れジェムにexpireトランザクションを作成
    INSERT INTO gem_transactions (
        user_id,
        auth_user_id,
        transaction_id,
        type,
        amount,
        source,
        reason,
        timestamp
    )
    SELECT
        gt.user_id,
        gt.auth_user_id,
        'expire_' || gt.transaction_id,
        'expire',
        -gt.amount,
        gt.source,
        'Expired gems',
        NOW()
    FROM gem_transactions gt
    WHERE gt.type = 'grant'
    AND gt.expiry_date IS NOT NULL
    AND gt.expiry_date <= NOW()
    AND NOT EXISTS (
        SELECT 1 FROM gem_transactions gt2
        WHERE gt2.related_entity_id = gt.transaction_id
        AND gt2.type = 'expire'
    );
END;
$ LANGUAGE plpgsql;

-- 月次サルベージカウントをリセットする関数
CREATE OR REPLACE FUNCTION reset_monthly_salvage_counts()
RETURNS void AS $
BEGIN
    -- この関数は月初に実行される想定
    -- 実際のカウントはアプリケーション側で管理
    -- ここでは古いセッションのクリーンアップのみ実行
    UPDATE salvage_sessions
    SET status = 'abandoned'
    WHERE status = 'inProgress'
    AND started_at < NOW() - INTERVAL '7 days';
END;
$ LANGUAGE plpgsql;

-- ==================== Monetization Comments ====================

COMMENT ON TABLE subscriptions IS 'サブスクリプション情報テーブル';
COMMENT ON TABLE gem_transactions IS 'ジェムトランザクション履歴テーブル';
COMMENT ON TABLE commitment_tasks IS '本気モードタスクテーブル';
COMMENT ON TABLE golden_successes IS '黄金の成功体験アーカイブテーブル（E2E暗号化）';
COMMENT ON TABLE honesty_scores IS '誠実性スコアテーブル';
COMMENT ON TABLE salvage_sessions IS 'サルベージセッションテーブル（E2E暗号化）';
COMMENT ON TABLE payment_transactions IS '決済トランザクションテーブル（7年間保存）';

COMMENT ON COLUMN golden_successes.encrypted_companion_log IS 'AES-256で暗号化されたAI伴走ログ';
COMMENT ON COLUMN golden_successes.encrypted_reflection IS 'AES-256で暗号化されたユーザー振り返り';
COMMENT ON COLUMN salvage_sessions.encrypted_content IS 'AES-256で暗号化されたセッション内容';
