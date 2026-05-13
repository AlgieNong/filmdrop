# FilmDrop / 映投 — Session 日志

> 每次 session 结束时追加记录，方便后续接续。

格式：
## YYYY-MM-DD | 标题
- 做了什么：
- 关键决策：
- 文件变更：
- 下次开始于：

## 2026-05-13 | 项目初始化
- 做了什么：创建了项目目录骨架，包括 .claude/memory/ 四个状态文件、CLAUDE.md、.gitignore、README.md；初始化 git 仓库并提交
- 关键决策：
  - memory 文件放在项目目录内（.claude/memory/），受 git 管理，可跨设备同步
  - 当前不讨论技术栈先做产品定义
  - CLAUDE.md 作为 Session Protocol 定义跨 session 协作规范
- 文件变更：新增 7 个文件
- 下次开始于：产品功能定义讨论

## 2026-05-13 | 产品功能定义完成

- **做了什么：** 完成了 FilmDrop 的产品功能定义，包括注册方式、推送策略、数据源方案、评价体系、网站功能范围等核心维度的讨论和决策。
- **关键决策：**
  - 数据源：TMDB API（主）+ 豆瓣评分/评论（按需爬取）
  - 推送：新片上线 + 定时推送双模式，用户自调频率，初期仅邮件
  - 网站功能：仅 Web 端，无管理后台，含注册/登录、首页推荐流、电影浏览/搜索/筛选、电影详情、历史推荐记录、设置页
  - 注册：支持邮箱和手机号，偏好可选填
  - 反馈机制：暂不做
- **文件变更：** 更新 CURRENT_STATE.md、TECH_DECISIONS.md、ROADMAP.md
- **下次开始于：** 数据模型设计或技术栈选型

## 2026-05-13 | 技术栈选型完成

- **做了什么：** 逐一讨论了后端框架、构建工具、数据库、ORM、前端框架、架构模式等核心技术选择。
- **关键决策：**
  - 后端：Spring Boot + Maven + MySQL + MyBatis-Plus + XXL-Job
  - 前端：Next.js + React（前后端分离，SSR 支持 SEO）
  - 用户访问：非登录用户可浏览（SEO 友好），登录用户获得个性化推荐
  - 架构：Maven 多模块单体（Modular Monolith）
  - 版本：Java 17, Spring Boot 3.4.x, Node.js 20 LTS, MySQL 8.0+
  - 前端配置：App Router + Tailwind CSS
  - 数据迁移：手动 SQL 脚本，不使用迁移工具
- **文件变更：** 更新 CURRENT_STATE.md、TECH_DECISIONS.md、ROADMAP.md
- **下次开始于：** 数据模型设计
