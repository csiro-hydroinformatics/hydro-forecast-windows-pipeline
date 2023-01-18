# Build pipelines for hydrologic simulation and forecasting tools - Windows

## Purpose

Our [streamflow forecasting software stack](https://csiro-hydroinformatics.github.io/streamflow-forecasting-tools-onboard/) is quite mature and complicated. To facilitate building and packaging we need contemporary build pipeline to **minimise manual steps**.

This repository contains material to streamline the build, testing and possible deployment of hydrologic simulation and forecasting tools.

* Functional scope: swift and fogss, and dependencies, mostly in practice uchronia
* Management of versions of software built across many code repositories
* Unit tests are currently run on Windows as part of the pipeline

### Output artifacts

Available or potentially, we have:

* Debian packages (Beta)
* RPM packages (?)
* zip archives of prebuilt packages for windows.
* R packages (Mature)
* python packages (Beta)
* matlab functions (?)
* conda packages (Alpha - Feasibility study)
* offline and online documentation (Partial)

This build pipeline, and the ones related listed below in Related Work, are a foundation to deliver swift via the following paths

* Docker image with Jupyter-lab and the full stack available
* Pre-built binaries for windows, self contained C runtime (ms vc 2019), prebuilt R packages for windows
* Docker image for running on EASI
* Deployment on clusters
* Other

## Status

Currently, it builds packages for deployment on Windows, with user-oriented packages for Python and R.

## Related work

* [easi-hydro-forecast](https://bitbucket.csiro.au/projects/SF/repos/easi-hydro-forecast/browse)
* [hydro-fc-packaging](https://bitbucket.csiro.au/projects/SF/repos/hydro-fc-packaging/browse), which may be merged with this pipeline at some point.

## Appendix

[Microsoft hosted agents](https://docs.microsoft.com/en-us/azure/devops/pipelines/agents/hosted?view=azure-devops&tabs=yaml) lists what is available. Only recent versions of VStudio are available (fair enough). Not sure this is worth sticking to VS 2013 anymore really.

Should we revive building with cmake on windows rather than using our custom curated .vcproj files?

