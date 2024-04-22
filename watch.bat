@echo off
flutter clean & flutter pub get & title build_runner & dart run build_runner watch --delete-conflicting-outputs