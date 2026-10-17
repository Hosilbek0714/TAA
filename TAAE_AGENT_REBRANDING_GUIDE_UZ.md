# TAAE Agent: O‘zbekcha versiyaga moslashtirish va TAAE logo/ikonka almashtirish bo‘yicha batafsil yo‘riqnoma


1) Maqsad va doira
- Maqsad: Agent komponentini to‘liq TAAE brendiga moslashtirish (nomlar, fayl joylari, servis identifikatori, paketlash, installer/ikonka), Uzbek tilidagi hujjatlar va operatorlar uchun yo‘riqnomalar bilan ta’minlash. 
- Doira: 
  - Agent (klassik C agentd) va Agent2 (Go) uchun umumiy siyosat. 
  - Linux va Windows muhitlari. 
  - Docker konteyner varianti. 
  - Tarmoq xavfsizligi (TLS), avtoregistratsiya va TAAE server bilan hamkorlik. 
- Cheklovlar: Agentning protokoli, API va diagnostika formatlari moslik uchun asosan inglizcha qoladi. Operator va installer darajasida o‘zbekcha matnlar tavsiya etiladi.


2) Talablar va qarorlar
- Brend identifikatori: "TAAE Agent" (agentd) va "TAAE Agent2" (agent2). 
- Servis va paket nomlari: taae-agent, taae-agent2 (Windows servis nomlari ham TAAE bilan mos). 
- Fayl joylari siyosati (Linux): 
  - Konfiguratsiya: /etc/taae/agent/ 
  - Loglar: /var/log/taae/agent/ 
  - PID: /var/run/taae/agent/ 
  - Holat/keş: /var/lib/taae/agent/ 
- Fayl joylari siyosati (Windows): 
  - Konfiguratsiya: o‘rnatish katalogida 
  - Log/holat: C:\ProgramData\TAAE\Agent\ 
- Tarmoq portlari: 
  - Passive checks: agent tinglaydigan port (standart 10050) 
  - Active checks: server tomon ulanish (10051), agent tinglash shart emas 
- Xavfsizlik: TLS PSK yoki Sertifikatli TLS. 
- Log va telemetriya: "TAAE Agent" prefiksi, versiya va identifikatsiya izchil bo‘lsin. 


3) Rebrending ob’yektlari (nimalarni o‘zgartiramiz)
- Nomlar va ko‘rinadigan matnlar: 
  - Binar va servis ko‘rinadigan nomi: TAAE → TAAE. 
  - Paket nomi va tavsifi: zabbix-agent → taae-agent; zabbix-agent2 → taae-agent2. 
  - Systemd service DisplayName/Description: TAAE Agent. 
  - Windows Service DisplayName/Description: TAAE Agent, TAAE Agent2. 
- Fayl va kataloglar: yuqoridagi siyosatga mos yo‘llarga o‘tkazish. 
- Log bannerlari va versiya chiqishlari: "TAAE Agent vX.Y" kabi izchil identifikatsiya. 
- Installer va distributivlar: 
  - Linux: .deb/.rpm paket nomlari, paket ma’lumotlari (maintainer, description) TAAE bilan mos. 
  - Windows: MSI/ZIP nomlash, brend matnlari (ProductName, Manufacturer), ikonkalar. 
- Docker imiji: 
  - Nomlash: taae/agent yoki taae/agent2. 
  - Ta’rif: imij tavsifi va label-lar TAAE bilan mos. 


4) O‘zbekcha moslashtirish (lokalizatsiya siyosati)
- Agent loglari: ichki diagnostika inglizcha qolishi tavsiya etiladi (troubleshooting uchun standart). 
- Operator hujjatlari: o‘rnatish, sozlash, ishlatish bo‘yicha yo‘riqnomalar to‘liq o‘zbekcha. 
- Installer matnlari (Windows): Setup bosqichlari, xatolik/habarnomalar o‘zbekcha bo‘lishi mumkin. 
- Konfiguratsiya fayllari: kommentariyalar o‘zbekcha bo‘lishi mumkin, ammo parametr kalitlari o‘zgarmaydi. 
- UI terminlari: Server UI tomonda "TAAE agent" atamalari o‘rniga "TAAE Agent" ko‘rsatilishi kerak (server rebrending siyosati bilan mos). 


5) TAAE logo va ikonkalarni almashtirish
- Maqsad: Agent bilan bog‘liq ko‘rinadigan barcha komponentlarda TAAE logotipi va ikonkalar ishlatilishi. 
- Qamrov: 
  - Windows installer: Setup banner, product icon, uninstaller icon. 
  - Paket metadata (Linux): paket logotipi odatda ko‘rinmaydi, ammo hujjatlarda va ombor (repo) sahifalarida TAAE logosi ishlatiladi. 
  - Docker: Docker Hub sahifasi va README illyustratsiyasi TAAE logosi bilan. 
  - Ichki hujjatlar: PDF/rasm aktivlarida TAAE logosi. 
- Aktivlar manzili: 
  - Repository ichida assets/ katalogi (logo.svg, favicon.ico va kerakli rasmlar). 
  - Installerga mos formatlar: .ico, .bmp, .png (hajmlar mos kelishi shart). 
- Vizual talablar: 
  - Asosiy logo: 114×30 px (yoki yuqori aniqlikda proporsional). 
  - Sidebar/compact: 91×24 px va 24×24 px variantlar. 
  - Favicon/ico: 16×16, 32×32, 48×48 qatlamlar. 
- Sifat nazorati: Kattalik, kontrast, qorong‘i/yorug‘ fonlardagi differensiya, DPI mosligi tekshiriladi. 


6) Dockerda agentni ko‘tarish (konsepsiya va siyosat)
- Tarmoq: 
  - Passive checks: agent portini (10050) hostga ochish kerak. 
  - Active checks: port ochish shart emas; serverga chiqish yo‘li bo‘lsa kifoya. 
- Volyumlar: 
  - /etc/taae/agent – konfiguratsiya. 
  - /var/log/taae/agent – loglar. 
  - /var/lib/taae/agent – holat/keş. 
- Sog‘liq nazorati: 
  - Oddiy healthcheck: agent ish holati va server bilan aloqa mavjudligi tekshiriladi. 
- Restart siyosati: always yoki unless-stopped. 
- Xavfsizlik: Faqat zarur ruxsat va capabilitiy lar. 
- Identifikatsiya: 
  - Hostname – serverdagi host nomiga aynan mos bo‘lsin. 
  - Metadata – auto-registration uchun mos kalitlar. 


7) Linuxga o‘rnatish (bare-metal/VM)
- Paketlash va nomlash: taae-agent, taae-agent2 nomlari; description va vendor maydonlari TAAE bilan mos. 
- Foydalanuvchi/kataloglar: taae-agent foydalanuvchisi; /etc/taae/agent, /var/log/taae/agent, /var/lib/taae/agent, /var/run/taae/agent kataloglari va ruxsatlar. 
- Servis: TAAE Agent systemd birligi (enable/start); description TAAE bilan mos. 
- Firewall: Passive checks bo‘lsa 10050 inbound ruxsat; active checks uchun outbound ruxsat. 
- SELinux/AppArmor: Log/konf yo‘llari uchun mos profil/label lar. 


8) Windowsga o‘rnatish (bare-metal/VM)
- Installer: MSI yoki ZIP distributiv. ProductName – TAAE Agent; Manufacturer – TAAE. 
- Servis: Windows Service nomi va tavsifi TAAE bilan mos; service install va start. 
- Fayl joylari: Konf – o‘rnatish katalogida; Log/State – ProgramData\TAAE\Agent\ 
- Firewall: Passive checks da inbound ruxsat (10050); Active checks uchun outbound yetarli. 
- Ruxsatlar: Sertifikat/PSK fayllari faqat Administrator o‘qiy oladigan joyda saqlansin. 


9) TAAE server bilan hamkorlik va sozlash
- Passive checks: 
  - Server agent IP/portiga ucha olishi kerak; Host interfeysi to‘g‘ri kiritiladi. 
- Active checks: 
  - ServerActive – TAAE server FQDN/IP. 
  - Hostname – UI dagi nom bilan aynan bir xil bo‘lsin. 
  - Auto-registration – metadata asosida serverda host yaratish va shablon biriktirish. 
- TLS: 
  - PSK: Identity va PSK matni server va agentda aynan mos. 
  - Sertifikat: CA, sertifikat va kalit yo‘llari to‘g‘ri; muddat va vaqt sinxroni tekshiriladi. 


10) Xavfsizlik siyosati
- TLS ni majburiy qilish: PSK yoki sertifikat. 
- Allowed serverlar ro‘yxatini minimal darajada cheklash. 
- Remote buyruqlarni o‘chirish yoki qat’iy cheklash. 
- Fayl ruxsatlari: konf/log/state kataloglari minimal huquqlar bilan. 
- Sirlarni boshqarish: PSK/kalit/sertifikatlarni maxfiy boshqaruv tizimida saqlash. 


11) Avtoregistratsiya siyosati (Active checks tavsiya)
- Agent metadata: rol (db, web, app), muhit (prod, stage, dev), lokatsiya (DC1, Cloud) kabi kalitlar. 
- Server Action: metadata shartlariga ko‘ra host yaratish, guruhga qo‘shish, shablon biriktirish. 
- Standart: yagona metadata format va nomlash konvensiyasi tasdiqlansin. 


12) Test va verifikatsiya
- Log tahlili: agent start, serverga ulanish, TLS qo‘l siqish (handshake) natijalarini logda tekshirish. 
- Tarmoq: passive da 10050 ochiqligi; active da serverga chiqish yo‘li. 
- UI: Host availability yashil bo‘lishi, asosiy metrikalar kelishi. 
- Diagnostika: Unsupported elementlar sababi logda; ruxsat va yo‘l muammolarini tekshirish. 


13) Migratsiya (TAAE agent → TAAE Agent)
- Nomlash: eskining parallel ishlashi uchun vaqtinchalik strategiya; downtime minimal bo‘lsin. 
- Konf ko‘chirish: Server/ServerActive, Hostname, TLS parametrlarini mos holda ko‘chiring. 
- Sinov: avval dev/sinov muhitda, so‘ng bosqichma-bosqich produktsiyaga. 
- Rollback: muammo bo‘lsa, eski agentga qaytish imkoniyati saqlansin. 


14) Ishlab chiqarishdagi eng yaxshi amaliyotlar
- Versiya boshqaruvi: agent va server versiya mosligi; rejalashtirilgan yangilash. 
- Resurslar: log rotate siyosati; resurs limitlari; kuzatuv elementlari. 
- Audit: konfiguratsiya o‘zgarishlari audit trail; markaziy log yig‘ish bo‘lsa, integratsiya. 


15) Cheklistlar (amaliy nazorat ro‘yxatlari)
- Rebrending cheklist: 
  - Nomlar (binar, servis, paket) TAAE ga o‘tgani. 
  - Fayl joylari siyosati tatbiq etilgani. 
  - Installer/ikonka/logotiplar almashtirilgani. 
  - Docker imiji, tavsif va label-lar yangilangani. 
  - Hujjatlar o‘zbekcha yangilangani. 
- Integratsiya cheklist: 
  - Hostname mosligi; metadata siyosati. 
  - Passive/Active rejim tanlovi; portlar va firewall sozlamalari. 
  - TLS (PSK yoki sertifikat) mosligi. 
  - Serverdagi shablonlar biriktirilgani. 
- Sinov cheklist: 
  - Loglarda xatolik yo‘qligi. 
  - UI da availability yashil. 
  - Asosiy metrikalar kelmoqda. 
  - Troubleshooting ssenariylari ishlaydi. 


16) Nomlash va katalog siyosati (mos kelish jadvali)
- Agent nomlari: TAAE Agent → TAAE Agent; TAAE Agent2 → TAAE Agent2. 
- Paket nomlari: zabbix-agent → taae-agent; zabbix-agent2 → taae-agent2. 
- Linux kataloglari: 
  - /etc/zabbix → /etc/taae/agent 
  - /var/log/zabbix → /var/log/taae/agent 
  - /var/lib/zabbix → /var/lib/taae/agent 
  - /var/run/zabbix → /var/run/taae/agent 
- Windows yo‘llari: 
  - ProgramData\TAAE → ProgramData\TAAE\Agent 
  - Service DisplayName: "TAAE Agent" → "TAAE Agent" 


17) Hujjatlash va tarqatish
- Ichki standart hujjat: ushbu yo‘riqnoma asosiy manba sifatida qabul qilinsin. 
- Operatorlar uchun qisqa yo‘riqnoma: 10–15 qadamli tezkor qo‘llanma. 
- Tarqatish: CI/CD (Docker imijlari), konfiguratsiya boshqaruvi (Ansible/Puppet/Salt), paket repolari. 
- Versiya va o‘zgarishlar jurnali: rebrendingga tegishli o‘zgarishlar ChangeLog da qayd etilsin. 


18) Qo‘llab-quvvatlash va eskalatsiya
- Muammo triaji: tarmoq → TLS → Hostname/Metadata → ruxsat → shablon/elementlar tartibida tekshirish. 
- Eskalatsiya mezonlari: keng ko‘lamdagi ulanish xatolari, TLS sertifikat muddatlari, agent mass restartlar. 
- Aloqa kanali: ichki monitoring guruhlari va voqea kuzatuv tizimi. 


19) Qo‘shimcha tavsiyalar
- Uzoq muddatli xavfsizlik uchun sertifikatga asoslangan TLS ni joriy etish rejasini tuzing. 
- Auto-registration siyosatini qat’iylashtirib, guruhlash/shablon biriktirishni avtomatlashtiring. 
- Windows va Linux muhitlarida bir xil metadata strategiyasi qo‘llang. 
- Paketlar va imijlarda SBOM va imzolash (signing) siyosatini ko‘rib chiqing. 


20) Yakuniy natija
- TAAE Agent(lar) to‘liq rebrend qilingan, operatorlar uchun o‘zbekcha hujjatlar tayyor, installer/ikonka/aktivlar almashtirilgan, Docker va bare-metal o‘rnatish ssenariylari ishlab chiqilgan, TAAE server bilan xavfsiz va barqaror hamkorlik yo‘lga qo‘yilgan bo‘ladi.
