# Data sources and provenance

| Provider | Source type | Acquisition | Scripts | Important distinction |
| --- | --- | --- | --- | --- |
| AdapteCCa | Climate-model NetCDF, including CMIP6 scenarios | Manual THREDDS download | `src/adaptecca/` | Modelled climate forcing; inspect calendar, units and scenarios |
| AEMET | Meteorological station observations | Authenticated API | `src/aemet/` | Station codes 3110C, 3191E, 3100B used in source study; station locations are not the study-site centroids |
| ROCIO | Gridded climate data, approximately 5-km resolution | Locally provided NetCDF files | `src/rocio/` | Original script used 2021–2022 and approximate town-centre coordinates |
| SiAR | Agricultural meteorological station data | Authenticated API | `src/siar/` | Original script used 2024–2025; candidate stations require verification |

These workflows originated from separate CEIGRAM and research activities. Their outputs must not be treated as interchangeable observations or as validated SIMPAST forcing without harmonisation and independent checks.

Original research files, downloaded observations and API credentials are excluded.
