import json
import re
import sys
from pathlib import Path
from collections import defaultdict
from flask import Flask
from flask.cli import AppGroup
from app.services.i18n_service import I18nService

translations_cli = AppGroup('translations', help='Translation management commands')


def flatten_dict(d, parent_key='', sep='.'):
    items = {}
    for k, v in d.items():
        new_key = f"{parent_key}{sep}{k}" if parent_key else k
        if isinstance(v, dict):
            items.update(flatten_dict(v, new_key, sep=sep))
        else:
            items[new_key] = v
    return items


def extract_keys_from_path(root, pattern):
    keys = set()
    for path in root.rglob(pattern):
        try:
            content = path.read_text(encoding='utf-8')
            for m in re.finditer(r"""t\((['"])(.+?)\1\)""", content):
                keys.add(m.group(2))
        except Exception:
            pass
    return keys


@translations_cli.command('scan')
def scan_command():
    """Scan codebase for translation coverage."""
    base_dir = Path(__file__).resolve().parents[2]
    
    print("=" * 60)
    print("ERPACC Translation Scanner")
    print("=" * 60)
    
    # Load translations
    I18nService.load_translations()
    vi_data = I18nService.get_all_translations('vi')
    en_data = I18nService.get_all_translations('en')
    vi_flat = flatten_dict(vi_data)
    en_flat = flatten_dict(en_data)
    
    # Extract used keys
    template_keys = extract_keys_from_path(base_dir / 'app' / 'templates', '*.html')
    python_keys = extract_keys_from_path(base_dir / 'app', '*.py')
    used_keys = template_keys | python_keys
    
    print(f"\n📊 Statistics:")
    print(f"  Total t() keys used: {len(used_keys)}")
    print(f"  Keys in VI JSON: {len(vi_flat)}")
    print(f"  Keys in EN JSON: {len(en_flat)}")
    
    missing_vi = sorted([k for k in used_keys if k not in vi_flat])
    missing_en = sorted([k for k in used_keys if k not in en_flat])
    
    print(f"  Missing in VI: {len(missing_vi)}")
    print(f"  Missing in EN: {len(missing_en)}")
    
    if missing_vi:
        print(f"\n❌ Missing in Vietnamese (first 20):")
        for key in missing_vi[:20]:
            print(f"  - {key}")
    
    if missing_en:
        print(f"\n❌ Missing in English (first 20):")
        for key in missing_en[:20]:
            print(f"  - {key}")
    
    # Save report
    report = {
        'used_keys': sorted(used_keys),
        'missing_vi': missing_vi,
        'missing_en': missing_en,
        'vi_count': len(vi_flat),
        'en_count': len(en_flat)
    }
    
    report_path = base_dir / 'translation_report.json'
    with open(report_path, 'w', encoding='utf-8') as f:
        json.dump(report, f, ensure_ascii=False, indent=2)
    
    print(f"\n📄 Report saved to: {report_path}")
    print("=" * 60)
    
    return 0 if not (missing_vi or missing_en) else 1


@translations_cli.command('export')
@translations_cli.option('--lang', default='vi', help='Language to export')
def export_command(lang):
    """Export translations to JSON file."""
    base_dir = Path(__file__).resolve().parents[2]
    I18nService.load_translations()
    data = I18nService.get_all_translations(lang)
    
    output_path = base_dir / f'{lang}_export.json'
    with open(output_path, 'w', encoding='utf-8') as f:
        json.dump(data, f, ensure_ascii=False, indent=2)
    
    print(f"Exported {len(data)} keys to {output_path}")


@translations_cli.command('import')
@translations_cli.option('--lang', default='vi', help='Target language')
@translations_cli.option('--file', required=True, help='JSON file to import')
def import_command(lang, file):
    """Import translations from JSON file."""
    base_dir = Path(__file__).resolve().parents[2]
    file_path = Path(file)
    
    if not file_path.exists():
        print(f"Error: File {file} not found")
        return 1
    
    with open(file_path, encoding='utf-8') as f:
        data = json.load(f)
    
    if not isinstance(data, dict):
        print("Error: JSON must be an object")
        return 1
    
    output_path = base_dir / 'app' / 'translations' / f'{lang}.json'
    with open(output_path, 'w', encoding='utf-8') as f:
        json.dump(data, f, ensure_ascii=False, indent=2)
    
    I18nService._cache.clear()
    print(f"Imported {len(data)} keys to {output_path}")
    return 0


def register_commands(app: Flask):
    app.cli.add_command(translations_cli)
