#!/bin/bash

# Kaynak ve hedef dosya yolları
OLD_PATH="/Users/sakastudio/development/projects/asset_tracker/lib/generated/locale_keys.g.dart"
NEW_PATH="/Users/sakastudio/development/projects/asset_tracker/lib/core/config/localization/generated/locale_keys.g.dart"

# Hedef dizini oluştur (varsa sorun olmaz)
TARGET_DIR=$(dirname "$NEW_PATH")
if [ ! -d "$TARGET_DIR" ]; then
  echo "Hedef dizin bulunamadı, oluşturuluyor: $TARGET_DIR"
  mkdir -p "$TARGET_DIR"
fi

# Kaynak dosyanın varlığını kontrol et
if [ -f "$OLD_PATH" ]; then
  echo "Dosya bulundu. Taşınıyor..."
  mv "$OLD_PATH" "$NEW_PATH"
  echo "Dosya başarıyla taşındı!"
else
  echo "Kaynak dosya bulunamadı: $OLD_PATH"
  exit 1
fi