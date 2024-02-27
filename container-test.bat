@echo off
title and whe're on
cls

:options
echo "|---------------------------------------------------------|"
echo "|         choose what dockerfile you wanna run?           |"
echo "|                                                         |"
echo "|  [front]: this builds and runs the frontend dockerfile  |"
echo "|  [back]:  this builds and runs the backend dockerfile   |"
echo "|  [all]:   this build all images usefull for composeing  |"
echo "|---------------------------------------------------------|"
set /p dockerfile="choose (front or back or all): "

if %dockerfile%==front goto front
if %dockerfile%==back goto back
if %dockerfile%==all goto all
echo %dockerfile% is not a valid option. Try again
goto options 

:front
echo There is nothing here for now

goto end

:back
echo "<----REMOVING PREVIOUS IMAGE---->"
podman image rm backend-image
echo "<----PREVIOUS IMAGE HAS BEEN REMOVED---->"

echo "<----BUILDING IMAGE---->"
podman build -t backend-image -f website/container/dockerfile.backend --log-level=debug
echo "<----IMAGE HAS BEEN BUILT---->"

echo "<----RUNNING CONTAINER---->"
::-p 8080:8080
::The current settings make the container run on the host network
::The settings in the first comment maps the container port to the host, can't make it work
::The problem might be that the container uses both ipv- 4 and 6. There might be some conflict so if you could set what you wanna use the problem might be gone
podman run -p 8080:8080 backend-image
echo "<----CONTAINER IS RUNNING---->"
goto end

:all
echo "<----DELETING IMAGES---->"
podman image rm backend-image
podman image rm frontend-image
echo "<----DELETED---->"

echo "<----BUILDING IMAGES---->"
podman build -t backend-image -f website/container/dockerfile.backend --log-level=debug
podman build -t frontend-image -f website/container/dockerfile.frontend --log-level=debug

::podman image prune -a -f
echo "<----IMAGES BUILT---->"
podman images

goto end
:end

pause 
exit