#!/bin/sh

# Run quote for most recent day on stock exchange
# 15.7.23 - calling script in the project.  A .env file is required and a .env.template should have correct values, but if not it should contain:
# indices=^axjo
# symbols=amp.ax,bhp.ax,bkl.ax,bvs.ax,cba.ax,flt.ax,hum.ax,hvn.ax,llc.ax,ori.ax,qbe.ax,s32.ax,sgp.ax,sol.ax,sul.ax,twe.ax,web.ax,wmi.ax,wor.ax

#curl http://localhost:9005/quote/price\?symbols=^axjo,amp.ax,bhp.ax,bkl.ax,bvs.ax,cba.ax,flt.ax,hum.ax,hvn.ax,llc.ax,ori.ax,qbe.ax,s32.ax,sgp.ax,sol.ax,sul.ax,twe.ax,web.ax,wmi.ax,wor.ax\&format=csvPortfolio

pushd ~/dev/home/quickStocks/quickstocks > /dev/null
. ./scripts/quickStocks-Portfolio-historyToToday.sh
popd > /dev/null

