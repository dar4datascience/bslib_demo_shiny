# Overarching bslib theme
fn_custom_theme <- function() {
  bslib::bs_theme(
    version = "4",
    base_font = sass::font_google("Poppins"),
    bg = "#100C08",
    fg = "#F0FFFF",
    primary = "#781F0C", 
    secondary = "#1d2d42",
    success = "#1d2d42") |> 
    bs_add_variables("border-bottom-width" = "6px",
                     "border-color" = "$primary",
                     .where = "declarations") |> 
    bs_add_rules(sass::sass_file("www/styles.scss"))
}

# Thematic theme for ggplot2 outputs
fn_thematic_theme <- function() {
  thematic::thematic_theme(
    bg = "#100C08",
    fg = "#F0FFFF",
    accent = "#ff8c00",
    font = font_spec(sass::font_google("Poppins"), scale = 1.75)
  )
}