# TAAE Tizimini Joylashtirish Yo'riqnomasi (`script` branch)

> Versiya: 1.0  Mualliflar: TAAE Loyihasi Jamoasi  Branch: `script`

---

## 1. Maqsad va umumiy ko'rinish

Ushbu hujjat **TAAE (Tarmoqni Avtomatlashtirilgan Audit)** tizimini `script` branchidan olib, real serverga to'liq joylashtirish bo'yicha bosqichma-bosqich yo'riqnomadir. U oddiy tarmoq administratori uchun mo'ljallangan: har bir komanda ishga tushiriladi va natijasi qanday ko'rinishi tushuntiriladi.

**Apparat bazasi:**

| Qurilma | Vazifasi | IP / VLAN |
|---------|----------|-----------|
| HP DL-160 Gen9 | TAAE monitoring serveri (Docker stack) | `10.0.10.10/24`, VLAN 10 |
| Catalyst 3560G | Asosiy access switch (managed, EEM bilan) | `10.0.99.2/24`, VLAN 99 (mgmt) |
| Cisco 1800 (router) | WAN ulanish, ACL/IPS asoslari | `10.0.99.1/24` |
| TP-Link TL-SF 1024D | Unmanaged switch (faqat fizik kengaytma) | yo'q (L2 transparent) |
| Foydalanuvchi PC / 1C host | Windows hostlar (TAAE Agent 2) | VLAN 20-30 |

**Fayllarning umumiy joylashuvi (repo-root ichida):**

| Maqsad | Yo'l |
|--------|------|
| Asosiy Docker stack | `docker-compose.yml`, `Dockerfile` |
| Tarmoq skriptlari va EEM | `scripts/` |
| Linux uchun TAAE Agent 2 paketi | `scripts/linux-agent/` |
| Switch/router config'lari | `scripts/network-configs/` |
| Windows agent binary | `bin/win64/taae_agent2.exe` |
| Agent config namunalari | `conf/taae_agent2.conf`, `conf/taae_agent2.d/` |
| Loglar (default) | `logs/` |

---

## 2. `script` branchini olish

DL-160 Gen9 serverida (Ubuntu 22.04 LTS o'rnatilgan deb taxmin qilamiz):

```bash
# 1) Klonlash
cd /opt
sudo git clone https://github.com/<your-org>/zoddix.git taae
sudo chown -R taae:taae /opt/taae

# 2) script branchiga o'tish
cd /opt/taae
git fetch origin
git checkout script
git pull origin script

# 3) Tekshirish
git status
git branch --show-current   # natija: script
git log -1 --oneline
```

Agar repo allaqachon klonlangan bo'lsa:

```bash
cd /opt/taae
git fetch origin script
git checkout script
git pull --ff-only origin script
git status
```

Kutilayotgan natija: `On branch script`, `nothing to commit, working tree clean` (yoki untracked fayllar mavjudligi haqida ogohlantirish).

---

## 3. DL-160 Gen9 — Server tomonida nima o'rnatiladi

| Komponent | Manba (repo'da) | Maqsadi |
|-----------|-----------------|---------|
| TAAE Server + Web (Docker) | `docker-compose.yml`, `Dockerfile` | Asosiy monitoring tizimi (PostgreSQL + server + frontend) |
| TAAE alert skriptlari | `scripts/alertscripts/` | Trigger ishga tushganda Telegram/Email/auto_remediation |
| TAAE external check skriptlari | `scripts/externalscripts/` | SNMP trap parsing, IP inventory |
| Provisioning skriptlari | `scripts/provisioning/` | Catalyst portlarini avtomatik sozlash |
| IPAM SQL schemasi | `scripts/sql/` | PostgreSQL'da `leases`, `port_security_events` va boshqa jadvallar |
| phpIPAM (ixtiyoriy) | `scripts/docker/docker-compose.phpipam.yml` | To'liq IPAM yechimi |
| TAAE Agent 2 (Linux) | `scripts/linux-agent/` | Serverning o'zini monitoring qilish uchun |

### 3.1 Asosiy o'rnatish (server bo'lib)

**1-qadam.** OS va apparat tayyorlash:

- Ubuntu Server 22.04 LTS o'rnatilgan
- Ikki disk RAID-1 da (HP Smart Array B140i orqali)
- Kamida 16 GB RAM, 250 GB disk

**2-qadam.** Statik IP sozlash (`/etc/netplan/01-netcfg.yaml`):

```yaml
network:
  version: 2
  ethernets:
    eno1:
      dhcp4: no
      addresses: [10.0.10.10/24]
      gateway4: 10.0.10.1
      nameservers:
        addresses: [10.0.10.1, 8.8.8.8]
```

```bash
sudo netplan apply
ip a show eno1
```

**3-qadam.** Kerakli paketlarni o'rnatish:

```bash
sudo apt update
sudo apt install -y docker.io docker-compose-plugin git python3-pip sqlite3 snmp snmp-mibs-downloader
sudo systemctl enable --now docker
sudo usermod -aG docker $USER     # qaytadan login qilish kerak
```

**4-qadam.** Loyihani klonlash va `script` branchiga o'tish (2-bo'limdan).

**5-qadam.** TAAE asosiy stackni ko'tarish:

```bash
cd /opt/taae
docker compose pull
docker compose up -d
docker compose ps
```

**6-qadam.** Web interfeysga kirish:

```
http://10.0.10.10:8098
```

Default kirish ma'lumotlari: `Admin / zabbix` (kirishdan keyin **darhol** parolni almashtirish: `Users -> Admin -> Change password`).

### 3.2 Skriptlarni o'rnatish

```bash
cd /opt/taae
sudo bash scripts/install.sh
```

`install.sh` quyidagilarni bajaradi:

- `/usr/lib/zabbix/alertscripts/` va `/usr/lib/zabbix/externalscripts/` papkalarini yaratadi
- `scripts/alertscripts/*` va `scripts/externalscripts/*` ni shu papkalarga **symlink** qiladi (bu — repo'ni `git pull` qilganda skriptlar avtomatik yangilanadi degani)
- `pip install -r scripts/requirements.txt` ni ishga tushiradi
- SQLite audit DB yaratadi: `/var/lib/taae/audit.db`
- `.env` faylni `scripts/docker/.env.example` dan `/etc/zabbix/.env` ga ko'chiradi va `chmod 600` qo'yadi

Tekshirish:

```bash
ls -la /usr/lib/zabbix/alertscripts/
ls -la /usr/lib/zabbix/externalscripts/
sqlite3 /var/lib/taae/audit.db ".tables"
sudo cat /etc/zabbix/.env | head -5
```

### 3.3 Linux TAAE Agent 2 ni serverning o'ziga o'rnatish

DL-160 ning o'zini ham monitoring qilish kerak (CPU, RAM, disk, Docker konteynerlar holati).

```bash
cd /opt/taae

# 1) Binary'ni build qilish (statik, amd64)
./scripts/linux-agent/build.sh --arch amd64 --static

# 2) systemd servis sifatida o'rnatish
sudo ./scripts/linux-agent/install.sh

# 3) Ishga tushirish
sudo systemctl daemon-reload
sudo systemctl enable --now taae-agent2
sudo systemctl status taae-agent2
```

Yoki Docker bilan (build talab qilmaydi):

```bash
docker compose -f docker-compose.yml -f scripts/linux-agent/docker-compose.taae-agent.yml up -d
docker compose ps | grep taae-agent
```

Loglar:

```bash
sudo journalctl -u taae-agent2 -n 50 --no-pager
sudo tail -f /var/log/taae/agent/taae_agent2.log
```

### 3.4 phpIPAM qo'shimcha (ixtiyoriy)

Agar batafsil IP-manzil boshqaruvi (IPAM) kerak bo'lsa:

```bash
cd /opt/taae
cp scripts/docker/.env.example scripts/docker/.env
# .env ni tahrirlash (DB parol, admin email va h.k.)
nano scripts/docker/.env

docker compose \
  -f docker-compose.yml \
  -f scripts/docker/docker-compose.phpipam.yml \
  up -d
```

URL: `http://10.0.10.10:8099`

---

## 4. Linux uchun TAAE Agent 2 — qaerda?

**Manba kodi:**
- `src/go/cmd/zabbix_agent2/` — Go ilovasi, TAAE brandlangan (`zabbix_agent2.go` ichida `"TAAE Agent 2"` matni)

**Linux paketi:**
- `scripts/linux-agent/build.sh` — Go kross-kompilyatsiyasi (amd64/arm64, statik linking)
- `scripts/linux-agent/taae_agent2.conf` — FHS yo'llari bilan namuna config
- `scripts/linux-agent/taae-agent2.service` — systemd unit fayl
- `scripts/linux-agent/install.sh`, `scripts/linux-agent/uninstall.sh`
- `scripts/linux-agent/Dockerfile`, `scripts/linux-agent/docker-compose.taae-agent.yml`
- Build natijasi: `scripts/linux-agent/dist/taae_agent2`

**O'rnatishdan keyin Linux FHS yo'llari:**

| Element | Linux yo'li |
|---------|-------------|
| Binary | `/usr/sbin/taae_agent2` |
| Asosiy config | `/etc/taae/agent/taae_agent2.conf` |
| Plugin/include configlar | `/etc/taae/agent/taae_agent2.d/*.conf` |
| Log fayl | `/var/log/taae/agent/taae_agent2.log` |
| Pid/socket | `/var/run/taae/agent/` |
| State (buffer, cache) | `/var/lib/taae/agent/` |
| systemd unit | `/etc/systemd/system/taae-agent2.service` |

Manual build misoli (boshqa Linux serverga ko'chirish uchun):

```bash
cd /opt/taae
./scripts/linux-agent/build.sh --arch amd64 --static
scp scripts/linux-agent/dist/taae_agent2 user@10.0.20.5:/tmp/
scp scripts/linux-agent/taae_agent2.conf user@10.0.20.5:/tmp/
scp scripts/linux-agent/install.sh user@10.0.20.5:/tmp/
# va o'sha hostda: sudo bash /tmp/install.sh
```

---

## 5. Windows uchun TAAE Agent 2 — qaerda?

| Element | Repo'dagi yo'l |
|---------|----------------|
| Binary (Windows x64) | `bin/win64/taae_agent2.exe` |
| Asosiy config namunasi | `conf/taae_agent2.conf` |
| Plugin includes | `conf/taae_agent2.d/` |
| Log (default) | `D:\TAAE\zoddix\logs\taae_agent2.log` (yoki sozlashga qarab) |
| Brand resurslari (icon, version-info) | `src/go/cmd/zabbix_agent2/resource.syso` |
| Brand qo'llanmasi | `TAAE_AGENT_REBRANDING_GUIDE_UZ.md` |

### 5.1 Windows hostga o'rnatish

**1-qadam.** Fayllarni ko'chirish (administrator PowerShell yoki RDP orqali):

```powershell
New-Item -ItemType Directory -Force -Path 'C:\Program Files\TAAE\Agent'
Copy-Item .\bin\win64\taae_agent2.exe 'C:\Program Files\TAAE\Agent\'
Copy-Item .\conf\taae_agent2.conf 'C:\Program Files\TAAE\Agent\'
Copy-Item .\conf\taae_agent2.d -Recurse 'C:\Program Files\TAAE\Agent\'
New-Item -ItemType Directory -Force -Path 'C:\ProgramData\TAAE\Agent\logs'
```

**2-qadam.** Config'ni tahrirlash (`C:\Program Files\TAAE\Agent\taae_agent2.conf`):

```ini
Server=10.0.10.10
ServerActive=10.0.10.10
Hostname=PC-BUH-01
LogFile=C:\ProgramData\TAAE\Agent\logs\taae_agent2.log
LogFileSize=10
```

**3-qadam.** Servisni o'rnatish (Administrator PowerShell):

```powershell
Set-Location 'C:\Program Files\TAAE\Agent'
.\taae_agent2.exe --install --config 'C:\Program Files\TAAE\Agent\taae_agent2.conf'
Start-Service "TAAE Agent 2"
Get-Service "TAAE Agent 2"
```

**4-qadam.** Firewall qoidasini qo'shish (passive check uchun):

```powershell
New-NetFirewallRule -DisplayName "TAAE Agent 2" `
  -Direction Inbound -Protocol TCP -LocalPort 10050 -Action Allow
```

**5-qadam.** Tekshirish (DL-160 dan):

```bash
# Server tomondan:
zabbix_get -s 10.0.20.50 -k agent.ping
# Natija: 1
zabbix_get -s 10.0.20.50 -k agent.version
# Natija: TAAE Agent 2 6.x.x
```

---

## 6. Apparat-bo'yicha taqsimlash xulosasi

| Qurilma | Nima ketadi (qaysi fayl/manba) | O'rnatish usuli |
|---------|--------------------------------|-----------------|
| **DL-160 Gen9 (TAAE server)** | Docker stack (`docker-compose.yml`), `scripts/` to'liq, Linux agent (`scripts/linux-agent/`), ixtiyoriy phpIPAM | `git clone` + `docker compose up -d` + `scripts/install.sh` |
| **Catalyst 3560G** | `scripts/network-configs/catalyst-3560g.cfg` + 3 ta EEM applet: `port_sec_violation.tcl`, `stp_loop_detect.tcl`, `export_binding_hourly.tcl` | TFTP/SCP orqali yuklash, keyin `copy running-config startup-config` |
| **Cisco 1800 (router)** | `scripts/network-configs/cisco-1800.cfg` + `wan_brute_detect.tcl` EEM applet | TFTP/SCP orqali |
| **TP-Link TL-SF 1024D** | **Hech qanday script borib bo'lmaydi** (unmanaged) | Faqat Catalyst 3560G `Gi0/25` uplink portida `storm-control`, `port-security maximum 24`, `bpduguard enable` cheklash |
| **Windows host (PC, server)** | `bin/win64/taae_agent2.exe` + `conf/taae_agent2.conf` | PowerShell orqali (5.1-bo'limda) |
| **Linux host (qo'shimcha serverlar)** | `scripts/linux-agent/` orqali build + install yoki Docker | `build.sh` + `install.sh`, yoki `docker compose up -d` |

**Switch'larga skriptlarni ko'chirish misoli (TFTP orqali):**

```bash
# DL-160 da TFTP server (allaqachon ishlayotgan deb hisoblaymiz)
sudo cp scripts/network-configs/catalyst-3560g.cfg /srv/tftp/
sudo cp scripts/network-configs/eem/port_sec_violation.tcl /srv/tftp/
```

Catalyst 3560G konsolida:

```cisco
Switch# copy tftp://10.0.10.10/catalyst-3560g.cfg running-config
Switch# copy tftp://10.0.10.10/port_sec_violation.tcl flash:/
Switch(config)# event manager directory user policy "flash:/"
Switch(config)# event manager policy port_sec_violation.tcl
Switch# write memory
```

---

## 7. Tekshirish ro'yxati (Post-install checklist)

- [ ] `docker compose ps` — barcha konteynerlar **`Up`** holatida (taae-server, taae-web, taae-db)
- [ ] Web `http://10.0.10.10:8098` ochiladi va Admin paroli o'zgartirilgan
- [ ] `systemctl status taae-agent2` (server lokal agenti) **`active (running)`**
- [ ] Switch'larda `show snmp host` natijasida `10.0.10.10` ko'rinmoqda
- [ ] TAAE UI da `Monitoring -> Latest data` dan switch metrikalari kelmoqda (CPU, interface bayt'lari)
- [ ] Telegram bot test xabarini yubordi (`Administration -> Media types -> Telegram -> Test`)
- [ ] `docker compose exec taae-db psql -U taae -d taae -c "select count(*) from leases;"` — qiymat > 0
- [ ] Test loop (ikkita patchcord'ni TP-Link'ga ulash) yaratganda BPDU guard ishga tushadi va TAAE alert keladi
- [ ] Windows hostlarda `Get-Service "TAAE Agent 2"` **`Running`**
- [ ] Router'da `show event manager policy registered` natijasida `wan_brute_detect.tcl` ko'rinmoqda

---

## 8. Tez-tez berilgan savollar / muammolar

**1. "Docker konteyner ko'tarilmayapti"**
```bash
docker compose logs taae-server --tail=100
docker compose logs taae-db --tail=100
# 99% holatda — `.env` da DB parol noto'g'ri yoki port 8098 band
sudo ss -tlnp | grep 8098
```

**2. "Switch SNMP ulanmayapti"**
```bash
# DL-160 dan tekshirish:
snmpwalk -v3 -l authPriv \
  -u taae_user -a SHA -A 'AuthPass123!' \
  -x AES -X 'PrivPass456!' \
  10.0.99.2 sysDescr.0
```
Agar timeout bo'lsa — switch'da `show snmp user`, `show running | section snmp` ni tekshirish.

**3. ".env fayl topilmadi"**
```bash
cp scripts/docker/.env.example scripts/docker/.env
nano scripts/docker/.env   # parol va tokenlarni o'zgartirish
chmod 600 scripts/docker/.env
```

**4. "Linux agentda permission denied"**
```bash
# SELinux/AppArmor test uchun:
sudo setenforce 0           # Vaqtinchalik (RHEL/CentOS)
sudo aa-status              # Ubuntu da AppArmor
# Doimiy yechim — semanage qoidasi yoki AppArmor profil tahrirlash
```

**5. "Windows agent xizmati start bo'lmayapti"**
- Event Viewer: `Windows Logs -> Application` da `TAAE Agent 2` xatolarini ko'rish
- Config sintaksi: `taae_agent2.exe --print` orqali tekshirish
- Log fayl yo'li yozilishi mumkin emas (papka mavjudligini tekshirish)

**6. "EEM applet ishlamayapti"**
```cisco
Switch# show event manager policy registered
Switch# show event manager history events
Switch# debug event manager all
```

---

## 9. Yo'l xaritasi va keyingi qadamlar

- **TP-Link TL-SF 1024D ni almashtirish** — managed switch (masalan TP-Link **T1600G-28** yoki Cisco SG350) ga o'tish, shunda taqsimlangan port-level monitoring va `port-security` qo'llab-quvvatlanadi.
- **TAAE Agent 2 ni `1C` hostiga o'rnatish** — Windows yoki Linux versiyasiga qarab 4 yoki 5 bo'limni qo'llash, qo'shimcha userparameter (1C ish jarayonlari, blokirovkalar).
- **Custom dashboard'lar** — TAAE UI da `Halqa hodisalari`, `Port security violations`, `WAN brute-force urinishlari` panellari.
- **HA (yuqori mavjudlik)** — ikkinchi TAAE server (PostgreSQL streaming replication, `keepalived` yoki HAProxy bilan VIP).
- **Centralized log** — `rsyslog` yoki Loki + Grafana qo'shilishi (switch loglarini bir joyga to'plash).
- **Avtomatik backup** — `pg_dump` + `restic` kombinatsiyasi orqali ofsayt backup (NAS yoki S3-mos saqlash).

---

> Hujjat oxiri. Savollar yoki tuzatishlar uchun: `git issue` yoki TAAE loyihasi jamoasiga murojaat qiling.
