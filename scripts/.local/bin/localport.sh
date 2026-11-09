#!/bin/bash

PORT=$(printf "8000\n8080\n8096\n3000\n" | rofi -dmenu -p "Port")

[ -z "$PORT" ] && exit

firefox "http://localhost:$PORT"
