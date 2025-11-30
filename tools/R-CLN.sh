#!/bin/bash

echo "==============================================="
echo "   R-CLN SYSTEM  -  RootS Cleanser v1.0 (UNIX)"
echo "==============================================="
echo ""
echo "どのモードで浄化しますか？"
echo "  1 = Next.js モード"
echo "  2 = SvelteKit モード"
echo "  3 = 全部浄化（最強）"
read -p "> " mode
echo ""
echo "選択：$mode"
echo ""

# ----------------------------------------------------
# 0. バックアップ作成
# ----------------------------------------------------
backupDir="RCLN_backup"

echo "==== バックアップ開始 ===="
mkdir -p "$backupDir"

echo "persona をバックアップ…"
if [ -d "src/system/persona" ]; then
    cp -R src/system/persona "$backupDir/persona"
fi

echo "avatars をバックアップ…"
if [ -d "public/avatars" ]; then
    cp -R public/avatars "$backupDir/avatars"
fi

echo ".env をバックアップ…"
[ -f .env ] && cp .env "$backupDir/.env"

echo ".env.local をバックアップ…"
[ -f .env.local ] && cp .env.local "$backupDir/.env.local"

echo "==== バックアップ完了 ===="
echo ""

# ----------------------------------------------------
# 1. 重複 / 混線チェック
# ----------------------------------------------------
echo "==== 重複・混線チェック開始 ===="
echo "==== R-CLN LOG ====" > RCLN_log.txt

# ChatBubble.svelte
CB_count=$(find . -name "ChatBubble.svelte" | tee -a RCLN_log.txt | wc -l)
if [ "$CB_count" -gt 1 ]; then
    echo "[警告] ChatBubble.svelte が $CB_count 個見つかりました！"
else
    echo "ChatBubble.svelte は正常（1個以下）"
fi

# route.ts
ROUTE_count=$(find . -name "route.ts" | tee -a RCLN_log.txt | wc -l)
if [ "$ROUTE_count" -gt 1 ]; then
    echo "[警告] route.ts が複数存在します！"
fi

# +server.ts
SERVER_count=$(find . -name "+server.ts" | tee -a RCLN_log.txt | wc -l)
if [ "$SERVER_count" -gt 1 ]; then
    echo "[警告] +server.ts が複数存在します！"
fi

# persona.json
PS_count=$(find . -name "persona.json" | tee -a RCLN_log.txt | wc -l)
if [ "$PS_count" -gt 1 ]; then
    echo "[警告] persona.json が複数存在します！"
fi

# API KEY チェック
echo "API キー形式チェック中…"
if grep -q "OPENAI_API_KEY" .env .env.local 2>/dev/null; then
    if ! grep -Eq "^OPENAI_API_KEY=sk-proj-" .env .env.local 2>/dev/null; then
        echo "[警告] OPENAI_API_KEY の形式が sk-proj- ではありません"
    else
        echo "APIキー形式は正常です"
    fi
else
    echo "[警告] APIキーが .env / .env.local に存在しません！"
fi

echo "==== スキャン完了 ===="
echo ""

# ----------------------------------------------------
# 2. 破壊フェーズ（削除）
# ----------------------------------------------------
echo "==== 環境浄化（削除）開始 ===="

case $mode in
1)
    echo "--- Next.js モード ---"
    rm -rf node_modules .next dist .vercel pnpm-lock.yaml package-lock.json
    ;;
2)
    echo "--- SvelteKit モード ---"
    rm -rf node_modules .svelte-kit .vite dist pnpm-lock.yaml package-lock.json
    ;;
3)
    echo "--- 全部浄化 ---"
    rm -rf node_modules .next .svelte-kit .vite dist .vercel pnpm-lock.yaml package-lock.json
    ;;
*)
    echo "[ERROR] 不正なモードです。終了します。"
    exit 1
    ;;
esac

echo "==== 削除フェーズ完了 ===="
echo ""

# ----------------------------------------------------
# 3. パッケージマネージャ判定
# ----------------------------------------------------
echo "==== パッケージマネージャ判定 ===="

if command -v pnpm >/dev/null 2>&1; then
    PM="pnpm"
else
    PM="npm"
fi

echo "使用パッケージマネージャ：$PM"
echo ""

# ----------------------------------------------------
# 4. 再インストール
# ----------------------------------------------------
echo "==== 依存パッケージ再インストール ===="
$PM install

if [ $? -ne 0 ]; then
    echo "[ERROR] インストールに失敗しました。RCLN_log.txt を確認してください。"
    exit 1
fi

echo "インストール完了。"
echo ""

# ----------------------------------------------------
# 5. 復元フェーズ
# ----------------------------------------------------
read -p "バックアップから復元しますか？ (Y/N) > " restore
if [[ "$restore" =~ ^[Yy]$ ]]; then
    echo "==== 復元開始 ===="

    [ -d "$backupDir/persona" ] && cp -R "$backupDir/persona" src/system/persona
    [ -d "$backupDir/avatars" ] && cp -R "$backupDir/avatars" public/avatars
    [ -f "$backupDir/.env" ] && cp "$backupDir/.env" .env
    [ -f "$backupDir/.env.local" ] && cp "$backupDir/.env.local" .env.local

    echo "==== 復元完了 ===="
fi
echo ""

# ----------------------------------------------------
# 6. dev サーバ起動
# ----------------------------------------------------
read -p "dev サーバを起動しますか？ (Y/N) > " runDev
if [[ "$runDev" =~ ^[Yy]$ ]]; then
    echo "サーバー起動中..."
    $PM run dev
fi

echo ""
echo "==============================================="
echo "  R-CLN SYSTEM - 浄化と再構築が完了しました"
echo "  RootS プロジェクトは健康な状態です"
echo "==============================================="
exit 0
