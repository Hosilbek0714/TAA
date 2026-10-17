#!/bin/sh
# =============================================================================
# TAA - veb-interfeysdagi "Zabbix" nomini TAA ga almashtirish.
# taa-web image yig'ilayotganda Dockerfile'dan chaqiriladi (root sifatida,
# perl vaqtincha o'rnatilgan holda).
#
# Qoidalar:
#   - izoh qatorlari (litsenziya/mualliflik huquqi) o'zgarmaydi - AGPLv3 talabi;
#   - PHP namespace'lar (Zabbix\Core, Zabbix\Widgets) va CZabbixServer kabi
#     kod nomlari o'zgarmaydi - aks holda dastur ishlamaydi;
#   - qolgan "Zabbix" so'zlari (jumladan _('...') tarjima kalitlari) -> "TAA".
#     ui/locale/*/frontend.po dagi msgid'lar ham xuddi shu qoida bilan
#     o'zgartirilgan, shuning uchun o'zbekcha tarjima mos keladi;
#   - zabbix.php -> taa.php (manzil qatori). Eski zabbix.php ham ishlaydi.
# =============================================================================
set -eu

WEB=${WEB:-/usr/share/zabbix}
cd "$WEB"

find . -type f \( -name '*.php' -o -name '*.js' \) ! -path './vendor/*' -print0 \
	| xargs -0 perl -pi -e '
		next if m{^\s*(\*|//|/\*|#)};
		s{https://www\.zabbix\.com/license}{https://www.gnu.org/licenses/agpl-3.0.html}g;
		s{https?://(?:www\.|services\.)?zabbix\.com[^\x27"\s`]*}{#}g;
		s/\bZabbix SIA\b/TAA/g;
		s/\bZabbix\b(?!\\)/TAA/g;
		s/\bzabbix\.php\b/taa.php/g;
		s/\bzabbix-logo/taa-logo/g;
	'

# CSS: logotip klasslari va ikonka shrifti nomi
if [ -d assets/fonts ]; then
	for ext in svg ttf woff woff2; do
		[ -f "assets/fonts/zabbix-icons.$ext" ] && cp -p "assets/fonts/zabbix-icons.$ext" "assets/fonts/taa-icons.$ext"
	done
	[ -f assets/fonts/taa-icons.svg ] && sed -i 's/zabbix-icons/taa-icons/g' assets/fonts/taa-icons.svg
fi
find assets/styles -name '*.css' -print0 2>/dev/null \
	| xargs -0 -r perl -pi -e 's/zabbix-icons/taa-icons/g; s/\bzabbix-logo/taa-logo/g; s/\bZabbix\b/TAA/g'

# Widget va modul manifestlari: "author": "Zabbix"
find widgets modules -name manifest.json -print0 2>/dev/null \
	| xargs -0 -r perl -pi -e 's/"author":\s*"Zabbix[^"]*"/"author": "TAA"/g'

# Yuqori kontrastli mavzular olib tashlanadi (faqat yorug' va qora qoladi)
perl -i -ne "print unless /High-contrast (light|dark)/" include/classes/core/ZBase.php
perl -pi -e "s/.dark-theme., .hc-dark. =>/'dark-theme' =>/" include/classes/core/ZBase.php
rm -f assets/styles/hc-light.css assets/styles/hc-dark.css
if grep -q "hc-light\|hc-dark" include/classes/core/ZBase.php; then
	echo "XATO: ZBase.php da yuqori kontrastli mavzular qoldi" >&2
	exit 1
fi

# Sessiya cookie nomi: zbx_session -> taa_session
sed -i "s/define('ZBX_SESSION_NAME', 'zbx_session')/define('ZBX_SESSION_NAME', 'taa_session')/" include/defines.inc.php

# Manzil qatorida zabbix.php o'rniga taa.php
cp -p zabbix.php taa.php

# nginx server nomi
for f in /etc/nginx/includes/server-common.conf /etc/nginx/includes/server-ssl.conf \
		/etc/zabbix/nginx.conf /etc/zabbix/nginx_ssl.conf; do
	[ -f "$f" ] && sed -i 's/server_name\s\+zabbix;/server_name     taa;/' "$f"
done

# Tekshiruv: izoh bo'lmagan qatorlarda "Zabbix" so'zi qolmasligi kerak
# (namespace va kod nomlaridan tashqari)
left=$(find . -type f \( -name '*.php' -o -name '*.js' \) ! -path './vendor/*' -print0 \
	| xargs -0 perl -ne 'next if m{^\s*(\*|//|/\*|#)}; print "$ARGV:$.: $_" if /\bZabbix\b(?!\\)/; close ARGV if eof' \
	| head -5)
if [ -n "$left" ]; then
	echo "OGOHLANTIRISH: Zabbix qolgan joylar:" >&2
	echo "$left" >&2
fi

echo "TAA rebrending: veb-interfeys tayyor"
