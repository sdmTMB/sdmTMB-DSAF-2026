files <- list.files("exercises/", pattern = "*.qmd")
ans_files <- files[grepl("answers", files)]

for (ans_file in ans_files) {
  # Read the answer file
  f_ans <- readLines(file.path("exercises", ans_file))

  # Remove lines ending with "# answer"
  f <- f_ans[!grepl("# answer$", f_ans)]

  # Uncomment lines ending with "# exercise"
  for (i in seq_along(f)) {
    if (grepl(" # exercise$", f[i])) {
      # If line contains "=" but NOT "<-" (function argument), replace leading "# " with "  " to maintain indentation
      if (grepl("=", f[i]) && !grepl("<-", f[i])) {
        f[i] <- gsub("^# ", "  ", f[i])
        f[i] <- gsub("^#", " ", f[i])
      } else {
        # Otherwise, just remove the leading "# " or "#"
        f[i] <- gsub("^# ", "", f[i])
        f[i] <- gsub("^#", "", f[i])
      }
    }
  }

  # Create output filename by removing "-answers"
  out_file <- gsub("-answers", "", ans_file)

  # Write to output file
  writeLines(f, file.path("exercises", out_file))

  cat("Processed:", ans_file, "->", out_file, "\n")
}
