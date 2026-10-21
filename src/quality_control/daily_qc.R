# Reusable daily climate time-series QC (base R, no external dependencies).
# Usage: Rscript src/quality_control/daily_qc.R input.csv output_summary.csv
# Required columns: site,date,value; date YYYY-MM-DD, value numeric.
daily_qc <- function(data, start_date=NULL, end_date=NULL) {
  required <- c("site","date","value")
  if(!all(required %in% names(data))) stop("Required columns: site,date,value")
  if(!nrow(data)) stop("Input is empty")
  data$site <- as.character(data$site)
  if(anyNA(data$site) || any(!nzchar(trimws(data$site)))) stop("Invalid site")
  dates <- as.Date(as.character(data$date),format="%Y-%m-%d")
  if(any(is.na(dates) & !is.na(data$date))) stop("Unparseable date")
  if(anyNA(dates)) stop("Missing dates")
  data$date <- dates
  raw_values <- as.character(data$value)
  values <- suppressWarnings(as.numeric(raw_values))
  if(any(is.na(values) & !is.na(data$value) & nzchar(raw_values))) stop("Non-numeric value")
  data$value <- values
  if(is.null(start_date)) start_date <- min(dates)
  if(is.null(end_date)) end_date <- max(dates)
  start_date <- as.Date(start_date); end_date <- as.Date(end_date)
  if(is.na(start_date) || is.na(end_date) || end_date < start_date) stop("Invalid expected date range")
  if(any(dates < start_date | dates > end_date)) stop("Records outside expected date range")
  expected <- seq(start_date,end_date,by="day")
  result <- lapply(sort(unique(data$site)),function(s) {
    x <- data[data$site == s,,drop=FALSE]
    unique_dates <- unique(x$date)
    valid <- x$value[is.finite(x$value)]
    data.frame(site=s, start_date=as.character(start_date),end_date=as.character(end_date),
      expected_days=length(expected),rows=nrow(x),observed_unique_days=length(unique_dates),
      missing_days=sum(!expected %in% unique_dates),
      duplicate_rows=nrow(x)-length(unique_dates),
      missing_or_nonfinite_values=sum(!is.finite(x$value)),
      valid_rows=sum(is.finite(x$value)),
      valid_row_pct=round(100*sum(is.finite(x$value))/nrow(x),2),
      min_value=if(length(valid))min(valid) else NA_real_,
      max_value=if(length(valid))max(valid) else NA_real_,
      stringsAsFactors=FALSE)
  })
  do.call(rbind,result)
}
if(sys.nframe()==0L) {
  args <- commandArgs(trailingOnly=TRUE)
  if(length(args)!=2L) stop("Usage: Rscript src/quality_control/daily_qc.R input.csv output.csv")
  input<-read.csv(args[1],stringsAsFactors=FALSE,check.names=FALSE)
  report<-daily_qc(input)
  dir.create(dirname(args[2]),recursive=TRUE,showWarnings=FALSE)
  write.csv(report,args[2],row.names=FALSE)
  print(report)
}
