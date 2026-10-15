#!/usr/bin/env python3
"""Print a mermaid.live link that opens the diagram read on stdin.

The diagram sits in the URL fragment, which the browser keeps to itself.
"""
import base64
import json
import sys
import zlib

state = json.dumps({"code": sys.stdin.read().strip(), "mermaid": '{"theme":"default"}'})
packed = base64.urlsafe_b64encode(zlib.compress(state.encode(), 9)).decode().rstrip("=")
print("https://mermaid.live/view#pako:" + packed)
