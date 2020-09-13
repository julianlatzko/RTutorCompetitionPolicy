library(ggplot2)
library(dplyr)
library(skimr)

# Customize skimr function
my_skim = skim_with(character = sfl(n_unique = n_unique), 
                    numeric = sfl(mean = ~ mean(., na.rm = TRUE), 
                                  sd = ~ sd(., na.rm = TRUE), 
                                  min = ~ min(., na.rm = TRUE), 
                                  max = ~ max(., na.rm = TRUE)), 
                    append = FALSE)

# scale_dat()
# Function for standardizing all numeric variables of a data frame
scale_dat = function(dat){
  stopifnot("Argument 'dat' must be a data frame" = (is.data.frame(dat)))
  
  # Function for lapply
  sc = function(x){
    if (is.numeric(x)){
      x = as.numeric(scale(x, center = TRUE, scale = TRUE))
    }
    return(x)  
  }
  
  # Create data frame with lapply  
  scaled = as.data.frame(lapply(dat, FUN = sc))
  return(scaled)
}

# confint_frame(reg, alpha = 0.05)
# Function that takes a felm object and a p-value to create a data frame for errorbar plots

confint_frame = function(reg, alpha = 0.05){
  stopifnot(
    "Argument 'reg' has to be class 'felm'" = (class(reg) == "felm"),
    "Alpha has to be a single value" = (length(alpha) == 1),
    "Alpha must be greater than 0" = (alpha > 0),
    "Alpha must be smaller than 1" = (alpha < 1)
  )
  p = 1 - alpha/2
  df = data.frame(coef = coef(reg),
                  var = names(coef(reg)),
                  lower = coef(reg) - qt(p = p, df = reg$df) * reg$cse,
                  upper = coef(reg) + qt(p = p, df = reg$df) * reg$cse)
  return(df)
}

# calc_hi()
# Function for computing an exogenous Herfindahl index as described by Aghion et al. (2015)
calc_hi = function(x){
  hi = numeric(length = length(x))
  for(i in seq_along(hi)){
    x_i = x[-i]
    hi[i] = sum((x_i/sum(x_i))^2)
  }
  return(hi)
}

# Specify two custom color palettes for usage with ggplot themes - blue and green
colours_custom <- c("#6794a7", "#014d64", "#01a2d9", "#7ad2f6", "#00887d", "#76c0c1", "#7c260b", "#ee8f71", "#adadad")
colours_custom2 <- c("#66BD63", "#1A9850")

# Functions for custom ggplot2 themes - blue and green strips
theme_blue <- function(base_size = 11, base_family = "sans",
                       base_line_size = base_size / 22,
                       base_rect_size = base_size / 22) {
  
  # The half-line (base-fontsize / 2) sets up the basic vertical
  # rhythm of the theme. Most margins will be set to this value.
  # However, when we work with relative sizes, we may want to multiply
  # `half_line` with the appropriate relative size. This applies in
  # particular for axis tick sizes. And also, for axis ticks and
  # axis titles, `half_size` is too large a distance, and we use `half_size/2`
  # instead.
  half_line <- base_size / 2
  
  # Throughout the theme, we use three font sizes, `base_size` (`rel(1)`)
  # for normal, `rel(0.8)` for small, and `rel(1.2)` for large.
  
  theme(
    # Elements in this first block aren't used directly, but are inherited
    # by others
    line =               element_line(
      colour = "black", size = base_line_size,
      linetype = 1, lineend = "butt"
    ),
    rect =               element_rect(
      fill = "#f9f5f1", colour = NA,
      size = base_rect_size, linetype = 1
    ),
    text =               element_text(
      family = base_family, face = "plain",
      colour = "black", size = base_size,
      lineheight = 0.9, hjust = 0.5, vjust = 0.5, angle = 0,
      margin = margin(), debug = FALSE, inherit.blank = TRUE
    ),
    
    axis.line =          element_line(size = 0.6, inherit.blank = TRUE),
    axis.line.x =        NULL,
    axis.line.y =        element_blank(),
    axis.text =          element_text(size = rel(0.8), colour = "black"),
    axis.text.x =        element_text(margin = margin(t = 0.8 * half_line), vjust = 0),
    axis.text.x.top =    element_text(margin = margin(b = 0.8 * half_line), vjust = 0),
    axis.text.y =        element_text(margin = margin(r = 0.8 * half_line), hjust = 0,),
    axis.text.y.right =  element_text(margin = margin(l = 0.8 * half_line), hjust = 0),
    axis.ticks =         element_line(colour = "black"),
    axis.ticks.y =       element_blank(),
    axis.ticks.length =  unit(-4, "pt"),
    axis.ticks.length.x = NULL,
    axis.ticks.length.x.top = NULL,
    axis.ticks.length.x.bottom = NULL,
    axis.ticks.length.y = NULL,
    axis.ticks.length.y.left = NULL,
    axis.ticks.length.y.right = NULL,
    axis.title.x =       element_text(
      margin = margin(t = half_line / 2),
      vjust = 1
    ),
    axis.title.x.top =   element_text(
      margin = margin(b = half_line / 2),
      vjust = 0
    ),
    axis.title.y =       element_text(
      angle = 90,
      margin = margin(r = half_line / 2),
      vjust = 1
    ),
    axis.title.y.right = element_text(
      angle = -90,
      margin = margin(l = half_line / 2),
      vjust = 0
    ),
    
    legend.background =  element_rect(colour = NA),
    legend.spacing =     unit(2 * half_line, "pt"),
    legend.spacing.x =    NULL,
    legend.spacing.y =    NULL,
    legend.margin =      margin(half_line, half_line, half_line, half_line),
    legend.key =         element_blank(),
    legend.key.size =    unit(1.2, "lines"),
    legend.key.height =  NULL,
    legend.key.width =   NULL,
    legend.text =        element_text(size = rel(0.8)),
    legend.text.align =  NULL,
    legend.title =       element_text(hjust = 0),
    legend.title.align = NULL,
    legend.position =    "none",
    legend.direction =   NULL,
    legend.justification = "center",
    legend.box =         NULL,
    legend.box.margin =  margin(0, 0, 0, 0, "cm"),
    legend.box.background = element_blank(),
    legend.box.spacing = unit(2 * half_line, "pt"),
    
    panel.background =   element_blank(),
    panel.border =       element_blank(),
    panel.grid =         element_line(colour = "white"),
    panel.grid.major =   element_line(size = rel(1.5)),
    panel.grid.minor =   element_blank(),
    panel.grid.major.x = element_blank(),
    panel.spacing =      unit(half_line, "pt"),
    panel.spacing.x =    NULL,
    panel.spacing.y =    NULL,
    panel.ontop    =     FALSE,
    
    strip.background =   element_rect(fill = "#6794a7", colour = "#6794a7"),
    strip.text =         element_text(
      colour = "black",
      size = rel(0.8),
      margin = margin(0.8 * half_line, 0.8 * half_line, 0.8 * half_line, 0.8 * half_line)
    ),
    strip.text.x =       NULL,
    strip.text.y =       element_text(angle = -90),
    strip.placement =    "inside",
    strip.placement.x =  NULL,
    strip.placement.y =  NULL,
    strip.switch.pad.grid = unit(half_line / 2, "pt"),
    strip.switch.pad.wrap = unit(half_line / 2, "pt"),
    
    plot.background =    element_rect(colour = "#f9f5f1"),
    plot.title =         element_text( # font size "large"
      size = rel(1.2),
      hjust = 0, vjust = 1, face = "bold",
      margin = margin(b = half_line)
    ),
    plot.subtitle =      element_text( # font size "regular"
      hjust = 0, vjust = 1,
      margin = margin(b = half_line)
    ),
    plot.caption =       element_text( # font size "small"
      size = rel(0.7),
      hjust = 1, vjust = 1, face = "italic",
      margin = margin(t = half_line)
    ),
    plot.tag =           element_text(
      size = rel(1.2),
      hjust = 0.5, vjust = 0.5
    ),
    plot.tag.position =  'topleft',
    plot.margin =        margin(half_line, half_line, half_line, half_line),
    
    complete = TRUE
  )
}

# Modify theme_blue with green strip.background
theme_green <- function(base_size = 11, base_family = "sans",
                         base_line_size = base_size / 22,
                         base_rect_size = base_size / 22) {
  
  half_line <- base_size / 2

  theme_blue(
      base_size = base_size,
      base_family = base_family,
      base_line_size = base_line_size,
      base_rect_size = base_rect_size
    ) %+replace%
      theme(strip.background = element_rect(fill = "#7AC36A", colour = "#7AC36A")
  )
}
