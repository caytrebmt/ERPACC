import json
import re
import sys
from pathlib import Path

sys.stdout.reconfigure(encoding='utf-8')

base = Path('.')
vi_path = base / 'app/translations/vi.json'
en_path = base / 'app/translations/en.json'

with open(vi_path, encoding='utf-8') as f:
    vi = json.load(f)
with open(en_path, encoding='utf-8') as f:
    en = json.load(f)

def flatten(d, parent=''):
    items = {}
    for k, v in d.items():
        key = f"{parent}.{k}" if parent else k
        if isinstance(v, dict):
            items.update(flatten(v, key))
        else:
            items[key] = v
    return items

vi_flat = flatten(vi)
en_flat = flatten(en)

# Extract actual t() keys from templates and Python
used_keys = set()
for path in list(base.glob('app/templates/**/*.html')) + list(base.glob('app/**/*.py')):
    try:
        text = path.read_text(encoding='utf-8')
        for m in re.finditer(r"""t\((['"])(.+?)\1\)""", text):
            key = m.group(2)
            # Filter out obvious non-translation keys
            if not key.startswith('/') and not key.startswith('.') and not key.startswith('%') and len(key) > 1:
                used_keys.add(key)
    except Exception:
        pass

missing_vi = [k for k in sorted(used_keys) if k not in vi_flat]
missing_en = [k for k in sorted(used_keys) if k not in en_flat]

print(f"Total actual t() keys: {len(used_keys)}")
print(f"Missing in VI: {len(missing_vi)}")
print(f"Missing in EN: {len(missing_en)}")
print("\nMissing keys:")
for k in missing_vi:
    print(f"  - {k}")
