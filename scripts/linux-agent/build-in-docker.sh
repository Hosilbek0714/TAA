#!/bin/sh
# =============================================================================
# TAA Agent 2 (Linux) ni manba koddan Docker ichida yig'ish.
#
# Kompyuterda Go, C kompilyator yoki autotools o'rnatish shart emas - faqat
# Docker kerak. Natija: scripts/linux-agent/dist/taa_agent2 (amd64)
#
# Ishlatish (repo ildizida):
#   sh scripts/linux-agent/build-in-docker.sh
#
# Keyin o'rnatish (Linux mijozda):
#   sudo ./scripts/linux-agent/install.sh
# =============================================================================
set -eu

# Git Bash (Windows): docker -v uchun yo'lni C:/... ko'rinishida beramiz
export MSYS_NO_PATHCONV=1
ROOT=$(cd "$(dirname "$0")/../.." && { pwd -W 2>/dev/null || pwd; })
OUT="$ROOT/scripts/linux-agent/dist"
mkdir -p "$OUT"

# Manba kod git'dan LF qator oxirlari bilan olinadi (Windows'da ham to'g'ri)
git -C "$ROOT" -c core.autocrlf=false archive --format=tar -o "$OUT/src.tar" HEAD

docker run --rm \
	-v "$OUT:/work" \
	golang:1.24-bookworm \
	sh -euc '
		apt-get update -qq
		apt-get install -y -qq --no-install-recommends \
			autoconf automake libtool pkg-config make gcc \
			libpcre2-dev libssl-dev zlib1g-dev >/dev/null
		mkdir /build && tar -xf /work/src.tar -C /build && cd /build
		# .gitignore tufayli repo"da yo"q, lekin configure.ac kutadigan
		# baza papkalari (agentga kerak emas) - bo"sh Makefile.am bilan
		for d in database/mysql/option-patches \
				database/postgresql/option-patches \
				database/postgresql/timescaledb/option-patches \
				database/postgresql/timescaledb/option-patches/with-compression \
				database/postgresql/timescaledb/option-patches/without-compression; do
			mkdir -p "$d"
			[ -f "$d/Makefile.am" ] || echo "EXTRA_DIST =" > "$d/Makefile.am"
		done
		./bootstrap.sh
		./configure --enable-agent2 --with-openssl --with-libpcre2 >/dev/null
		make -j"$(nproc)"
		install -m 0755 src/go/bin/zabbix_agent2 /work/taa_agent2
		/work/taa_agent2 -V | head -2
	'

rm -f "$OUT/src.tar"
echo "Tayyor: $OUT/taa_agent2"
