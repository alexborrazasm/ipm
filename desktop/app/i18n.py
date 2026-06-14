"""Internationalization configuration"""
import gettext
import locale
from pathlib import Path
import os

def setup_i18n(locale_dir: Path) -> callable:
  """Initialize gettext and locale, defaulting to English if language not 
  supported."""
  system_lang = os.environ.get('LANGUAGE') or os.environ.get('LANG') or 'en'

  # Parse language and region
  parts = system_lang.split('.')
  lang_region = parts[0]
  subparts = lang_region.split('_')
  lang = subparts[0]
  region = subparts[1] if len(subparts) > 1 else None

  # Only use supported languages for translation
  supported_langs = ['en', 'es', 'gl']
  selected = lang if lang in supported_langs else 'en'

  # Load translations
  try:
    t = gettext.translation('SplitWithTheMachine', localedir=locale_dir, 
                            languages=[selected])
    t.install()
    _ = t.gettext
  except Exception:
    _ = gettext.gettext

  # Locale setup for dates, currency, etc.
  try:
    default_regions = {'en': 'US', 'es': 'ES', 'gl': 'ES'}
    if lang in supported_langs:
      # Use detected or default region for supported languages
      region_code = region or default_regions.get(lang, 'US')
      locale_name = f"{lang}_{region_code}.UTF-8"
    else:
      # Unsupported language -> Try to use provided locale
      locale_name = f"{lang}_{region}.UTF-8"

    locale.setlocale(locale.LC_ALL, locale_name)
  except Exception:
    locale.setlocale(locale.LC_ALL, 'C')

  return _
