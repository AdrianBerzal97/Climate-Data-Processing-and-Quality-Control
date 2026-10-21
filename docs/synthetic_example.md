# Quality-control example — SYNTHETIC DATA ONLY

The reproducible fixture in `tests/generate_synthetic_data.R` contains seven rows over 1–7 January 2024 for a fictitious site `DEMO_SYNTHETIC`. The fixture intentionally has one absent date (3 January), a duplicate date (4 January) and one missing value.

| site | expected_days | rows | observed_unique_days | missing_days | duplicate_rows | missing_or_nonfinite_values | valid_rows | min_value | max_value |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| DEMO_SYNTHETIC | 7 | 7 | 6 | 1 | 1 | 1 | 6 | 10 | 15 |

**These are calculated expectations from a deliberately constructed synthetic fixture, not observational results.**

Run from the repository root:

```bash
Rscript tests/test_daily_qc.R
Rscript tests/generate_synthetic_data.R outputs/synthetic/daily.csv
Rscript src/quality_control/daily_qc.R outputs/synthetic/daily.csv outputs/synthetic/qc.csv
```

The plotting script intentionally refuses duplicate dates. Resolve or document duplicates first; never silently choose one observation.
