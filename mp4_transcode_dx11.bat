:: Experimental DirectX HWAccel.
:: Acceptable results, NVENC or Libx264 have higher speeds at limits though.
:: Tested with 7950X3D iGPU.
:: Probably better to look into Vulkan.

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
set OUTPUT_FILE="%~dpn1_transcoded_dx11.mp4"


echo Transcoding "%~1" to MP4...
:: Nvidia Docs suggest `-hwaccel_output_format d3d11` to avoid raw data copy between GPU and System RAM
ffmpeg -hwaccel_device 1 -hwaccel d3d11va -hwaccel_output_format d3d11 -i "%~1" -c:v hevc_amf output.mp4


echo Transcode complete!
pause
exit /b
