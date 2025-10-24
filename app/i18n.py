"""Internationalization configuration"""
import gettext
import locale
from pathlib import Path
import os

def setup_i18n(locale_dir: Path) -> callable:

  system_lang = os.environ.get('LANGUAGE') or os.environ.get('LANG') or 'en'
  code = system_lang.split('_')[0] if '_' in system_lang else system_lang.split('.')[0]
  selected = code if code in ['en','es','gl'] else 'en' # default to English

  # Translation for text strings
  try:
    t = gettext.translation('SplitWithTheMachine', localedir=locale_dir,
                             languages=[selected])
    t.install()
    _ = t.gettext
  except Exception:
    _ = gettext.gettext

  # Locale settings for dates, coins, etc...
  try:
    locales = {'en': 'en_US.UTF-8', 'es': 'es_ES.UTF-8', 'gl': 'gl_ES.UTF-8'}
    locale.setlocale(locale.LC_ALL, locales.get(selected, 'C'))

  except Exception:
    # fallback to C if locale not available
    locale.setlocale(locale.LC_ALL, 'C')

  return _
