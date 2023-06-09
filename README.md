# restoR

This straightforward (and still largely untested!) script aims to restore all of the R packages you had installed in your previous version of R after updating to a new version.

Basically, it just looks for the library folder of the last installation and tries to install all of the packages that aren't included in the new base installation. It will try to treat the package as a BioConductor package first and fall back to installing from CRAN. If both of these fail (e.g. for non-repository packages) then you get a vector of remaining packages that you will just need to deal with by hand.

I have found this useful to get my system back to work after an upgrade. This script is new and still essentially untested. It carries no warranty.

## Usage
The script can be downloaded and run in one command: `source("https://raw.githubusercontent.com/rupertoverall/restoR/main/restoR.R")
`
