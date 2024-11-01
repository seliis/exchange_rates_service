@echo off
setlocal
    if exist package (
        rmdir /s /q package
    )
    mkdir /p package\public
    cd app
    call flutter clean
    call flutter build web
    xcopy /e /i /y build\web\* ..\package\public\
    rmdir /s /q build
    cd ..
    call go build -o .\package\main.exe .\server
    copy config.json .\package
endlocal