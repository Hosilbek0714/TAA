#!/usr/bin/perl
# =============================================================================
# TAAE - manba kod (repo) bo'ylab "Zabbix" so'zini "TAAE" ga almashtirish.
#
# Ishlatish (repo ildizida):
#   git grep -I -l -z -E 'Zabbix|ZABBIX forums' | xargs -0 perl scripts/rebrand/taae-rebrand-source.pl
#
# Qoidalar (har bir qatorga):
#   O'ZGARMAYDI:
#     - mualliflik huquqi va litsenziya qatorlari (AGPLv3 talabi):
#       "Copyright", "Zabbix SIA", "modified by Zabbix"
#     - JavaScript API chaqiruvlari:  Zabbix.log(...), Zabbix.sleep(...)
#       (ishlab turgan server shu nomni kutadi - shablon skriptlari buziladi)
#     - PHP namespace:                Zabbix\Core, 'Zabbix\\Widgets'
#     - kod identifikatorlari:        CZabbixServer, ZabbixException,
#                                     ZabbixAsync (so'z chegarasi yo'q)
#     - bosh harfli ZABBIX:           {$ZABBIX.URL}, ZABBIX.EventHub,
#                                     "type: ZABBIX" (funksional qiymatlar)
#     - kichik harfli zabbix:         yo'llar, binar nomlar, kalitlar
#   O'ZGARADI:
#     - qolgan "Zabbix" so'zlari -> "TAAE"
#     - "Zabbix_server_*" rasm nomlari -> "TAAE_server_*"
#     - "ZABBIX forums" -> "TAAE forums"
#
# Ro'yxatdan tashqari qolishi kerak bo'lgan fayllar SKIP ro'yxatida.
# =============================================================================
use strict;
use warnings;

my %SKIP = map { $_ => 1 } (
	'COPYING',
	'AUTHORS',
	'taae_database_backup_utf8.sql',        # baza: 03-taae-full-rebrand.sql orqali
	'02-rebrand-taae.sql',                  # eski nomlarni ataylab qidiradi
	'03-taae-full-rebrand.sql',
	'docker/taae-rebrand-web.sh',           # qoidalarning o'zi
	'scripts/rebrand/taae-rebrand-source.pl',
	'scripts/windows-agent/taae-agent-install.bat',   # eski xizmat nomini o'chiradi
);

my ($files, $lines) = (0, 0);

for my $file (@ARGV) {
	next if $SKIP{$file};
	open(my $in, '<:raw', $file) or do { warn "$file: $!\n"; next };
	my @out;
	my $changed = 0;
	while (my $l = <$in>) {
		my $orig = $l;
		unless ($l =~ /Copyright|Zabbix SIA|SIA Zabbix|modified by Zabbix/i) {
			$l =~ s/\bZabbix_server_/TAAE_server_/g;
			$l =~ s/\bZabbix\b(?!\\|\.\w)/TAAE/g;
			$l =~ s/\bZABBIX forums\b/TAAE forums/g;
		}
		if ($l ne $orig) { $changed++ }
		push @out, $l;
	}
	close $in;
	next unless $changed;
	open(my $out, '>:raw', $file) or die "$file: $!\n";
	print $out @out;
	close $out;
	$files++;
	$lines += $changed;
}

print "o'zgartirildi: $files fayl, $lines qator\n";
