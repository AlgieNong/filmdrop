# FilmDrop / 映投

> 一个电影推荐网站——定时给用户推送值得看的电影。

## 项目概述

FilmDrop（中文名：映投）的核心概念很简单：**定期投递一部好电影给你。**
用户注册后，系统会根据用户的偏好定时推荐电影，用户也可以主动浏览、搜索、收藏电影。

## 项目状态

项目当前处于**产品定义阶段**，尚未开始编码。
具体进度见 [.claude/memory/CURRENT_STATE.md](.claude/memory/CURRENT_STATE.md)。

## 目录结构

```
movie-api/
├── CLAUDE.md                 ← 本文件（每个 session 自动读取）
├── .gitignore
├── README.md
├── .claude/
│   ├── memory/               ← session 状态、日志、决策记录
│   │   ├── CURRENT_STATE.md
│   │   ├── SESSION_LOG.md
│   │   ├── TECH_DECISIONS.md
│   │   └── ROADMAP.md
│   └── settings.local.json
└── docs/                     ← 产品文档
```

## Session Protocol（跨 session 协作规范）

### 每个 session 开始时

1. 读取本 CLAUDE.md
2. 读取 [CURRENT_STATE.md](.claude/memory/CURRENT_STATE.md) — 了解当前进度
3. 读取 [TECH_DECISIONS.md](.claude/memory/TECH_DECISIONS.md) — 了解已做决策
4. 读取 [SESSION_LOG.md](.claude/memory/SESSION_LOG.md) 末尾 3-5 条 — 了解上一个 session 做了什么
5. 运行 `git log --oneline -5` 和 `git status` — 了解 git 状态

### 每个 session 结束时

1. 确保代码已提交，git 状态干净
2. 更新 [CURRENT_STATE.md](.claude/memory/CURRENT_STATE.md) 反映最新进度
3. 追加本次 session 摘要到 [SESSION_LOG.md](.claude/memory/SESSION_LOG.md)
4. 若有技术决策，记录到 [TECH_DECISIONS.md](.claude/memory/TECH_DECISIONS.md)

## 语言

- 所有沟通、注释、文档使用**中文**
- 代码标识符（变量、函数、类名）使用**英文**
