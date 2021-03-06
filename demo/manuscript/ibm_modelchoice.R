rm(list=ls())
require(warningsignals)
require(socialR)
script <- "ibm_modelchoice.R"
gitaddr <- gitcommit(script)

T<- 1000
n_pts <- 500
require(warningsignals)

## Collapsing example parameters 
pars = c(Xo = 730, e = 0.5, a = 100, K = 1000, h = 200, 
    i = 0, Da = .09, Dt = 0, p = 2)

## Run the individual based simulation
sn <- saddle_node_ibm(pars, times=seq(0,T, length=n_pts))
# format output as timeseries
ibm_critical <- ts(sn$x1,start=sn$time[1], deltat=sn$time[2]-sn$time[1])

cpu <- 16
nboot <- 500
lsn <- fit_models(ibm_critical, "LSN")
ltc <- fit_models(ibm_critical, "LTC")
mc <- remove_unconverged(montecarlotest(ltc$timedep, lsn$timedep, 
                                        cpu=cpu, nboot=nboot))

save(list=ls(), file="ibm_modelchoice.Rdat")
