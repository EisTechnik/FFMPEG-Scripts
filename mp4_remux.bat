:: Sometimes Vegas is perfectly fine with the codec but doesn't like the container.
:: Try remuxing the video before doing a full transcoding.

@echo off
setlocal enabledelayedexpansion
:: PRECHECK - FFMPEG
where ffmpeg >nul 2>&1
if %errorlevel% neq 0 (
    echo FFmpeg not found! Please ensure it's installed and in your system's PATH.
    pause
    exit /b
)

:: PRECHECK - ARG VALIDATION
if "%~1"=="" (
    echo Please drag and drop a video file onto this script.
    pause
    exit /b
)

:: OUTPUT
:: %~d1: Drive letter of the file
:: %~p1: Path of the file (directory)
:: %~n1: Name of the file (without extension)
set OUTPUT_FILE="%~dpn1_remuxed.mp4"


echo Remuxing "%~1" to MP4...
ffmpeg -hwaccel cuda -i "%~1" -codec copy !OUTPUT_FILE!

echo Remux complete!
pause
exit /b
