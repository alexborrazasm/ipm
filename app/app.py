#!/usr/bin/env python3
"""APP main"""
from pathlib import Path
from i18n import setup_i18n
from model import Model
from view import View
from presenter import Presenter

# i18n
LOCALE_DIR = Path(__file__).parent.parent/"locales"
_ = setup_i18n(LOCALE_DIR)

if __name__ == "__main__":

  presenter = Presenter(model=Model(), view=View())
  presenter.run(application_id="es.udc.fic.ipm.AdwRageAgainstTheMachine")
