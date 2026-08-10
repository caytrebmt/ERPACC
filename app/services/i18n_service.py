import json
from pathlib import Path
from flask import session, request
from typing import Any, Dict

class I18nService:
    SUPPORTED_LANGS = ['vi', 'en']
    DEFAULT_LANG = 'vi'
    TRANSLATIONS_DIR = Path(__file__).parent.parent / 'translations'
    
    _cache: Dict[str, Dict] = {}
    
    @classmethod
    def load_translations(cls) -> None:
        """Load all translation files into cache"""
        if cls._cache:
            return
        
        for lang in cls.SUPPORTED_LANGS:
            file_path = cls.TRANSLATIONS_DIR / f"{lang}.json"
            try:
                with open(file_path, 'r', encoding='utf-8') as f:
                    cls._cache[lang] = json.load(f)
            except FileNotFoundError:
                cls._cache[lang] = {}
    
    @classmethod
    def get_current_lang(cls) -> str:
        """Get current language from session or cookie"""
        lang = request.args.get('lang')
        if lang in cls.SUPPORTED_LANGS:
            session['lang'] = lang
            return lang
        
        lang = session.get('lang')
        if lang in cls.SUPPORTED_LANGS:
            return lang
        
        lang = request.cookies.get('lang')
        if lang in cls.SUPPORTED_LANGS:
            session['lang'] = lang
            return lang
        
        return cls.DEFAULT_LANG
    
    @classmethod
    def translate(cls, key: str, lang: str = None) -> str:
        """
        Translate a key with fallback chain.
        Priority: requested lang -> default lang (vi) -> raw key
        Example: "common.edit" or "reports.profit_by_customer"
        """
        if lang is None:
            lang = cls.get_current_lang()
        
        if lang not in cls.SUPPORTED_LANGS:
            lang = cls.DEFAULT_LANG
        
        cls.load_translations()
        
        keys = key.split('.')
        
        # Try requested language first
        value = cls._get_nested_value(cls._cache.get(lang, {}), keys)
        if value is not None:
            return value
        
        # Fallback to default language (vi) if different from requested
        if lang != cls.DEFAULT_LANG:
            value = cls._get_nested_value(cls._cache.get(cls.DEFAULT_LANG, {}), keys)
            if value is not None:
                return value
        
        # Ultimate fallback: return the key itself
        return key
    
    @classmethod
    def _get_nested_value(cls, d: Dict, keys: list) -> Any:
        """Safely get nested value from dict using key path."""
        value = d
        for k in keys:
            if isinstance(value, dict):
                value = value.get(k)
            else:
                return None
        return value
    
    @classmethod
    def get_all_translations(cls, lang: str = None) -> Dict[str, Any]:
        """Get all translations for a language"""
        if lang is None:
            lang = cls.get_current_lang()
        
        cls.load_translations()
        return cls._cache.get(lang, {})
    
    @classmethod
    def switch_language(cls, lang: str) -> str:
        """Switch to a different language"""
        if lang in cls.SUPPORTED_LANGS:
            session['lang'] = lang
            return lang
        return cls.get_current_lang()

# Shortcut function
def t(key: str) -> str:
    """Translate function for use in templates"""
    return I18nService.translate(key)

def get_lang() -> str:
    """Get current language"""
    return I18nService.get_current_lang()
