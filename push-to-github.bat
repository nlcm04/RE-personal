@echo off
chcp 65001 >nul
setlocal
title Day len GitHub - RE-personal

rem ============================================================
rem  Day cong cu tinh hieu qua dau tu BDS len GitHub
rem  Repo: https://github.com/nlcm04/RE-personal
rem  Cach dung: dat file .bat nay CUNG THU MUC voi file HTML,
rem  roi bam dup de chay.
rem ============================================================

set "REPO_URL=https://github.com/nlcm04/RE-personal.git"
set "BRANCH=main"
set "HTML_FILE=cong-cu-tinh-hieu-qua-dau-tu-bds.html"

cd /d "%~dp0"
echo.
echo Thu muc lam viec: %CD%
echo.

rem --- 1. Kiem tra Git ---
where git >nul 2>&1
if errorlevel 1 (
  echo [LOI] May chua cai Git.
  echo       Tai va cai tai: https://git-scm.com/download/win
  echo       Cai xong, chay lai file nay.
  goto :fail
)

rem --- 2. Kiem tra file HTML ---
if not exist "%HTML_FILE%" (
  echo [LOI] Khong tim thay file "%HTML_FILE%" trong thu muc nay.
  echo       Hay dat file .bat nay cung thu muc voi file HTML.
  goto :fail
)

rem --- 3. Khoi tao repo neu chua co ---
if not exist ".git" (
  echo [1/6] Khoi tao Git repo...
  git init >nul
  git symbolic-ref HEAD refs/heads/%BRANCH%
) else (
  echo [1/6] Da co Git repo.
)

rem --- 4. Thong tin tac gia (chi hoi lan dau) ---
git config user.name >nul 2>&1
if errorlevel 1 goto :askname
goto :checkmail
:askname
set /p "GIT_NAME=Nhap ten hien thi tren GitHub (vd: Minh Nguyen): "
git config user.name "%GIT_NAME%"
:checkmail
git config user.email >nul 2>&1
if errorlevel 1 goto :askmail
goto :remote
:askmail
set /p "GIT_MAIL=Nhap email tai khoan GitHub: "
git config user.email "%GIT_MAIL%"

rem --- 5. Gan dia chi repo ---
:remote
echo [2/6] Gan dia chi repo: %REPO_URL%
git remote get-url origin >nul 2>&1
if errorlevel 1 (
  git remote add origin "%REPO_URL%"
) else (
  git remote set-url origin "%REPO_URL%"
)

rem --- 6. Chi them dung cac file cua cong cu (khong day nham file khac) ---
echo [3/6] Them file vao commit...
git add -- "%HTML_FILE%" "%~nx0"

git diff --cached --quiet
if errorlevel 1 (
  echo [4/6] Tao commit...
  git commit -m "Cap nhat cong cu tinh hieu qua dau tu BDS (%date% %time:~0,5%)" >nul
  if errorlevel 1 (
    echo [LOI] Khong tao duoc commit.
    goto :fail
  )
) else (
  echo [4/6] Khong co thay doi moi de commit.
)

rem --- 7. Lay thay doi tren GitHub ve truoc (neu repo da co noi dung) ---
echo [5/6] Dong bo voi GitHub...
git ls-remote --exit-code --heads origin %BRANCH% >nul 2>&1
if errorlevel 1 (
  echo       Nhanh %BRANCH% tren GitHub chua co - se tao moi.
) else (
  git pull --no-rebase --allow-unrelated-histories --no-edit origin %BRANCH%
  if errorlevel 1 (
    echo [LOI] Bi xung dot khi gop voi ban tren GitHub.
    echo       Mo thu muc nay bang GitHub Desktop / VS Code de xu ly xung dot, roi chay lai.
    goto :fail
  )
)

rem --- 8. Day len ---
echo [6/6] Day len GitHub (lan dau co the hien cua so dang nhap GitHub)...
git push -u origin %BRANCH%
if errorlevel 1 (
  echo.
  echo [LOI] Day len that bai. Kiem tra:
  echo   - Da dang nhap dung tai khoan co quyen ghi vao repo nlcm04/RE-personal chua
  echo   - Repo https://github.com/nlcm04/RE-personal da duoc tao tren GitHub chua
  echo   - Ket noi Internet
  goto :fail
)

echo.
echo ============================================================
echo  XONG! Xem tai: https://github.com/nlcm04/RE-personal
echo ============================================================
echo.
pause
exit /b 0

:fail
echo.
pause
exit /b 1
