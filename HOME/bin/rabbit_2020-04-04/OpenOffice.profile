#!/bin/bash
# File: OpenOffice.bashrc
# Created: Brooke Smith 2004 11 02
# Purpose: Open Office setup and helpers

OPENOFFICEBASE=/Applications/OpenOffice

export DYLD_LIBRARY_PATH=$DYLD_LIBRARY_PATH:$OPENOFFICEBASE/program/filter

function openOffice () {
  cd $OPENOFFICEBASE/program
  sh soffice
}
