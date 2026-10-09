-- =============================================================================
-- TAA - bazadagi foydalanuvchiga ko'rinadigan "Zabbix" nomlarini to'liq olib
-- tashlash.
--
-- Yangi o'rnatishda docker-entrypoint-initdb.d orqali 01-restore.sql va
-- 02-rebrand-taa.sql dan keyin avtomatik ishlaydi. Mavjud bazada qo'lda:
--   docker exec -i taa-db psql -U taa -d taa < 03-taa-full-rebrand.sql
-- Qayta ishga tushirish xavfsiz (idempotent).
--
-- TEGILMAYDI (funksional):
--   items.key_, items.params, item_preproc.params, media_type.script,
--   media_type_param.name, triggers.expression - ichida Zabbix.log() kabi
--   JavaScript API chaqiruvlari va item kalitlari (zabbix[...]) bor.
-- =============================================================================

BEGIN;

-- Shablon/host texnik nomida qavs bo'lmasligi kerak: 02-rebrand-taa.sql
-- "Windows (TAA agent orqali)" kabi nomlar yaratgan, ular trigger
-- ifodalarini buzadi ("expression maydoni uchun noto'g'ri qiymat").
UPDATE hosts SET host = translate(host, '()', '')
  WHERE status = 3 AND host ~ '[()]';

-- Host va shablonlar
UPDATE hosts SET host = replace(host, 'Zabbix', 'TAA') WHERE host LIKE '%Zabbix%';
UPDATE hosts SET name = replace(name, 'Zabbix', 'TAA') WHERE name LIKE '%Zabbix%';
UPDATE hosts SET description = replace(description, 'Zabbix', 'TAA') WHERE description LIKE '%Zabbix%';
UPDATE hosts SET name_upper = upper(name) WHERE name_upper <> upper(name);

-- Itemlar va triggerlar (faqat nom/izoh, kalit va ifodalar emas)
UPDATE items SET name = replace(name, 'Zabbix', 'TAA') WHERE name LIKE '%Zabbix%';
UPDATE items SET description = replace(description, 'Zabbix', 'TAA') WHERE description LIKE '%Zabbix%';
UPDATE item_rtname SET name_resolved = replace(name_resolved, 'Zabbix', 'TAA') WHERE name_resolved LIKE '%Zabbix%';
UPDATE item_rtname SET name_resolved_upper = upper(name_resolved) WHERE name_resolved_upper <> upper(name_resolved);
UPDATE triggers SET description = replace(description, 'Zabbix', 'TAA') WHERE description LIKE '%Zabbix%';
UPDATE triggers SET comments = replace(comments, 'Zabbix', 'TAA') WHERE comments LIKE '%Zabbix%';
UPDATE triggers SET event_name = replace(event_name, 'Zabbix', 'TAA') WHERE event_name LIKE '%Zabbix%';
UPDATE triggers SET opdata = replace(opdata, 'Zabbix', 'TAA') WHERE opdata LIKE '%Zabbix%';
UPDATE graphs SET name = replace(name, 'Zabbix', 'TAA') WHERE name LIKE '%Zabbix%';
UPDATE httptest SET name = replace(name, 'Zabbix', 'TAA') WHERE name LIKE '%Zabbix%';
-- Web-stsenariy User-Agent (tekshirilayotgan saytlarga yuboriladi)
UPDATE httptest SET agent = 'TAA' WHERE agent = 'Zabbix';
ALTER TABLE httptest ALTER COLUMN agent SET DEFAULT 'TAA';

-- Hodisalar va muammolar (oldin yaratilganlari ham)
UPDATE events SET name = replace(name, 'Zabbix', 'TAA') WHERE name LIKE '%Zabbix%';
UPDATE problem SET name = replace(name, 'Zabbix', 'TAA') WHERE name LIKE '%Zabbix%';

-- Makrolar
UPDATE hostmacro SET description = replace(description, 'Zabbix', 'TAA') WHERE description LIKE '%Zabbix%';
UPDATE globalmacro SET description = replace(description, 'Zabbix', 'TAA') WHERE description LIKE '%Zabbix%';
UPDATE hostmacro SET value = 'TAA/7.0'
  WHERE macro = '{$GITHUB.USER_AGENT}' AND value LIKE 'Zabbix%';

-- Qiymat xaritalari
UPDATE valuemap SET name = replace(name, 'Zabbix', 'TAA') WHERE name LIKE '%Zabbix%';
UPDATE valuemap_mapping SET newvalue = replace(newvalue, 'Zabbix', 'TAA') WHERE newvalue LIKE '%Zabbix%';

-- Media turlari: nom, izoh, xabar shablonlari va tashqi xizmatlarga
-- yuboriladigan qiymatlar (parametr NOMLARI o'zgarmaydi - skript ularni o'qiydi)
UPDATE media_type SET name = replace(name, 'Zabbix', 'TAA') WHERE name LIKE '%Zabbix%';
UPDATE media_type SET description = replace(description, 'Zabbix', 'TAA') WHERE description LIKE '%Zabbix%';
UPDATE media_type_message SET subject = replace(subject, 'Zabbix', 'TAA') WHERE subject LIKE '%Zabbix%';
UPDATE media_type_message SET message = replace(message, 'Zabbix', 'TAA') WHERE message LIKE '%Zabbix%';
UPDATE media_type_param SET value = 'TAAServer (7.0)' WHERE value = 'ZabbixServer (zabbix.com, 7.0)';
UPDATE media_type_param SET value = replace(value, 'Zabbix sever', 'TAA server') WHERE value LIKE '%Zabbix sever%';
UPDATE media_type_param SET value = replace(value, 'Zabbix', 'TAA') WHERE value LIKE '%Zabbix%';

-- Actionlar va xabarlar
UPDATE actions SET name = replace(name, 'Zabbix', 'TAA') WHERE name LIKE '%Zabbix%';
UPDATE opmessage SET subject = replace(subject, 'Zabbix', 'TAA') WHERE subject LIKE '%Zabbix%';
UPDATE opmessage SET message = replace(message, 'Zabbix', 'TAA') WHERE message LIKE '%Zabbix%';
UPDATE scripts SET name = replace(name, 'Zabbix', 'TAA') WHERE name LIKE '%Zabbix%';
UPDATE scripts SET description = replace(description, 'Zabbix', 'TAA') WHERE description LIKE '%Zabbix%';

-- Dashboardlar, kartalar, rasmlar
UPDATE dashboard SET name = replace(name, 'Zabbix', 'TAA') WHERE name LIKE '%Zabbix%';
UPDATE dashboard_page SET name = replace(name, 'Zabbix', 'TAA') WHERE name LIKE '%Zabbix%';
UPDATE widget SET name = replace(name, 'Zabbix', 'TAA') WHERE name LIKE '%Zabbix%';
UPDATE sysmaps SET name = replace(name, 'Zabbix', 'TAA') WHERE name LIKE '%Zabbix%';
UPDATE images SET name = replace(name, 'Zabbix', 'TAA') WHERE name LIKE '%Zabbix%';

-- Guruhlar, foydalanuvchilar, rollar
UPDATE hstgrp SET name = replace(name, 'Zabbix', 'TAA') WHERE name LIKE '%Zabbix%';
UPDATE usrgrp SET name = replace(name, 'Zabbix', 'TAA') WHERE name LIKE '%Zabbix%';
UPDATE role SET name = replace(name, 'Zabbix', 'TAA') WHERE name LIKE '%Zabbix%';
UPDATE users SET name = replace(name, 'Zabbix', 'TAA') WHERE name LIKE '%Zabbix%';
UPDATE users SET surname = replace(surname, 'Zabbix', 'TAA') WHERE surname LIKE '%Zabbix%';
UPDATE regexps SET name = replace(name, 'Zabbix', 'TAA') WHERE name LIKE '%Zabbix%';
UPDATE services SET name = replace(name, 'Zabbix', 'TAA') WHERE name LIKE '%Zabbix%';

COMMIT;
