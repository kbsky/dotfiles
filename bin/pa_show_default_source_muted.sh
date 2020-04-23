#!/bin/bash
pacmd list-sources | awk '/^\s*\* index/,/^\s*index/ { if (/muted:/) { print ($2 == "yes" ? "Muted" : "Listening"); exit } }'
