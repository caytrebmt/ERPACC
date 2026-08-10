#!/usr/bin/env python3
"""
Translation scanner for ERPACC.
Scans templates and Python files for:
1. Existing t() keys
2. Hardcoded Vietnamese strings that should be translated
3. Missing keys in translation JSON files
"""
import os
import re
import json
import sys
from pathlib import Path
from collections import defaultdict

sys.stdout.reconfigure(encoding='utf-8')

BASE_DIR = Path(__file__).resolve().parents[1]
TRANSLATIONS_DIR = BASE_DIR / 'app' / 'translations'

# Patterns to detect translatable strings
VI_PATTERNS = [
    r'(?<![\w\\])(?:Đăng nhập|Đăng xuất|Đổi mật khẩu|Quản lý|Hàng hóa|Sản phẩm|Kho hàng|Nhập kho|Xuất kho|Tồn kho|Báo cáo|Kế toán|Khách hàng|Nhà cung cấp|Phiếu|Chứng từ|Hóa đơn|Thanh toán|Công nợ|Thuế|Tổng quan|Thông tin|Hệ thống|Cài đặt|Sao lưu|Khôi phục|Mẫu thông báo|Thay đổi|Người dùng|Phân quyền|Menu|Đơn vị|Nhóm hàng|Tồn đầu|Kiểm kê)(?![\w\\])',
    r'(?<![\w\\])(?:Lưu|Xóa|Sửa|Thêm|Xác nhận|Hủy|In|Tìm kiếm|Lọc|Xuất|Nhập|Tạo|Cập nhật|Xem|Chi tiết|Danh sách|Mã|Tên|Ngày|Tháng|Năm|Số|Tổng|Tiền|Đơn giá|Số lượng|Thành tiền|Thuế|Ghi chú|Trạng thái|Nguồn|Kho|Nhà cung cấp|Khách hàng)(?![\w\\])',
    r'(?<![\w\\])(?:Nháp|Đã xác nhận|Đã hủy|Đã gửi|Đã chấp nhận|Đã chuyển|Chưa thanh toán|Thanh toán một phần|Đã thanh toán|Quá hạn)(?![\w\\])',
]

# Extract all t() keys from templates and Python
def extract_translation_keys():
    keys = set()
    root = BASE_DIR
    
    # Scan templates
    for path in (root / 'app' / 'templates').rglob('*.html'):
        try:
            content = path.read_text(encoding='utf-8')
            for m in re.finditer(r"""t\((['"])(.+?)\1\)""", content):
                keys.add(m.group(2))
        except Exception:
            pass
    
    # Scan Python files
    for path in (root / 'app').rglob('*.py'):
        try:
            content = path.read_text(encoding='utf-8')
            for m in re.finditer(r"""t\((['"])(.+?)\1\)""", content):
                keys.add(m.group(2))
        except Exception:
            pass
    
    return keys


# Load translation files
def load_translations():
    vi = {}
    en = {}
    for lang, data in [('vi', vi), ('en', en)]:
        path = TRANSLATIONS_DIR / f'{lang}.json'
        if path.exists():
            try:
                with open(path, encoding='utf-8') as f:
                    data.update(json.load(f))
            except Exception:
                pass
    return vi, en


# Scan for hardcoded Vietnamese strings
def scan_hardcoded_strings():
    findings = []
    root = BASE_DIR
    
    # Templates
    for path in (root / 'app' / 'templates').rglob('*.html'):
        try:
            content = path.read_text(encoding='utf-8')
            lines = content.split('\n')
            for lineno, line in enumerate(lines, 1):
                # Skip lines that are already in t() or comments
                if 't(' in line or line.strip().startswith('{#') or line.strip().startswith('//'):
                    continue
                # Look for Vietnamese text in HTML content
                stripped = line.strip()
                if stripped and not stripped.startswith('<') and not stripped.startswith('{%'):
                    # Check if it contains Vietnamese characters
                    if re.search(r'[àáạảãâầấậẩẫăằắặẳẵèéẹẻẽêềếệểễìíịỉĩòóọỏõôồốộổỗơờớợởỡùúụủũưừứựửữỳýỵỷỹđ]', stripped, re.IGNORECASE):
                        if len(stripped) > 3 and not stripped.startswith('<!--'):
                            findings.append({
                                'file': str(path.relative_to(BASE_DIR)),
                                'line': lineno,
                                'text': stripped[:100],
                                'type': 'hardcoded_vi'
                            })
        except Exception:
            pass
    
    return findings


# Generate suggested keys for hardcoded strings
def suggest_key(text, file_path):
    """Generate a suggested translation key based on file location and content."""
    # Extract module from path
    parts = file_path.split('/')
    if 'templates' in parts:
        idx = parts.index('templates')
        if idx + 1 < len(parts):
            module = parts[idx + 1]
        else:
            module = 'common'
    else:
        module = 'common'
    
    # Clean text for key
    key_text = re.sub(r'[^a-z0-9]', '_', text.lower())[:40]
    key_text = re.sub(r'_+', '_', key_text).strip('_')
    
    return f"{module}.{key_text}"


# Main scan
def main():
    print("=" * 60)
    print("ERPACC Translation Scanner")
    print("=" * 60)
    
    # Load current translations
    vi, en = load_translations()
    vi_flat = flatten_dict(vi)
    en_flat = flatten_dict(en)
    
    # Extract used keys
    used_keys = extract_translation_keys()
    
    print(f"\n📊 Statistics:")
    print(f"  Total t() keys used: {len(used_keys)}")
    print(f"  Keys in VI JSON: {len(vi_flat)}")
    print(f"  Keys in EN JSON: {len(en_flat)}")
    
    # Check coverage
    missing_vi = sorted([k for k in used_keys if k not in vi_flat])
    missing_en = sorted([k for k in used_keys if k not in en_flat])
    
    print(f"  Missing in VI: {len(missing_vi)}")
    print(f"  Missing in EN: {len(missing_en)}")
    
    # Scan for hardcoded strings
    print(f"\n🔍 Scanning for hardcoded Vietnamese strings...")
    hardcoded = scan_hardcoded_strings()
    print(f"  Found {len(hardcoded)} potential hardcoded strings")
    
    # Show missing keys
    if missing_vi:
        print(f"\n❌ Missing in Vietnamese:")
        for key in missing_vi[:20]:
            print(f"  - {key}")
        if len(missing_vi) > 20:
            print(f"  ... and {len(missing_vi) - 20} more")
    
    if missing_en:
        print(f"\n❌ Missing in English:")
        for key in missing_en[:20]:
            print(f"  - {key}")
        if len(missing_en) > 20:
            print(f"  ... and {len(missing_en) - 20} more")
    
    # Show hardcoded strings with suggestions
    if hardcoded:
        print(f"\n⚠️  Hardcoded Vietnamese strings (suggested keys):")
        for item in hardcoded[:15]:
            suggested = suggest_key(item['text'], item['file'])
            print(f"  {item['file']}:{item['line']}")
            print(f"    Text: {item['text'][:60]}")
            print(f"    Suggested key: {suggested}")
        if len(hardcoded) > 15:
            print(f"  ... and {len(hardcoded) - 15} more")
    
    # Generate report
    report = {
        'used_keys': sorted(used_keys),
        'missing_vi': missing_vi,
        'missing_en': missing_en,
        'hardcoded': hardcoded,
        'vi_count': len(vi_flat),
        'en_count': len(en_flat)
    }
    
    report_path = BASE_DIR / 'translation_report.json'
    with open(report_path, 'w', encoding='utf-8') as f:
        json.dump(report, f, ensure_ascii=False, indent=2)
    
    print(f"\n📄 Report saved to: {report_path}")
    print("=" * 60)
    
    return 0 if not (missing_vi or missing_en or hardcoded) else 1


def flatten_dict(d, parent_key='', sep='.'):
    items = {}
    for k, v in d.items():
        new_key = f"{parent_key}{sep}{k}" if parent_key else k
        if isinstance(v, dict):
            items.update(flatten_dict(v, new_key, sep=sep))
        else:
            items[new_key] = v
    return items


if __name__ == '__main__':
    sys.exit(main())
