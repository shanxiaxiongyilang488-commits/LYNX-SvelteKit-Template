@echo off
title R-CLN System (RootS Cleanser v1.0)
color 0B

echo ================================================
echo    R-CLN SYSTEM  -  RootS Project Cleanser
echo ================================================
echo.
echo どのモードで浄化しますか？
echo   1 = Next.js モード
echo   2 = SvelteKit モード
echo   3 = 全部浄化（最強）
set /p mode="> "

echo.
echo 選択：%mode%
echo.

:: ----------------------------------------------------
:: 0. バックアップフォルダ作成
:: ----------------------------------------------------
echo ==== バックアップ開始 ====
set backupDir=RCLN_backup

if not exist %backupDir% (
    mkdir %backupDir%
)

echo persona をバックアップ…
if exist src\system\persona (
    xcopy /E /I /Y src\system\persona %backupDir%\persona >nul
)

echo avatars をバックアップ…
if exist public\avatars (
    xcopy /E /I /Y public\avatars %backupDir%\avatars >nul
)

echo .env をバックアップ…
if exist .env copy /Y .env %backupDir%\.env >nul

echo .env.local をバックアップ…
if exist .env.local copy /Y .env.local %backupDir%\.env.local >nul

echo ==== バックアップ完了 ====
echo.

:: ----------------------------------------------------
:: 1. 重複ファイル / 混線 チェック
:: ----------------------------------------------------
echo ==== 重複・混線ファイルスキャン開始 ====
echo ==== R-CLN LOG ==== > RCLN_log.txt

:: ChatBubble.svelte
set CB_count=0
for /f "delims=" %%A in ('dir /s /b ChatBubble.svelte 2^>nul') do (
    echo [FOUND] %%A >> RCLN_log.txt
    set /a CB_count+=1
)

if %CB_count% GTR 1 (
    echo [警告] ChatBubble.svelte が %CB_count% 個見つかりました！
    echo [警告] ChatBubble.svelte が %CB_count% 個存在 >> RCLN_log.txt
) else (
    echo ChatBubble.svelte は正常（1個以下）
)

:: route.ts
set ROUTE_count=0
for /f "delims=" %%A in ('dir /s /b route.ts 2^>nul') do (
    echo [FOUND] %%A >> RCLN_log.txt
    set /a ROUTE_count+=1
)

if %ROUTE_count% GTR 1 (
    echo [警告] route.ts が複数あります！
    echo [警告] route.ts が複数 >> RCLN_log.txt
)

:: +server.ts
set SERVER_count=0
for /f "delims=" %%A in ('dir /s /b +server.ts 2^>nul') do (
    echo [FOUND] %%A >> RCLN_log.txt
    set /a SERVER_count+=1
)

if %SERVER_count% GTR 1 (
    echo [警告] +server.ts が複数あります！
    echo [警告] +server.ts が複数 >> RCLN_log.txt
)

:: persona.json
set PS_count=0
for /f "delims=" %%A in ('dir /s /b persona.json 2^>nul') do (
    echo [FOUND] %%A >> RCLN_log.txt
    set /a PS_count+=1
)

if %PS_count% GTR 1 (
    echo [警告] persona.json が複数あります！
    echo [警告] persona.json が複数 >> RCLN_log.txt
)

:: API KEY チェック
echo API キー形式チェック中...
findstr /C:"OPENAI_API_KEY" .env .env.local >nul 2>&1
if %errorlevel% NEQ 0 (
    echo [警告] APIキーが .env/.env.local に存在しません！
    echo [警告] APIキー不在 >> RCLN_log.txt
) else (
    findstr /R "^OPENAI_API_KEY=sk-proj-" .env .env.local >nul 2>&1
    if %errorlevel% NEQ 0 (
        echo [警告] APIキー形式が sk-proj- ではありません
        echo [警告] APIキー形式異常 >> RCLN_log.txt
    ) else (
        echo APIキー形式は正常
    )
)

echo ==== スキャン完了 ====
echo.

:: ----------------------------------------------------
:: 2. 破壊フェーズ
:: ----------------------------------------------------
echo ==== 環境浄化（削除）開始 ====
echo.

if "%mode%"=="1" (
    echo --- Next.js モード ---
    if exist node_modules rmdir /s /q node_modules
    if exist .next rmdir /s /q .next
    if exist dist rmdir /s /q dist
    if exist .vercel rmdir /s /q .vercel
    if exist pnpm-lock.yaml del /f /q pnpm-lock.yaml
    if exist package-lock.json del /f /q package-lock.json
)

if "%mode%"=="2" (
    echo --- SvelteKit モード ---
    if exist node_modules rmdir /s /q node_modules
    if exist .svelte-kit rmdir /s /q .svelte-kit
    if exist .vite rmdir /s /q .vite
    if exist dist rmdir /s /q dist
    if exist pnpm-lock.yaml del /f /q pnpm-lock.yaml
    if exist package-lock.json del /f /q package-lock.json
)

if "%mode%"=="3" (
    echo --- 全部浄化 ---
    if exist node_modules rmdir /s /q node_modules
    if exist .next rmdir /s /q .next
    if exist .svelte-kit rmdir /s /q .svelte-kit
    if exist .vite rmdir /s /q .vite
    if exist dist rmdir /s /q dist
    if exist .vercel rmdir /s /q .vercel
    if exist pnpm-lock.yaml del /f /q pnpm-lock.yaml
    if exist package-lock.json del /f /q package-lock.json
)

echo ==== 削除フェーズ完了 ====
echo.

:: ----------------------------------------------------
:: 3. パッケージ再インストール
:: ----------------------------------------------------
echo ==== パッケージマネージャ判定 ====
where pnpm >nul 2>&1
if %errorlevel%==0 (
    set PM=pnpm
) else (
    set PM=npm
)

echo 使用パッケージマネージャ：%PM%
echo.

echo ==== 依存パッケージ再インストール ====
%PM% install
if %errorlevel% NEQ 0 (
    echo [エラー] インストール失敗。RCLN_log.txt を参照してください。
    echo [ERROR] install failed >> RCLN_log.txt
    goto END
)
echo インストール完了。
echo.

:: ----------------------------------------------------
:: 4. 復元フェーズ（必要な時だけ）
:: ----------------------------------------------------
echo バックアップから復元しますか？ (Y/N)
set /p restore="> "

if /I "%restore%"=="Y" (
    echo ==== 復元開始 ====

    if exist RCLN_backup\persona xcopy /E /I /Y RCLN_backup\persona src\system\persona >nul
    if exist RCLN_backup\avatars xcopy /E /I /Y RCLN_backup\avatars public\avatars >nul
    if exist RCLN_backup\.env copy /Y RCLN_backup\.env .env >nul
    if exist RCLN_backup\.env.local copy /Y RCLN_backup\.env.local .env.local >nul

    echo ==== 復元完了 ====
)

echo.

:: ----------------------------------------------------
:: 5. dev サーバ起動
:: ----------------------------------------------------
echo dev サーバを起動しますか？ (Y/N)
set /p runDev="> "

if /I "%runDev%"=="Y" (
    echo サーバー起動中...
    %PM% run dev
)

:END
echo.
echo ===============================================
echo   R-CLN SYSTEM - 浄化と再構築が完了しました
echo   RootS プロジェクトは健康な状態です
echo ===============================================
pause
exit
