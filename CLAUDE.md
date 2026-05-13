# FilmDrop / 映投

> 一个电影推荐网站——定时给用户推送值得看的电影。

## 项目概述

FilmDrop（中文名：映投）的核心概念很简单：**定期投递一部好电影给你。**
用户注册后，系统会根据用户的偏好定时推荐电影，用户也可以主动浏览、搜索、收藏电影。

## 项目状态

项目当前处于**技术选型完成，待数据模型设计**阶段。
具体进度见 [.claude/memory/CURRENT_STATE.md](.claude/memory/CURRENT_STATE.md)。

## 架构概览

### 整体架构（前后端分离）

```
用户浏览器 ──HTTPS──> Next.js (SSR) ──REST API──> Spring Boot ──JDBC──> MySQL
                                                       │
                                              ┌────────┼────────┐
                                              │        │        │
                                          TMDB API  豆瓣爬虫  XXL-Job
                                           (数据源)  (评分)   (定时调度)
```

### 后端架构（Maven 多模块单体）

| 模块 | 职责 |
|---|---|
| `filmdrop-web` | 启动入口、REST 控制器、Security 配置 |
| `filmdrop-user` | 用户注册/登录、偏好管理、JWT |
| `filmdrop-movie` | 电影 CRUD、TMDB 数据同步、搜索筛选 |
| `filmdrop-recommendation` | 推荐算法、推荐记录 |
| `filmdrop-crawler` | 豆瓣评分/评论爬取 |
| `filmdrop-push` | 邮件推送、XXL-Job 定时任务 |
| `filmdrop-common` | 共享工具、常量、异常 |

模块间单向依赖：`web → 业务模块 → common`

### 前端架构（Next.js App Router）

```
src/app/
├── page.tsx              # 首页推荐流（公开）
├── login/                # 登录（公开）
├── register/             # 注册（公开）
├── movies/               # 搜索/筛选（公开）
├── movie/[id]/           # 电影详情（公开）
├── recommendations/      # 我的推荐（需登录）
└── settings/             # 设置（需登录）
```

### 技术栈汇总

| 维度 | 选型 |
|---|---|
| 后端框架 | Spring Boot 3.4.x / Java 17 / Maven |
| 数据库 | MySQL 8.0+ / MyBatis-Plus |
| 定时任务 | XXL-Job |
| 前端框架 | Next.js (React) / App Router / Tailwind CSS |
| 架构模式 | 前后端分离 / 单仓库（Monorepo） |
| 数据源 | TMDB API（主）+ 豆瓣爬虫（评分补充） |

> 详细架构图见 [docs/architecture/diagrams.md](docs/architecture/diagrams.md)

## 目录结构

```
filmdrop/
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
├── backend/                  ← Spring Boot 后端（Maven 多模块）
│   ├── pom.xml
│   ├── filmdrop-common/
│   ├── filmdrop-user/
│   ├── filmdrop-movie/
│   ├── filmdrop-recommendation/
│   ├── filmdrop-crawler/
│   ├── filmdrop-push/
│   └── filmdrop-web/
├── frontend/                 ← Next.js 前端
│   ├── package.json
│   ├── next.config.ts
│   └── src/app/
└── docs/                     ← 产品 & 架构文档
    └── architecture/
        └── diagrams.md         ← PlantUML 架构图
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
