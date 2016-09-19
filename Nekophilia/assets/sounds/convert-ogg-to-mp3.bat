@echo off
where ffmpeg >nul 2>&1
if %ERRORLEVEL% equ 0 (
	for %%g in (*.ogg) do ffmpeg -n -i "%%g" "%%~ng.mp3"
) else (
	echo.
	echo ERROR: You do not have ffmpeg installed. Google it.
	PAUSE
)