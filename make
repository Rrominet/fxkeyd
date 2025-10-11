#!/usr/bin/env python3

from ml import build
from ml.boilerplate import cpp
from ml import fileTools as ft
import os
import sys
sys.path.append("../")

fm = "/media/romain/Donnees/Programmation/cpp/frameworks"
libs = "/media/romain/Donnees/Programmation/cpp/libs"

for arg in sys.argv:
    if "libs=" in arg:
        libs = arg.split("=")[1]
    elif "fm=" in arg or "cpp-utils=" in arg:
        fm = arg.split("=")[1]

cpp.generate("../src")

includes = [
    "../src",
    libs + "/json",
    libs + "/eigen",
    fm,
        ]

srcs = [
        "../src",
        "../src/vkbd/uinput.c",
        ]

libs = [
        ]

defs = ["NO_LOG"]

cpp = build.create("fxkeyd", sys.argv)
cpp.static = False
cpp.includes = includes
cpp.addToSrcs(srcs)
cpp.addToLibs(libs)
cpp.definitions += defs

cpp.flags += ["-std=c++17", "-std=c11",
              "-DVERSION=\"vfx_1.0.0 keyd version for fxos\"", 
              "-DSOCKET_PATH=\"/var/run/keyd.socket\"",
              "-DCONFIG_DIR=\"/etc/keyd\"",
              "-DDATA_DIR=\"/usr/local/share/keyd\"",
              "-D_FORTIFY_SOURCE=2",
              "D_DEFAULT_SOURCE",
              "-lpthread",
              ]

if not cpp.release : 
    cpp.addToLibs([
        "stdc++fs",
        fm + "/build/libmlapi.so",
        ])

elif cpp.release : 
    cpp.addToLibs([
        "stdc++fs",
        "mlapi",
        ])

if("clean" in sys.argv or "clear" in sys.argv):
    cpp.clean()
    exit()
else:
    cpp.build()
