# Reproducible tests using synthetic data only. Run from repository root.
source("src/quality_control/daily_qc.R")
source("tests/generate_synthetic_data.R")
x<-synthetic_daily()
z<-daily_qc(x,as.Date("2024-01-01"),as.Date("2024-01-07"))
stopifnot(nrow(z)==1L,z$expected_days==7L,z$rows==7L,
          z$observed_unique_days==6L,z$missing_days==1L,
          z$duplicate_rows==1L,z$missing_or_nonfinite_values==1L,
          z$valid_rows==6L,z$min_value==10,z$max_value==15)
err<-try(daily_qc(transform(x,date="invalid")),silent=TRUE)
stopifnot(inherits(err,"try-error"))
err2<-try(daily_qc(transform(x,value="not_a_number")),silent=TRUE)
stopifnot(inherits(err2,"try-error"))
message("All synthetic QC tests passed")
