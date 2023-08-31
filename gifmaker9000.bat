@echo off
title GIFMAKER 9000
:menu
echo(
echo -----------------------------------------
echo THE GIFMAKER 9000 MENU
echo 1 - Sort image files
echo 2 - Make GIF from VIDEO
echo 3 - Make GIF from IMAGE files (note: SORT IMAGES FIRST)
echo -----------------------------------------
set /p m=Type 1, 2, or 3 to select an option. 
if %m%==1 goto sort
if %m%==2 goto video
if %m%==3 goto image

:sort
sort-func.py
goto menu

:video
set /p inputdir="Enter the directory where your video file is stored. Your gif will also be created here.    "
cd %inputdir%
set /p inputvid="Enter the name of your video file, including the extension. EX: input.mp4, x.mov:     "
set /p gifname="Enter the name of the output gif (don't add .gif):    "
set /p seek="Enter the timestamp that you want to start your gif at, in seconds. EX: 130.0 for 2:10:     "
set /p dur="Enter how long you want your gif to be, in seconds. Ex: 3.0 for a 3 second gif:     "
set /p fps="Enter the FPS you want:     "
set /p width="Enter the desired width you want in pixels; height will be scaled accordingly:   "
echo You can set the gif to either use 1) one palette across all frames or 2) have unique palettes for each frame.
set /p vidflag="Enter 1 or 2 to choose the GIF type    "
if %vidflag%==1 (goto videosingle) else (goto videomulti)

:videosingle
echo creating gif...
ffmpeg -loglevel error -ss %seek% -t %dur% -i %inputvid% -filter_complex "[0:v] fps=%fps%,scale=%width%:-1,split [a][b];[a] palettegen [p];[b][p] paletteuse" %gifname%.gif
echo %gifname%.gif created!
goto menu

:videomulti
echo creating gif...
ffmpeg -loglevel error -ss %seek% -t %dur% -i %inputvid% -filter_complex "[0:v] fps=%fps%,scale=%width%:-1,split [a][b];[a] palettegen=stats_mode=single [p];[b][p] paletteuse" %gifname%.gif
echo %gifname%.gif created!
goto menu

:image
set /p inputdir="Enter the directory where your images are stored. Your gif will also be created here.    "
cd %inputdir%
set /p prefix="Enter the prefix of your image files:     "
set /p ext="Enter the file extension of your image files (ex: .png, .jpg, .bmp):   "
set /p gifname="Enter the name of the output gif (don't add .gif):    "
set /p fps="Enter the FPS you want:     "
set /p width="Enter the desired width you want in pixels; height will be scaled accordingly:   "
echo You can set the gif to either use 1) one palette across all frames or 2) have unique palettes for each frame.
set /p imgflag="Enter 1 or 2 to choose the GIF type    "
if %imgflag%==1 (goto imgsingle) else (goto imgmulti)

:imgsingle
echo creating gif...
ffmpeg -loglevel error -framerate %fps% -i %prefix%%%d%ext% -filter_complex "[0:v]scale=%width%:-1,split[x][z];[x]palettegen[y];[z][y]paletteuse" %gifname%.gif
echo %gifname%.gif created!
goto menu

:imgmulti
echo creating gif...
ffmpeg -loglevel error -framerate %fps% -i %prefix%%%d%ext% -filter_complex "[0:v]scale=%width%:-1,split[x][z];[x]palettegen=stats_mode=single[y];[z][y]paletteuse" %gifname%.gif
echo %gifname%.gif created!
goto menu
echo %gifname%.gif created!
goto menu