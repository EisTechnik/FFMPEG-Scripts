:: Note, experiment what works better on the system. 
:: In some cases it seems CPU (x264) is quicker at transcoding than GPU (nvenc),
:: which works out as GPU encoding has minor quality loss.

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
set OUTPUT_FILE="%~dpn1_transcoded_nvenc.mp4"


echo Transcoding "%~1" to MP4...
:: `-preset p1` or `-preset hp`
::		Same preset, aliases. Quickest preset.
::	`-cq 18`
::		Apparently a value of 23 is similar to libx264's default params.
::		Lower, because small file size isn't as important as speed and quality
::	`-c:a`
::		Apparently copying audio instead of transcoding isn't neccesarily default, so explictly set to copy.
ffmpeg -vsync 0 -hwaccel cuda -hwaccel_output_format cuda -i "%~1" -c:v h264_cuda -preset p1 -cq 18 -c:a copy !OUTPUT_FILE!

echo Transcode complete!
pause
exit /b
