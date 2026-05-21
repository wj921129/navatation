@echo off
title Navatation Backend Service
echo ============================================
echo   Starting Navatation Backend Service...
echo ============================================
set JAVA_HOME=D:\javaSoftware\jdk\jdk17
cd /d "%~dp0..\navatation-admin\navatation-business"
mvn spring-boot:run
