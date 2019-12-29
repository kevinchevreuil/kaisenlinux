#!/bin/bash

TV_SCRIPT_DIR="$(dirname "$0")"
TV_BIN_DIR="$(dirname "$TV_SCRIPT_DIR")"
TV_BASE_DIR="$(dirname "$TV_BIN_DIR")"
TV_LOG_DIR="$TV_BASE_DIR/logfiles"

TV_DBUS_SOCKET='/var/run/dbus/system_bus_socket'
TV_LOGIND_SV='/usr/share/dbus-1/system-services/org.freedesktop.login1.service'
TV_CONSOLEKIT_SV='/usr/share/dbus-1/system-services/org.freedesktop.ConsoleKit.service'

function WaitForNetwork
{
  for ((TVD_CTR_NW=0; TVD_CTR_NW<20; TVD_CTR_NW++)); do
    CheckNetwork && break

    echo -n ':'
    sleep 1
  done
}

function WaitForServices
{
  [ -x $(command -v "dbus-send" >/dev/null 2>&1) ] || return

  for ((TVD_CTR_SV=0; TVD_CTR_SV<10; TVD_CTR_SV++)); do
    # check prerequirement: dbus system bus
    if [ -S "$TV_DBUS_SOCKET" ]; then

      # check for logind and ConsoleKit but prefer logind
      if [ -e "$TV_LOGIND_SV" ]; then
        StartService "login1"
        CheckService "login1" && break

      elif [ -e "$TV_CONSOLEKIT_SV" ]; then
        StartService "ConsoleKit"
        CheckService "ConsoleKit" && break

      else
        break
      fi

    fi

    echo -n '.'
    sleep 1
  done
}

function WriteLog
{
  local timestamp="$(date +%F\ %H:%M:%S)"
  local servicesPart='no dbus services'
  local logfile="$TV_LOG_DIR/startup_daemon.log"
  local log_old="$logfile.old"

  [ -n "$TVD_CTR_SV" ] && servicesPart="${TVD_CTR_SV}s (dbus, ConsoleKit / logind)"

  echo "$timestamp Waited ${TVD_CTR_NW}s (network) / $servicesPart" >> "$logfile"

  # trim log
  cmdExists wc || return
  cmdExists cat || return
  [ -f "$logfile" ] || return
  local linecnt=$(cat "$logfile" | wc -l)
  (( linecnt >= 100 )) && mv -f "$logfile" "$log_old"
}

function cmdExists()
{
  command -v "$1" >/dev/null 2>&1
}

function CheckNetwork
{
  # check network (interface is up, not only MAC)
  #  ip -4 link | grep 'link/' | grep -qv '00:00:00:00:00:00' || TVD_RESPONSE=''
  cmdExists ip || return
  ip -4 addr | grep 'inet' | grep -qv 'inet 127.'
}

function CheckService
{
  dbus-send --print-reply --system --dest=org.freedesktop.DBus / org.freedesktop.DBus.NameHasOwner string:org.freedesktop.$1 | grep -q true
}

function StartService
{
  dbus-send --system --print-reply --dest=org.freedesktop.DBus / org.freedesktop.DBus.StartServiceByName string:org.freedesktop.$1 uint32:0
}

WaitForNetwork
WaitForServices
WriteLog

true
