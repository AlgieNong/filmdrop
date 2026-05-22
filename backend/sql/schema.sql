-- =============================================================================
-- FilmDrop / 映投 — Database Schema
-- MySQL 8.0+ | InnoDB | utf8mb4
-- =============================================================================

-- ---------------------------------------------------------------------------
-- 1. 字典表（TMDB 数据镜像，无需逻辑删除）
-- ---------------------------------------------------------------------------

CREATE TABLE genre (
    id          BIGINT AUTO_INCREMENT PRIMARY KEY,
    name        VARCHAR(50)  NOT NULL COMMENT '类型名称，如 Action, Comedy',
    tmdb_id     INT          NOT NULL COMMENT 'TMDB 类型 ID',
    created_at  DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at  DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    UNIQUE KEY uk_tmdb_id (tmdb_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
  COMMENT='电影类型字典（TMDB genre）';

CREATE TABLE keyword (
    id          BIGINT AUTO_INCREMENT PRIMARY KEY,
    name        VARCHAR(100) NOT NULL COMMENT '关键词名称',
    tmdb_id     INT          NOT NULL COMMENT 'TMDB keyword ID',
    created_at  DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at  DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    UNIQUE KEY uk_tmdb_id (tmdb_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
  COMMENT='电影关键词字典（TMDB keyword）';

CREATE TABLE person (
    id          BIGINT AUTO_INCREMENT PRIMARY KEY,
    name        VARCHAR(200) NOT NULL COMMENT '影人姓名',
    tmdb_id     INT          NOT NULL COMMENT 'TMDB person ID',
    created_at  DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at  DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    UNIQUE KEY uk_tmdb_id (tmdb_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
  COMMENT='影人字典（导演、演员等）';

-- ---------------------------------------------------------------------------
-- 2. 用户
-- ---------------------------------------------------------------------------

CREATE TABLE user (
    id              BIGINT AUTO_INCREMENT PRIMARY KEY,
    email           VARCHAR(255) NOT NULL COMMENT '邮箱（登录用）',
    phone           VARCHAR(20)  DEFAULT NULL COMMENT '手机号（登录用）',
    password_hash   VARCHAR(255) NOT NULL COMMENT '密码哈希',
    nickname        VARCHAR(50)  DEFAULT NULL COMMENT '昵称',
    status          VARCHAR(20)  NOT NULL DEFAULT 'ACTIVE' COMMENT '状态：ACTIVE / DISABLED',
    deleted         TINYINT(1)   NOT NULL DEFAULT 0 COMMENT '逻辑删除：0-正常，1-已删除',
    created_at      DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at      DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    UNIQUE KEY uk_email (email),
    UNIQUE KEY uk_phone (phone)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
  COMMENT='用户';

-- ---------------------------------------------------------------------------
-- 3. 画像
-- ---------------------------------------------------------------------------

CREATE TABLE persona (
    id                  BIGINT AUTO_INCREMENT PRIMARY KEY,
    name                VARCHAR(50)  NOT NULL COMMENT '画像名称',
    description         VARCHAR(500) NOT NULL COMMENT '画像描述',
    example_movie_ids   JSON         DEFAULT NULL COMMENT '示例电影 TMDB ID + 片名，纯展示用',
    is_active           TINYINT(1)   NOT NULL DEFAULT 1 COMMENT '是否启用',
    sort_order          INT          NOT NULL DEFAULT 0 COMMENT '排序（前端展示顺序）',
    deleted             TINYINT(1)   NOT NULL DEFAULT 0 COMMENT '逻辑删除：0-正常，1-已删除',
    created_at          DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at          DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
  COMMENT='画像定义';

CREATE TABLE persona_rule_condition (
    id              BIGINT AUTO_INCREMENT PRIMARY KEY,
    persona_id      BIGINT       NOT NULL COMMENT '所属画像 ID',
    condition_group INT          NOT NULL DEFAULT 0 COMMENT '条件分组（同组 AND，不同组 OR）',
    field           VARCHAR(50)  NOT NULL COMMENT '匹配字段：genre / keyword / director / actor / budget / revenue / tmdb_rating / douban_rating / vote_count / release_year / language / country',
    operator        VARCHAR(10)  NOT NULL COMMENT '操作符：EQ / NEQ / IN / NOT_IN / GT / GTE / LT / LTE',
    value           VARCHAR(500) NOT NULL COMMENT '匹配值（IN 操作为 JSON 数组，其余为单值）',
    deleted         TINYINT(1)   NOT NULL DEFAULT 0 COMMENT '逻辑删除：0-正常，1-已删除',
    created_at      DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at      DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_persona_group (persona_id, condition_group)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
  COMMENT='画像匹配规则条件';

CREATE TABLE user_persona (
    id          BIGINT AUTO_INCREMENT PRIMARY KEY,
    user_id     BIGINT   NOT NULL COMMENT '用户 ID',
    persona_id  BIGINT   NOT NULL COMMENT '画像 ID',
    created_at  DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    UNIQUE KEY uk_user_persona (user_id, persona_id),
    INDEX idx_user_id (user_id),
    INDEX idx_persona_id (persona_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
  COMMENT='用户-画像关联';

CREATE TABLE user_watched_movie (
    id          BIGINT AUTO_INCREMENT PRIMARY KEY,
    user_id     BIGINT   NOT NULL COMMENT '用户 ID',
    movie_id    BIGINT   NOT NULL COMMENT '电影 ID',
    watched_at  DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '观看时间',
    created_at  DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    UNIQUE KEY uk_user_movie (user_id, movie_id),
    INDEX idx_user_id (user_id),
    INDEX idx_movie_id (movie_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
  COMMENT='用户已看电影（推荐时排除）';

-- ---------------------------------------------------------------------------
-- 4. 电影
-- ---------------------------------------------------------------------------

CREATE TABLE movie (
    id                  BIGINT AUTO_INCREMENT PRIMARY KEY,
    tmdb_id             INT          NOT NULL COMMENT 'TMDB 电影 ID',
    imdb_id             VARCHAR(20)  DEFAULT NULL COMMENT 'IMDb ID（如 tt0076759）',
    title               VARCHAR(255) NOT NULL COMMENT '片名（同步时取中文，zh-CN）',
    original_title      VARCHAR(255) DEFAULT NULL COMMENT '原始片名',
    overview            TEXT         DEFAULT NULL COMMENT '简介',
    tagline             VARCHAR(500) DEFAULT NULL COMMENT '标语（tagline）',
    poster_path         VARCHAR(255) DEFAULT NULL COMMENT '海报相对路径',
    backdrop_path       VARCHAR(255) DEFAULT NULL COMMENT '背景图相对路径',
    release_date        DATE         DEFAULT NULL COMMENT '上映日期',
    runtime             INT          DEFAULT NULL COMMENT '片长（分钟）',
    budget              BIGINT       DEFAULT 0 COMMENT '预算（USD）',
    revenue             BIGINT       DEFAULT 0 COMMENT '票房（USD）',
    popularity          DECIMAL(12,6) DEFAULT 0 COMMENT 'TMDB 热度分',
    original_language   CHAR(2)      DEFAULT NULL COMMENT '原始语言（ISO 639-1）',
    origin_country      JSON         DEFAULT NULL COMMENT '制片国家/地区（ISO 3166-1 数组，如 ["US","GB"]）',
    status              VARCHAR(20)  DEFAULT NULL COMMENT '上映状态',
    tmdb_vote_average   DECIMAL(3,1) DEFAULT 0 COMMENT 'TMDB 均分（0-10）',
    tmdb_vote_count     INT          DEFAULT 0 COMMENT 'TMDB 评分人数',
    douban_rating       DECIMAL(3,1) DEFAULT NULL COMMENT '豆瓣评分（0-10）',
    douban_vote_count   INT          DEFAULT NULL COMMENT '豆瓣评分人数',
    deleted             TINYINT(1)   NOT NULL DEFAULT 0 COMMENT '逻辑删除：0-正常，1-已删除',
    created_at          DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at          DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    UNIQUE KEY uk_tmdb_id (tmdb_id),
    INDEX idx_release_date (release_date),
    INDEX idx_popularity (popularity),
    INDEX idx_tmdb_rating (tmdb_vote_average),
    INDEX idx_douban_rating (douban_rating)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
  COMMENT='电影';

CREATE TABLE movie_genre (
    id          BIGINT AUTO_INCREMENT PRIMARY KEY,
    movie_id    BIGINT NOT NULL COMMENT '电影 ID',
    genre_id    BIGINT NOT NULL COMMENT '类型 ID',
    created_at  DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    UNIQUE KEY uk_movie_genre (movie_id, genre_id),
    INDEX idx_movie_id (movie_id),
    INDEX idx_genre_id (genre_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
  COMMENT='电影-类型关联';

CREATE TABLE movie_keyword (
    id          BIGINT AUTO_INCREMENT PRIMARY KEY,
    movie_id    BIGINT NOT NULL COMMENT '电影 ID',
    keyword_id  BIGINT NOT NULL COMMENT '关键词 ID',
    created_at  DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    UNIQUE KEY uk_movie_keyword (movie_id, keyword_id),
    INDEX idx_movie_id (movie_id),
    INDEX idx_keyword_id (keyword_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
  COMMENT='电影-关键词关联';

CREATE TABLE movie_crew (
    id              BIGINT AUTO_INCREMENT PRIMARY KEY,
    movie_id        BIGINT       NOT NULL COMMENT '电影 ID',
    person_id       BIGINT       NOT NULL COMMENT '影人 ID',
    role            VARCHAR(20)  NOT NULL COMMENT '角色：DIRECTOR / ACTOR',
    character_name  VARCHAR(200) NOT NULL DEFAULT '' COMMENT '饰演角色名（DIRECTOR 时为空字符串）',
    created_at      DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at      DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_movie_id (movie_id),
    INDEX idx_person_id (person_id),
    UNIQUE KEY uk_movie_person_role_char (movie_id, person_id, role, character_name)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
  COMMENT='电影-剧组成员关联';

-- ---------------------------------------------------------------------------
-- 5. 推荐 & 推送
-- ---------------------------------------------------------------------------

CREATE TABLE recommendation (
    id              BIGINT AUTO_INCREMENT PRIMARY KEY,
    user_id         BIGINT       NOT NULL COMMENT '用户 ID',
    movie_id        BIGINT       NOT NULL COMMENT '电影 ID',
    persona_id      BIGINT       DEFAULT NULL COMMENT '推荐来源画像 ID（NULL 表示冷启动推荐）',
    reason          TEXT         DEFAULT NULL COMMENT '推荐理由（LLM 生成文案）',
    is_read         TINYINT(1)   NOT NULL DEFAULT 0 COMMENT '用户是否已阅读',
    scheduled_at    DATETIME     DEFAULT NULL COMMENT '预定推送时间',
    push_at         DATETIME     DEFAULT NULL COMMENT '实际推送时间',
    deleted         TINYINT(1)   NOT NULL DEFAULT 0 COMMENT '逻辑删除：0-正常，1-已撤回',
    created_at      DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at      DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_user_created (user_id, created_at),
    INDEX idx_movie_id (movie_id),
    INDEX idx_persona_id (persona_id),
    UNIQUE KEY uk_user_movie_persona (user_id, movie_id, persona_id, deleted)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
  COMMENT='推荐记录';

CREATE TABLE push_config (
    id                  BIGINT AUTO_INCREMENT PRIMARY KEY,
    user_id             BIGINT      NOT NULL COMMENT '用户 ID',
    push_frequency      VARCHAR(20) NOT NULL DEFAULT 'weekly' COMMENT '推送频率',
    email_enabled       TINYINT(1)  NOT NULL DEFAULT 1 COMMENT '邮件推送开关',
    preferred_push_time TIME        DEFAULT NULL COMMENT '偏好的推送时段（HH:mm）',
    created_at          DATETIME    NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at          DATETIME    NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    UNIQUE KEY uk_user_id (user_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
  COMMENT='用户推送配置';
