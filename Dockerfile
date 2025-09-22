FROM python:3.10-slim

WORKDIR /app

RUN apt-get update && apt-get install -y \
    curl \
    gnupg \
    build-essential \
    git \
    && rm -rf /var/lib/apt/lists/*

RUN curl -fsSL https://deb.nodesource.com/setup_20.x | bash - \
    && apt-get install -y nodejs \
    && rm -rf /var/lib/apt/lists/*

RUN python --version && node --version && npm --version

COPY requirements.txt .

RUN pip install --no-cache-dir -r requirements.txt

COPY . .

RUN npm config set strict-ssl false
RUN npm install --no-audit

EXPOSE 5000

ENV PYTHONUNBUFFERED=1
ENV NODE_ENV=production

# 添加使用说明标签
LABEL org.opencontainers.image.title="DouYin Spider"
LABEL org.opencontainers.image.description="专业的抖音数据采集解决方案，支持笔记爬取，保存格式为excel或者media"
LABEL org.opencontainers.image.url="https://github.com/cv-cat/DouYin_Spider"
LABEL org.opencontainers.image.source="https://github.com/cv-cat/DouYin_Spider"
LABEL org.opencontainers.image.vendor="cv-cat"
LABEL org.opencontainers.image.version="latest"
LABEL org.opencontainers.image.licenses="MIT"

# 添加使用说明
LABEL usage.example="docker run --rm -it -v \"$((Resolve-Path .\datas).Path):/app/datas\" -e DY_COOKIES='your_cookies' -e DOUYIN_USER_URL='...' -e DOUYIN_WORKS='https://www.douyin.com/video/123' douyin-spider:local"
LABEL usage.env.dy_cookies="抖音登录后的cookies（必需）"
LABEL usage.env.douyin_works="要爬取的作品链接列表，多个URL用逗号分隔（可选）"
LABEL usage.env.douyin_user_url="要爬取的用户主页链接（可选）"
LABEL usage.note="DOUYIN_WORKS 和 DOUYIN_USER_URL 至少需要设置其中一个"

CMD ["python", "main.py"] 
