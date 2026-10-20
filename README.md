# Climate Data Processing and Quality Control

R workflows for climate data acquisition, NetCDF extraction and quality checks. Includes methods from CEIGRAM and related environmental research, organized by provider.

## Workflows

- **AdapteCCa:** manual THREDDS downloads, NetCDF diagnostics and spatial extraction. See [diagnostics](src/adaptecca/diagnose_netcdf.R) and [extraction](src/adaptecca/extract_sites.R).
- **AEMET:** API-based daily station observations, with separate scripts for [2000–2020](src/aemet/download_daily_2000_2020.R) and [2021–2025](src/aemet/download_daily_2021_2025.R).
- **ROCIO:** [5-km gridded NetCDF extraction](src/rocio/extract_grid_5km.R), adapted from CEIGRAM work.
- **SiAR:** [ET0, precipitation and wind data](src/siar/download_et0_wind.R), adapted from CEIGRAM work.

## Getting started

Install R packages: ncdf4, terra, httr, jsonlite, dplyr, openxlsx. Read the [script guidance](src/README.md), [source provenance](docs/data_sources.md) and [quality checks](docs/quality_control.md).

Configure AEMET_API_KEY and SIAR_TOKEN as local environment variables where needed. Do not upload access credentials or downloaded research data. Original SiAR credentials should be rotated before reuse.

The code is provided as portfolio examples and has not been verified end-to-end with original datasets or authenticated API calls. The ROCIO and SiAR workflows are independent CEIGRAM-related work, not automatically part of the doctoral analyses.

## Related repositories

- [SIMPAST grassland climate model](https://github.com/AdrianBerzal97/Mediterranean-grassland-climate-model)
- [MODIS NDVI time-series analysis](https://github.com/AdrianBerzal97/MODIS-NDVI-time-series-analysis)

No license has been selected.
