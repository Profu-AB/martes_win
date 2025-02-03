@echo off
chcp 65001 >nul

setlocal EnableDelayedExpansion

wsl -d Ubuntu-Profu --exec dbus-launch true

echo WSL distribution Ubuntu-Profu körs nu i bakgrunden...