#!/usr/bin/env bash

connectivity_get() {
  nmcli networking connectivity
  # can return none, portal (captive), limited (no internet), full, unknown
}


# returns type (wifi, ethernet) state (connected, unavailable, disconnected)
nmcli -f TYPE,STATE dev status


# returns current signal strength 0-100
nmcli -f GENERAL.STATE dev show wlo1 | awk '{print $2}'

