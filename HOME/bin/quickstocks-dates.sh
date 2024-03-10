#!/usr/bin/env bash

fromDate=""
toDate=""

while getopts f:t: flag
do
    case "${flag}" in
        f) fromDate=${OPTARG};;
        t) toDate=${OPTARG};;
    esac
done

echo fromDate: $fromDate
echo toDate: $toDate

curl "http://localhost:9005/history?from=${fromDate}&to=${toDate}&symbols=^axjo,amp.ax,bhp.ax,bkl.ax,bvs.ax,cba.ax,flt.ax,hum.ax,hvn.ax,llc.ax,ori.ax,qbe.ax,s32.ax,sgp.ax,sol.ax,sul.ax,twe.ax,web.ax,wmi.ax,wor.ax&format=csvPortfolio"