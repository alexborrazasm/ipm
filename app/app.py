#!/usr/bin/env python3
from model import Model
from view import AdwView
from presenter import Presenter

if __name__ == "__main__":

  presenter = Presenter(model=Model(), view=AdwView())
  presenter.run(application_id="es.udc.fic.ipm.AdwRageAgainstTheMachine")