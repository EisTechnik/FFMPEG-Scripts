:: TODO - FIX
:: Works, but creates a file that crashes vegas almost instantly.
:: Goal is for conversion to video thats optimal for editing (without using proxy media)

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

:: BITRATE
:: For 50,000,000 bps, BITRATE=50M
:: For whatever the source is, just BITRATE=
:: Quality degredation could happen between compressed codecs, so specify a bitrate where possible
:: 50 is one of XAVC-Intra's standards
set BITRATE=50M

if defined BITRATE (
    set BITRATE_OPTION=-b:v !BITRATE!
) else (
    set BITRATE_OPTION=
)

:: OUTPUT
:: %~d1: Drive letter of the file
:: %~p1: Path of the file (directory)
:: %~n1: Name of the file (without extension)
:: MOV - Mov is older, but MP4 doesn't support pcm_s16le audio, Vegas doesn't support MKV, and MXF doesn't support anything other than 48KHZ audio
set OUTPUT_FILE="%~dpn1_xavc-intra.mov"


echo Converting "%~1" to XAVC-Intra format...
:: `-x264-params keyint=1`
::		Intra-frame compression param for `-c:v h264`
:: `-g 1`
::		Intra-frame compression param for `-c:v h264_nvenc`
:: `-pix_fmt yuv422p10le`
::		Should never negatively effect video quality, just compatibility/larger file size.
::		Use 4:2:2 Chroma instead of the common 4:2:0 & use 10 bits per channel instead of the common 8.
:: `-c:a pcm_s16le`
::		XAVC-Intra standard, "Linear PCM". 16 bit,  little-endian byte order.
::		Use `-c:a aac` if the output container is .mp4, since it doesnt support this.
ffmpeg -i "%~1" -c:v libx264 -x264-params keyint=1 !BITRATE_OPTION! -pix_fmt yuv422p10le -c:a pcm_s16le !OUTPUT_FILE!

echo Conversion complete!
pause
exit /b
