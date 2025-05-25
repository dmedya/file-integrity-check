# File Integrity Checker

Bu script, belirtilen dizindeki dosyaların bütünlük kontrolünü gerçekleştiren bir bash script'tir.

## Özellikler

- SHA256 hash algoritması ile dosya bütünlük kontrolü
- Yeni eklenen dosyaların tespiti
- Değiştirilen dosyaların tespiti
- Silinen dosyaların tespiti
- Otomatik raporlama
- Cron uyumlu çalışma

## Kurulum

1. Script'i indirin:
```bash
git clone https://github.com/dmedya/file-integrity-check.git
```

2. Gerekli dizinleri oluşturun:
```bash
sudo mkdir -p /opt/scripts
sudo cp check_integrity.sh /opt/scripts/
sudo chmod +x /opt/scripts/check_integrity.sh
```

3. Cron görevi olarak ekleyin:
```bash
sudo crontab -e
# Aşağıdaki satırı ekleyin:
0 0 * * * /opt/scripts/check_integrity.sh
```

## Kullanım

Script ilk çalıştırıldığında baseline oluşturur:
```bash
sudo /opt/scripts/check_integrity.sh
```

Sonraki çalıştırmalarda:
- Değişiklikleri kontrol eder
- Sonuçları /opt/scripts/integrity_report.txt dosyasına yazar

## Çıktı Örnekleri

[2024-02-20 00:00:01] Bütünlük Kontrolü Raporu:
----------------------------------------
DEĞİŞTİRİLDİ: /opt/scripts/config.sh
YENİ DOSYA: /opt/scripts/new_script.sh
SİLİNDİ: /opt/scripts/old_script.sh