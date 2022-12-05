#!/usr/bin/env nix-shell
#!nix-shell -i python3 -p "python3.withPackages(ps: [ ps.configparser ])"

import configparser
import os
import sys

if len(sys.argv) == 2:
  arg = sys.argv.pop()

  if os.path.exists(arg):
    config = configparser.ConfigParser()

    if os.path.exists(f'{os.getenv("HOME")}/.mozilla/firefox/profiles.ini'):
      config.read(f'{os.getenv("HOME")}/.mozilla/firefox/profiles.ini')

      for section in config:
        if config[section].get("Default") == "1":
          profile_path = config[section].get("Path")

          if profile_path:
            os.system(f'cp {arg} {os.getenv("HOME")}/.mozilla/firefox/{profile_path}/user.js')
