import re
import sys
from pathlib import Path

sys.stdout.reconfigure(encoding='utf-8')

base = Path('.')
keys = set()

for path in list(base.glob('app/templates/**/*.html')) + list(base.glob('app/**/*.py')):
    try:
        text = path.read_text(encoding='utf-8')
        for m in re.finditer(r"""t\((['"])(.+?)\1\)""", text):
            keys.add(m.group(2))
    except Exception:
        pass

for k in sorted(keys):
    print(k)
