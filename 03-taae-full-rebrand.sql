-- =============================================================================
-- TAAE - bazadagi foydalanuvchiga ko'rinadigan "Zabbix" nomlarini to'liq olib
-- tashlash.
--
-- Yangi o'rnatishda docker-entrypoint-initdb.d orqali 01-restore.sql va
-- 02-rebrand-taae.sql dan keyin avtomatik ishlaydi. Mavjud bazada qo'lda:
--   docker exec -i taae-db psql -U taae -d taae < 03-taae-full-rebrand.sql
-- Qayta ishga tushirish xavfsiz (idempotent).
--
-- TEGILMAYDI (funksional):
--   items.key_, items.params, item_preproc.params, media_type.script,
--   media_type_param.name, triggers.expression - ichida Zabbix.log() kabi
--   JavaScript API chaqiruvlari va item kalitlari (zabbix[...]) bor.
-- =============================================================================

BEGIN;

-- Shablon/host texnik nomida qavs bo'lmasligi kerak: 02-rebrand-taae.sql
-- "Windows (TAAE agent orqali)" kabi nomlar yaratgan, ular trigger
-- ifodalarini buzadi ("expression maydoni uchun noto'g'ri qiymat").
UPDATE hosts SET host = translate(host, '()', '')
  WHERE status = 3 AND host ~ '[()]';

-- Host va shablonlar
UPDATE hosts SET host = replace(host, 'Zabbix', 'TAAE') WHERE host LIKE '%Zabbix%';
UPDATE hosts SET name = replace(name, 'Zabbix', 'TAAE') WHERE name LIKE '%Zabbix%';
UPDATE hosts SET description = replace(description, 'Zabbix', 'TAAE') WHERE description LIKE '%Zabbix%';
UPDATE hosts SET name_upper = upper(name) WHERE name_upper <> upper(name);

-- Itemlar va triggerlar (faqat nom/izoh, kalit va ifodalar emas)
UPDATE items SET name = replace(name, 'Zabbix', 'TAAE') WHERE name LIKE '%Zabbix%';
UPDATE items SET description = replace(description, 'Zabbix', 'TAAE') WHERE description LIKE '%Zabbix%';
UPDATE item_rtname SET name_resolved = replace(name_resolved, 'Zabbix', 'TAAE') WHERE name_resolved LIKE '%Zabbix%';
UPDATE item_rtname SET name_resolved_upper = upper(name_resolved) WHERE name_resolved_upper <> upper(name_resolved);
UPDATE triggers SET description = replace(description, 'Zabbix', 'TAAE') WHERE description LIKE '%Zabbix%';
UPDATE triggers SET comments = replace(comments, 'Zabbix', 'TAAE') WHERE comments LIKE '%Zabbix%';
UPDATE triggers SET event_name = replace(event_name, 'Zabbix', 'TAAE') WHERE event_name LIKE '%Zabbix%';
UPDATE triggers SET opdata = replace(opdata, 'Zabbix', 'TAAE') WHERE opdata LIKE '%Zabbix%';
UPDATE graphs SET name = replace(name, 'Zabbix', 'TAAE') WHERE name LIKE '%Zabbix%';
UPDATE httptest SET name = replace(name, 'Zabbix', 'TAAE') WHERE name LIKE '%Zabbix%';
-- Web-stsenariy User-Agent (tekshirilayotgan saytlarga yuboriladi)
UPDATE httptest SET agent = 'TAAE' WHERE agent = 'Zabbix';
ALTER TABLE httptest ALTER COLUMN agent SET DEFAULT 'TAAE';

-- Hodisalar va muammolar (oldin yaratilganlari ham)
UPDATE events SET name = replace(name, 'Zabbix', 'TAAE') WHERE name LIKE '%Zabbix%';
UPDATE problem SET name = replace(name, 'Zabbix', 'TAAE') WHERE name LIKE '%Zabbix%';

-- Makrolar
UPDATE hostmacro SET description = replace(description, 'Zabbix', 'TAAE') WHERE description LIKE '%Zabbix%';
UPDATE globalmacro SET description = replace(description, 'Zabbix', 'TAAE') WHERE description LIKE '%Zabbix%';
UPDATE hostmacro SET value = 'TAAE/7.0'
  WHERE macro = '{$GITHUB.USER_AGENT}' AND value LIKE 'Zabbix%';

-- Qiymat xaritalari
UPDATE valuemap SET name = replace(name, 'Zabbix', 'TAAE') WHERE name LIKE '%Zabbix%';
UPDATE valuemap_mapping SET newvalue = replace(newvalue, 'Zabbix', 'TAAE') WHERE newvalue LIKE '%Zabbix%';

-- Media turlari: nom, izoh, xabar shablonlari va tashqi xizmatlarga
-- yuboriladigan qiymatlar (parametr NOMLARI o'zgarmaydi - skript ularni o'qiydi)
UPDATE media_type SET name = replace(name, 'Zabbix', 'TAAE') WHERE name LIKE '%Zabbix%';
UPDATE media_type SET description = replace(description, 'Zabbix', 'TAAE') WHERE description LIKE '%Zabbix%';
UPDATE media_type_message SET subject = replace(subject, 'Zabbix', 'TAAE') WHERE subject LIKE '%Zabbix%';
UPDATE media_type_message SET message = replace(message, 'Zabbix', 'TAAE') WHERE message LIKE '%Zabbix%';
UPDATE media_type_param SET value = 'TAAServer (7.0)' WHERE value = 'ZabbixServer (zabbix.com, 7.0)';
UPDATE media_type_param SET value = replace(value, 'Zabbix sever', 'TAAE server') WHERE value LIKE '%Zabbix sever%';
UPDATE media_type_param SET value = replace(value, 'Zabbix', 'TAAE') WHERE value LIKE '%Zabbix%';

-- Actionlar va xabarlar
UPDATE actions SET name = replace(name, 'Zabbix', 'TAAE') WHERE name LIKE '%Zabbix%';
UPDATE opmessage SET subject = replace(subject, 'Zabbix', 'TAAE') WHERE subject LIKE '%Zabbix%';
UPDATE opmessage SET message = replace(message, 'Zabbix', 'TAAE') WHERE message LIKE '%Zabbix%';
UPDATE scripts SET name = replace(name, 'Zabbix', 'TAAE') WHERE name LIKE '%Zabbix%';
UPDATE scripts SET description = replace(description, 'Zabbix', 'TAAE') WHERE description LIKE '%Zabbix%';

-- Dashboardlar, kartalar, rasmlar
UPDATE dashboard SET name = replace(name, 'Zabbix', 'TAAE') WHERE name LIKE '%Zabbix%';
UPDATE dashboard_page SET name = replace(name, 'Zabbix', 'TAAE') WHERE name LIKE '%Zabbix%';
UPDATE widget SET name = replace(name, 'Zabbix', 'TAAE') WHERE name LIKE '%Zabbix%';
UPDATE sysmaps SET name = replace(name, 'Zabbix', 'TAAE') WHERE name LIKE '%Zabbix%';
UPDATE images SET name = replace(name, 'Zabbix', 'TAAE') WHERE name LIKE '%Zabbix%';

-- Guruhlar, foydalanuvchilar, rollar
UPDATE hstgrp SET name = replace(name, 'Zabbix', 'TAAE') WHERE name LIKE '%Zabbix%';
UPDATE usrgrp SET name = replace(name, 'Zabbix', 'TAAE') WHERE name LIKE '%Zabbix%';
UPDATE role SET name = replace(name, 'Zabbix', 'TAAE') WHERE name LIKE '%Zabbix%';
UPDATE users SET name = replace(name, 'Zabbix', 'TAAE') WHERE name LIKE '%Zabbix%';
UPDATE users SET surname = replace(surname, 'Zabbix', 'TAAE') WHERE surname LIKE '%Zabbix%';
UPDATE regexps SET name = replace(name, 'Zabbix', 'TAAE') WHERE name LIKE '%Zabbix%';
UPDATE services SET name = replace(name, 'Zabbix', 'TAAE') WHERE name LIKE '%Zabbix%';

-- Yuqori kontrastli mavzular interfeysdan olib tashlangan (faqat blue/dark)
UPDATE users SET theme = 'default' WHERE theme IN ('hc-light', 'hc-dark');
UPDATE config SET default_theme = 'blue-theme' WHERE default_theme IN ('hc-light', 'hc-dark');
DELETE FROM graph_theme WHERE theme IN ('hc-light', 'hc-dark');

-- ---------------------------------------------------------------------------
-- Eski nom (TAA / taa) -> TAAE / taae.
-- Baza dump'ida oldingi nom qolgan; fayl, konteyner, skript va trap nomlari
-- TAAE ga o'tgani uchun funksional qiymatlar (interface.dns/ip, exec_path,
-- snmptrap kalitlari, SNMPv3 foydalanuvchisi) ham shu yerda o'zgaradi.
-- Faqat alohida so'z sifatida: "TAAE" va "taassurot" kabi so'zlarga tegilmaydi.
-- Parol xeshlari, tokenlar va tarix jadvallari (history*, auditlog) o'zgarmaydi.
-- ---------------------------------------------------------------------------
DO $$
DECLARE
	r record;
BEGIN
	FOR r IN SELECT * FROM (VALUES
		('hosts', 'host'), ('hosts', 'name'), ('hosts', 'description'), ('hosts', 'vendor_name'),
		('items', 'name'), ('items', 'description'), ('items', 'key_'),
		('item_rtname', 'name_resolved'),
		('triggers', 'description'), ('triggers', 'comments'), ('triggers', 'event_name'),
		('triggers', 'opdata'),
		('events', 'name'), ('problem', 'name'),
		('event_tag', 'value'), ('problem_tag', 'value'), ('host_tag', 'value'), ('item_tag', 'value'),
		('widget_field', 'value_str'), ('widget', 'name'), ('dashboard', 'name'), ('dashboard_page', 'name'),
		('media_type', 'name'), ('media_type', 'description'), ('media_type', 'exec_path'),
		('media_type', 'smtp_helo'), ('media_type', 'smtp_email'), ('media_type', 'smtp_server'),
		('media_type_param', 'value'), ('media_type_message', 'subject'), ('media_type_message', 'message'),
		('opmessage', 'subject'), ('opmessage', 'message'), ('actions', 'name'),
		('scripts', 'name'), ('scripts', 'description'), ('scripts', 'command'),
		('hstgrp', 'name'), ('usrgrp', 'name'), ('users', 'name'), ('users', 'surname'), ('role', 'name'),
		('interface', 'dns'), ('interface', 'ip'), ('interface_snmp', 'securityname'),
		('valuemap', 'name'), ('valuemap_mapping', 'newvalue'),
		('hostmacro', 'description'), ('hostmacro', 'value'), ('globalmacro', 'description'),
		('graphs', 'name'), ('httptest', 'name'), ('httptest', 'agent'),
		('sysmaps', 'name'), ('images', 'name'), ('regexps', 'name'), ('services', 'name')
	) AS t(tbl, col)
	LOOP
		EXECUTE format(
			'UPDATE %I SET %I = regexp_replace(regexp_replace(regexp_replace(%I,'
			' ''(^|[^[:alnum:]])TAA(?![[:alnum:]])'', ''\1TAAE'', ''g''),'
			' ''(^|[^[:alnum:]])taa(?![[:lower:][:digit:]])'', ''\1taae'', ''g''),'
			' ''(^|[^[:alnum:]])Taa(?![[:lower:][:digit:]])'', ''\1Taae'', ''g'')'
			' WHERE %I ~ ''(^|[^[:alnum:]])(TAA|taa|Taa)([^[:alnum:]]|$)''',
			r.tbl, r.col, r.col, r.col);
	END LOOP;
END
$$;

-- Ketma-ket ikki so'z ("TAA TAA") uchun regexp bir o'tishda bittasini o'tkazib
-- yuborishi mumkin - ikkinchi o'tish (idempotent: TAAE qayta o'zgarmaydi)
DO $$
DECLARE
	r record;
BEGIN
	FOR r IN SELECT * FROM (VALUES
		('hosts', 'description'), ('items', 'description'), ('triggers', 'comments'),
		('media_type', 'description'), ('media_type_message', 'message'), ('opmessage', 'message')
	) AS t(tbl, col)
	LOOP
		EXECUTE format(
			'UPDATE %I SET %I = regexp_replace(%I,'
			' ''(^|[^[:alnum:]])TAA(?![[:alnum:]])'', ''\1TAAE'', ''g'')'
			' WHERE %I ~ ''(^|[^[:alnum:]])TAA([^[:alnum:]]|$)''',
			r.tbl, r.col, r.col, r.col);
	END LOOP;
END
$$;

-- Host nomidagi chetki bo'sh joy ("TAAE serveri ") agent Hostname bilan mos
-- kelmay, aktiv tekshiruvlarda "host not found" beradi
UPDATE hosts SET host = btrim(host) WHERE status IN (0, 1) AND host <> btrim(host);
UPDATE hosts SET name = btrim(name) WHERE status IN (0, 1) AND name <> btrim(name);

UPDATE hosts SET name_upper = upper(name) WHERE name_upper <> upper(name);
UPDATE item_rtname SET name_resolved_upper = upper(name_resolved)
	WHERE name_resolved_upper <> upper(name_resolved);
ALTER TABLE httptest ALTER COLUMN agent SET DEFAULT 'TAAE';

-- Geomap vidjeti olib tashlangan: dashboard'lardagi nusxalari va modul yozuvi
DELETE FROM widget WHERE type = 'geomap';
DELETE FROM module WHERE id = 'geomap';

-- TAAE palitrasi: jiddiylik ranglari (asl ranglar o'rniga, sayt dizayniga mos)
UPDATE config SET severity_color_0 = '94A3B8', severity_color_1 = '60A5FA',
	severity_color_2 = 'FBBF24', severity_color_3 = 'FB923C',
	severity_color_4 = 'F87171', severity_color_5 = 'E11D48';

COMMIT;
