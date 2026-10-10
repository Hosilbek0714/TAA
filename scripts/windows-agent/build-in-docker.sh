#!/bin/sh
# =============================================================================
# TAA Agent 2 (Windows x64) ni manba koddan Docker ichida yig'ish (MinGW).
#
# Kompyuterda faqat Docker kerak. Natija:
#   scripts/windows-agent/dist/taa_agent2.exe
#
# Ishlatish (repo ildizida):
#   sh scripts/windows-agent/build-in-docker.sh
#
# src/go/pkg/zbxlib/globals_windows.go C qismini build/mingw/output/*.o
# obyektlaridan kutadi. Asl build/mingw/Makefile repo'da yo'q - shu skript
# o'sha obyektlarni yig'adi. TLS (openssl) qo'shilmaydi: agent shifrlanmagan
# ulanish bilan ishlaydi (TLSConnect=unencrypted).
# =============================================================================
set -eu

export MSYS_NO_PATHCONV=1
ROOT=$(cd "$(dirname "$0")/../.." && { pwd -W 2>/dev/null || pwd; })
OUT="$ROOT/scripts/windows-agent/dist"
mkdir -p "$OUT"

git -C "$ROOT" -c core.autocrlf=false -c core.eol=lf archive --format=tar -o "$OUT/src.tar" HEAD

docker run --rm \
	-v "$OUT:/work" \
	golang:1.24-bookworm \
	sh -euc '
		apt-get update -qq
		apt-get install -y -qq --no-install-recommends gcc-mingw-w64-x86-64 make >/dev/null
		CC=x86_64-w64-mingw32-gcc

		echo "== 1/3 PCRE2 (Windows, statik)"
		V=10.44
		cd /tmp
		curl -fsSL "https://github.com/PCRE2Project/pcre2/releases/download/pcre2-$V/pcre2-$V.tar.gz" | tar -xz
		cd "pcre2-$V"
		./configure -q --host=x86_64-w64-mingw32 --prefix=/opt/mingw \
			--disable-shared --enable-static --disable-pcre2grep-libz --disable-pcre2grep-libbz2
		make -s -j"$(nproc)" >/dev/null && make -s install >/dev/null

		echo "== 2/3 C obyektlar (build/mingw/output)"
		mkdir /build && tar -xf /work/src.tar -C /build && cd /build
		mkdir -p build/mingw/output
		CFLAGS="-O2 -D_WINDOWS -D_CONSOLE -DUNICODE -D_UNICODE -D_WIN32_WINNT=0x0600 \
			-DHAVE_IPV6 -DHAVE_PCRE2_H -DPCRE2_STATIC -DPCRE2_CODE_UNIT_WIDTH=8 \
			-Iinclude -Iinclude/common -Ibuild/win32/include -Ibuild/win32/include/common \
			-Ibuild/mingw -I/opt/mingw/include"
		while read obj src; do
			$CC $CFLAGS -c "$src" -o "build/mingw/output/$obj.o"
		done <<EOF
algodefs src/libs/zbxalgo/algodefs.c
bincommon src/libs/zbxbincommon/bincommon.c
common_log src/libs/zbxcommon/common_log.c
common_str src/libs/zbxcommon/common_str.c
components_strings_representations src/libs/zbxcommon/components_strings_representations.c
disk src/libs/zbxwin32/disk.c
eventlog src/zabbix_agent/active_checks/eventlog_win32/eventlog.c
expr src/libs/zbxexpr/expr.c
fatal src/libs/zbxwin32/fatal.c
file src/libs/zbxfile/file.c
function src/libs/zbxexpr/function.c
hashset src/libs/zbxalgo/hashset.c
host src/libs/zbxexpr/host.c
interval src/libs/zbxexpr/interval.c
ip src/libs/zbxip/ip.c
iprange src/libs/zbxip/iprange.c
json src/libs/zbxjson/json.c
json_parser src/libs/zbxjson/json_parser.c
jsonobj src/libs/zbxjson/jsonobj.c
jsonpath src/libs/zbxjson/jsonpath.c
libc_wrappers src/libs/zbxcommon/libc_wrappers.c
logfiles src/zabbix_agent/logfiles/logfiles.c
macro src/libs/zbxexpr/macro.c
md5 src/libs/zbxhash/md5.c
misc src/libs/zbxcommon/misc.c
num src/libs/zbxnum/num.c
param src/libs/zbxparam/param.c
persistent_state src/zabbix_agent/logfiles/persistent_state.c
process_eventslog src/zabbix_agent/active_checks/eventlog_win32/process_eventslog.c
process_eventslog6 src/zabbix_agent/active_checks/eventlog_win32/process_eventslog6.c
sha256crypt src/libs/zbxhash/sha256crypt.c
str src/libs/zbxstr/str.c
symbols src/libs/zbxwin32/symbols.c
sysinfo src/libs/zbxsysinfo/sysinfo.c
sysinfo_alias src/libs/zbxsysinfo/alias/alias.c
sysinfo_dir src/libs/zbxsysinfo/common/dir.c
sysinfo_dns src/libs/zbxsysinfo/common/dns.c
sysinfo_ip_reverse src/libs/zbxsysinfo/common/ip_reverse.c
sysinfo_system src/libs/zbxsysinfo/common/system.c
sysinfo_vfs_file src/libs/zbxsysinfo/common/vfs_file.c
threads src/libs/zbxthreads/threads.c
time src/libs/zbxtime/time.c
token src/libs/zbxexpr/token.c
variant src/libs/zbxvariant/variant.c
vector src/libs/zbxalgo/vector.c
win32_file src/libs/zbxfile/win32/win32_file.c
zbxhash src/libs/zbxhash/zbxhash.c
zbxregexp src/libs/zbxregexp/zbxregexp.c
EOF

		echo "== 3/3 Go agent (taa_agent2.exe)"
		cd src/go
		CGO_ENABLED=1 GOOS=windows GOARCH=amd64 CC=$CC \
			CGO_CFLAGS="-I/opt/mingw/include -DPCRE2_STATIC" \
			CGO_LDFLAGS="-L/opt/mingw/lib" \
			go build -tags pcre2 \
				-ldflags "-s -w -X main.applicationName=taa_agent2" \
				-o /work/taa_agent2.exe ./cmd/zabbix_agent2
		ls -la /work/taa_agent2.exe
	'

rm -f "$OUT/src.tar"
echo "Tayyor: $OUT/taa_agent2.exe"
