# HS-sports-effects

## Guide to replication
To replicate all results presented in the paper, execute the file `master.do` which is contained in the main directory. Note that this presumes access to the Add Health data. Add Health results will not be replicable without first obtaining access to the Add Health data set. Due to confidentiality limitations, we are not able to share the Add Health data on this repository or by any other means.

## Downloading data from source
If you wish to download data from orignal sources, you may do so from the following locations:

1. NLSY79: Go to <https://www.nlsinfo.org/investigator/pages/login.jsp>, click "Register" in the top right hand corner of the screen, create an account, sign in, select "NLSY79" from the drop-down list, and then upload the `*.NLSY79` "tag" files included in the `NLSY79data/` folder of this repository. Then follow directions to download.

2. NELS:88: Go to <https://nces.ed.gov/EDAT/>, click the link to agree to the terms of service (i.e. that you will only use the data for statistical purposes), then create an account, log in, and select the "NELS:1988/00" study. You must manually create a "tag file" (similar to the file `NELS88tags.tag` included in the `NELS88data/` folder of this repository) and then choose a data format for the downloaded data that corresponds to those tags. The EDAT system will also offer you the chance to download code files to read in the raw data you've downloaded.

3. Add Health: To access the restricted-use Add Health data, please read details at the following website: <http://www.cpc.unc.edu/projects/addhealth/documentation/restricteduse>. Creating a contract with Add Health takes about 6-8 weeks and costs a minimum of $850.

## Required software
In order to replicate this repository, you must have installed Stata 13.1 (or higher) and Brian Krauth's `rcr` Stata package. Directions for downloading `rcr` can be found on Brian Krauth's [website](http://www.sfu.ca/~bkrauth/code.htm).

