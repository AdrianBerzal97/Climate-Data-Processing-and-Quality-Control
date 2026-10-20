# Source code

- `adaptecca/`: NetCDF metadata diagnostics and extraction at study sites. Download is **manual via THREDDS**.
- `aemet/`: daily meteorological API download scripts for 2000–2020 and 2021–2025. Set `AEMET_API_KEY` locally.
- `rocio/`: extraction from 2D rotated-grid NetCDF using nearest geographic grid cell. Example: `Rscript src/rocio/extract_grid_5km.R input.nc tmax outputs/rocio/tmax.csv`. Confirm the source variable and dimension names.
- `siar/`: station catalog and daily ET0, precipitation and wind from SiAR API. Set `SIAR_TOKEN` locally. Configure `SIAR_STATIONS`, `CLIMATE_START_DATE`, `CLIMATE_END_DATE` and `CLIMATE_OUTPUT_DIR` if needed. Use `SIAR_CATALOG_ONLY=1` to download only the station catalog.

See `docs/quality_control.md` before using outputs in research. None of these scripts has been tested end-to-end here.
