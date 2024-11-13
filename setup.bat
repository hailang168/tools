@ECHO OFF

REM １ 下記の①、②のファイルをローカル環境にダウンロードします。
REM 　①ツールのダウンロード
REM 　https://www.microsoft.com/en-us/download/details.aspx?id=49117
REM 
REM 　②構成ファイル(config.xml)のエクスポート
REM 　https://config.office.com/deploymentsettings
REM 　
REM ２「Windowsの検索に「ｃｍｄ]と入力し、コマンドプロンプト（管理者として実行）を起動します。
REM 　以下のコメントを実行する
REM 　③ cdコマンドを入力し、①，②のファイルを保存したフォルダに入ります。
REM      cd [フォルダパス]
REM      例） cd C:\Office2021
REM 　④ setup /download config.xml
REM 
REM 上記まで　実施済みなので、再実施が要らないです。
REM ----------------------------------------------------------------------


REM 管理者として起動の判断
whoami /priv | find "SeDebugPrivilege" > NUL
IF %errorlevel% neq 0 (
    powershell start-process "%~0" -verb runas
	REM echo 管理者 NG
    EXIT
)

REM echo 管理者 OK

REM 保存したフォルダへ移動
SET parentDir=%~dp0
CD %parentDir%

REM メイン処理
:REC_MENU
CLS
ECHO -----Office製品より導入の手順-----
ECHO メニューを選択ください
ECHO   0. インストール用ファイルをダウンロード
ECHO   1. Officeをインストールする
ECHO   2. KMSを使ったライセンス認証
ECHO   9. 処理終了
ECHO.

SET /P MENU_REC=メニューを入力: 


REM 未入力の場合、
IF "%MENU_REC%" EQU "0" (
    GOTO :DOWNLOAD
) ELSE IF "%MENU_REC%" EQU "1" (
    GOTO :INSTALL
) ELSE IF "%MENU_REC%" EQU "2" (
    GOTO :ACTIVE
) ELSE IF "%MENU_REC%" EQU "9" (
    EXIT /B 0
) ELSE (
    GOTO :REC_MENU
)

REM Officeインストール用ファイルをダウンロード
:DOWNLOAD
ECHO.
REM ファイルの存在チェック
SET FOLDER1=%parentDir%\Office\
IF EXIST "%FOLDER1%" (
	ECHO Officeフォルダがすでに存在するため、再ダウンロードが不要です。
) ELSE (
	ECHO Officeインストール用ファイルをダウンロードします。
	setup /download config.xml > NUL
	IF %errorlevel% equ 0 (
	    ECHO インストールファイルがダウンロード成功、インストール処理を続けて
	    GOTO :INSTALL
	) ELSE (
	    ECHO インストールファイルがダウンロード失敗、ご確認ください。
	)
)

ECHO.
PAUSE
GOTO :REC_MENU

REM Officeインストール
:INSTALL
ECHO.
ECHO Officeをインストールします。
setup /configure config.xml > NUL
IF %errorlevel% equ 0 (
    ECHO Officeがインストール成功、認証処理を続けて
    GOTO :ACTIVE
) ELSE (
    ECHO Officeがインストール失敗、ご確認ください。
)

ECHO.
PAUSE
GOTO :REC_MENU
 
REM kmsで認証実行
:ACTIVE
ECHO.
ECHO KMS を使用してボリューム ライセンスバージョンの Office をアクティブ化する。
REM Method 1：アクティブ化
CD C:\Program Files\Microsoft Office\Office16\
REM slmgr /skms kms.03k.org
REM slmgr /ato
cscript ospp.vbs /sethst:kms.03k.org
cscript ospp.vbs /act

REM Method 2： - PowerShell (Recommended)
REM irm https://massgrave.dev/get | iex

ECHO.
ECHO Officeのインストールが完了しました、処理終了
PAUSE
