# packages
library(tidyverse)

# read Excel file
# replace path and sheet name as needed
df <- read_csv("~/Downloads/CDVS_workshops_spring_2026.csv")

# helper: clean date header like "Wed, Jan 14" -> "Jan 14"
format_date_header <- function(x) {
  x |>
    str_remove("^\\w+,\\s*") |>   # remove weekday
    str_trim()
}

# build markdown
md <- df |>
  mutate(
    date_header = format_date_header(Date),
    title = Workshop,
    time_clean = Time,
    location = Mode,
    register_md = paste0("[Click here to register](", registration_link, ")")
  ) |>
  rowwise() |>
  mutate(
    markdown = paste(
      paste0("### ", date_header),
      "",
      paste0("#### ", title),
      "",
      paste0("- **Location**: ", location),
      "",
      paste0("- **Time**: ", time_clean),
      "",
      paste0("- **Description**:  ", description),
      "",
      paste0("- **Register**: ", register_md, "."),
      "",
      sep = "\n"
    )
  ) |>
  pull(markdown)

# write to file (or use cat(md) to print)
writeLines(md, "workshops.md")
