#!/usr/bin/perl
# =============================================================================
# TAA - manba kod (repo) bo'ylab "Zabbix" so'zini "TAA" ga almashtirish.
#
# Ishlatish (repo ildizida):
#   git grep -I -l -z -E 'Zabbix|ZABBIX forums' | xargs -0 perl scripts/rebrand/taa-rebrand-source.pl
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
#     - qolgan "Zabbix" so'zlari -> "TAA"
#     - "Zabbix_server_*" rasm nomlari -> "TAA_server_*"
#     - "ZABBIX forums" -> "TAA forums"
#
# Ro'yxatdan tashqari qolishi kerak bo'lgan fayllar SKIP ro'yxatida.
# =============================================================================
use strict;
use warnings;

my %SKIP = map { $_ => 1 } (
	'COPYING',
	'AUTHORS',
	'taa_database_backup_utf8.sql',        # baza: 03-taa-full-rebrand.sql orqali
	'02-rebrand-taa.sql',                  # eski nomlarni ataylab qidiradi
	'03-taa-full-rebrand.sql',
	'docker/taa-rebrand-web.sh',           # qoidalarning o'zi
	'scripts/rebrand/taa-rebrand-source.pl',
	'scripts/windows-agent/taa-agent-install.bat',   # eski xizmat nomini o'chiradi
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
			$l =~ s/\bZabbix_server_/TAA_server_/g;
			$l =~ s/\bZabbix\b(?!\\|\.\w)/TAA/g;
			$l =~ s/\bZABBIX forums\b/TAA forums/g;
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
