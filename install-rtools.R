
# May 2024: requirements to build against 4.4 WIRADA-700


if (version$major != '4') {print("Unexpected version of R: major is not 4"); q(save='no', status=1)}
if (version$minor[1] != '4') {print("Unexpected version of R: minor is not 4.x"); q(save='no', status=1)}

r <- getOption("repos")
r["CRAN"] <- "https://cran.csiro.au"
options(repos = r)

print("Installing installr")
install.packages(c('installr'), quiet=TRUE, type="win.binary")

print("Installing rtools if need be")
rtinst = install.Rtools(check = TRUE, check_r_update = FALSE, GUI = FALSE)

if (!rtinst)  {q(save='no', status=1)}