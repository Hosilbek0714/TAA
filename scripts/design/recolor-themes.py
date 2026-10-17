#!/usr/bin/env python3
"""
TAA dizayni: mavzu fayllaridagi eski fon ranglarini TAA palitrasiga xaritalash.

  blue-theme.css - oldingi dizayndan qolgan binafsha fonlar (asli Zabbix'ning oq
                   rangi) -> oq / TAA fon rangi
  dark-theme.css - neytral kulranglar -> TAA'ning to'q ko'k-kulrang palitrasi

Ranglar ui/assets/styles/taa/tokens-*.css bilan mos. Qayta ishga tushirish
xavfsiz (idempotent). Ishlatish (repo ildizida):
    python scripts/design/recolor-themes.py
"""
import re
from pathlib import Path

STYLES = Path(__file__).resolve().parents[2] / 'ui' / 'assets' / 'styles'

MAPS = {
    'blue-theme.css': {
        '#f0ebff': '#ffffff',   # kartochka / maydon foni
        '#faf8ff': '#f3f6fb',   # sahifa foni (--taa-bg)
    },
    'dark-theme.css': {
        '#0e0e0e': '#0a0f1a', '#0d0d0d': '#0a0f1a', '#0d0f11': '#0a0f1a',
        '#0e1012': '#0a0f1a', '#121212': '#0a0f1a',
        '#191919': '#0e1320', '#1c1c1c': '#0e1320', '#1f1f1f': '#0e1320',
        '#202020': '#0e1320',                                   # --taa-bg
        '#2b2b2b': '#151b2b',                                   # --taa-surface
        '#303030': '#182033',
        '#383838': '#1c2538',
        '#3a3a3a': '#222c42', '#3d3d3d': '#222c42', '#404040': '#222c42',
        '#414141': '#222c42',
        '#454545': '#263049',
        '#4a4a4a': '#2b3650', '#4f4f4f': '#2b3650',             # chegaralar
        '#525252': '#33415e',
        '#737373': '#6b7891',
        '#787878': '#7d89a3', '#808080': '#7d89a3',
        '#9c9c9c': '#9aa6bd', '#9d9d9d': '#9aa6bd',
        '#f2f2f2': '#e6eaf2',                                   # asosiy matn
    },
}

for name, mapping in MAPS.items():
    path = STYLES / name
    css = path.read_text(encoding='utf-8')
    pattern = re.compile('|'.join(re.escape(k) for k in mapping) + r'(?![0-9a-fA-F])', re.I)
    css, n = pattern.subn(lambda m: mapping[m.group(0).lower()], css)
    path.write_text(css, encoding='utf-8', newline='')
    print(f'{name}: {n} ta rang almashtirildi')
