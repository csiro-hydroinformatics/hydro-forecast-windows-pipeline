
# May 2024: requirements to build against 4.4 WIRADA-700

if (version$major != '4') {print(paste("Unexpected version of R: major is not 4 but", version$major)); q(save='no', status=1)}

# if R version is 4.4.2 then version$minor is 4.2 . We do not want to check exactly the relase part "2", but that "4"
minor <- substr(version$minor[1], 1, 1)
if ( minor != '4') {print(paste("Unexpected minor version of R: minor is not '4' but", minor, "full minor version nb is ", version$minor)); q(save='no', status=1)}

r <- getOption("repos")
r["CRAN"] <- "https://cran.csiro.au"
options(repos = r)

print("Installing installr")
install.packages(c('installr'), quiet=TRUE, type="win.binary")

library("installr")
print("Installing rtools if need be")
# Capture the output
output <- capture.output({
    rtinst = install.Rtools(check = TRUE, check_r_update = FALSE, GUI = FALSE)
})

# Get the last standard output message
last_message <- tail(output, n = 1)
print(last_message)
if (!rtinst)  
{
    if (last_message!="No need to install Rtools - You've got the relevant version of Rtools installed")
    {
        q(save='no', status=1)
    }
}