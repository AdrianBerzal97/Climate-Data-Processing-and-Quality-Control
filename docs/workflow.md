# Climate data processing workflow

```mermaid
flowchart TD
  A[AdapteCCa THREDDS manual NetCDF] --> E[Inspect provenance and metadata]
  B[AEMET API observations] --> E
  C[ROCIO gridded NetCDF] --> E
  D[SiAR API observations] --> E
  E --> F[Spatial and temporal extraction]
  F --> G[Check calendars, units and site locations]
  G --> H[Daily series quality control]
  H --> I[Missing dates, duplicates and extremes]
  I --> J[Diagnostic figures and QC summary]
  J --> K[Research-ready input only after validation]
```

Sources have distinct spatial supports and temporal coverages. Arrows show the conceptual workflow, **not** an automated end-to-end pipeline. THREDDS downloads are manual and original data are excluded.
