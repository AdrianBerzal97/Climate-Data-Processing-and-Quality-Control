# Quality-control checklist

1. **Provenance:** record provider, product, URL, download date, spatial/temporal resolution, model, scenario, station and version.
2. **Spatial:** distinguish gridded-cell centres, town-centre coordinates, research plots and station locations; inspect projection, grid rotation and nearest-cell distance.
3. **Time:** inspect CF `units` and `calendar`; handle `360_day` and `noleap` explicitly. Do not interpret NetCDF layer indices as dates without validation.
4. **Units:** verify temperature in K versus °C, precipitation flux versus daily accumulation, radiation units, wind-speed units and ET0 units before conversion.
5. **Completeness:** check duplicates, missing dates, missing values, coverage by variable/site/model, historical-to-scenario transitions and suspicious extremes.
6. **Consistency:** check `tasmax >= tasmin`, non-negative precipitation where applicable and cross-source station/grid discrepancies.
7. **Outputs:** retain raw values and metadata in intermediate files; document transformations and keep original downloads outside Git.

**Validation status:** scripts are public portfolio adaptations. The AEMET and AdapteCCa code is carried over from the author's existing repositories; ROCIO and SiAR scripts are simplified, configurable adaptations of user-provided research scripts. No end-to-end verification against source files or authenticated APIs has been completed.
