#!/usr/bin/env python
import os
import sys

try:
    print(f"\033[1mVirtual Environment PATH and name:\033[0m  {os.environ['VIRTUAL_ENV']}")
    print(f"\033[1mAbsolute path of the executable binary for the Python interpreter:\033[0m {sys.executable}")
    print(f"\033[1mPython version you are using:\033[0m {sys.version}")
except KeyError:
    print(f"You are not in a virtual environment")
