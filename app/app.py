#!/usr/bin/env python3
"""APP main"""
from model import Model
from view import View
from presenter import Presenter

if __name__ == "__main__":

  presenter = Presenter(model=Model(), view=View())
  presenter.run(application_id="es.udc.fic.ipm.AdwRageAgainstTheMachine")
