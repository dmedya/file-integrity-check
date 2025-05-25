#!/bin/bash

# Dizin ve dosya yolları
SCRIPT_DIR="/opt/scripts"
BASELINE_FILE="/opt/scripts/baseline_hashes.txt"
REPORT_FILE="/opt/scripts/integrity_report.txt"
DATE=$(date '+%Y-%m-%d %H:%M:%S')

# Rapor dosyasını temizle
> "$REPORT_FILE"

# Baseline dosyası yoksa oluştur
if [ ! -f "$BASELINE_FILE" ]; then
    echo "İlk çalıştırma - Baseline oluşturuluyor..."
    find "$SCRIPT_DIR" -type f -exec sha256sum {} \; > "$BASELINE_FILE"
    echo "[$DATE] Baseline oluşturuldu." >> "$REPORT_FILE"
    exit 0
fi

# Geçici dosya oluştur
TEMP_HASHES=$(mktemp)
find "$SCRIPT_DIR" -type f -exec sha256sum {} \; > "$TEMP_HASHES"

# Değişiklikleri kontrol et
echo "[$DATE] Bütünlük Kontrolü Raporu:" >> "$REPORT_FILE"
echo "----------------------------------------" >> "$REPORT_FILE"

# Yeni veya değiştirilmiş dosyaları kontrol et
while read -r hash file; do
    if ! grep -q "$hash  $file" "$BASELINE_FILE"; then
        if grep -q "$file" "$BASELINE_FILE"; then
            echo "DEĞİŞTİRİLDİ: $file" >> "$REPORT_FILE"
        else
            echo "YENİ DOSYA: $file" >> "$REPORT_FILE"
        fi
    fi
done < "$TEMP_HASHES"

# Silinmiş dosyaları kontrol et
while read -r hash file; do
    if ! grep -q "$file" "$TEMP_HASHES"; then
        echo "SİLİNDİ: $file" >> "$REPORT_FILE"
    fi
done < "$BASELINE_FILE"

# Değişiklik yoksa rapor et
if [ ! -s "$REPORT_FILE" ]; then
    echo "[$DATE] Değişiklik tespit edilmedi." >> "$REPORT_FILE"
fi

# Geçici dosyayı temizle
rm "$TEMP_HASHES"
