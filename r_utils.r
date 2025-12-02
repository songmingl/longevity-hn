library(ggplot2)
library(ggpubr)
library(patchwork)

# color map ------------------------------------------------
zeileis_28 <- c(
  "#E41A1C", "#377EB8", "#4DAF4A", "#984EA3", "#FF7F00",
  "#FFFF33", "#A65628", "#F781BF", "#999999", "#66C2A5",
  "#FC8D62", "#8DA0CB", "#E78AC3", "#A6D854", "#FFD92F",
  "#E5C494", "#B3B3B3", "#8DD3C7", "#FFFFB3", "#BEBADA",
  "#FB8072", "#80B1D3", "#FDB462", "#B3DE69", "#FCCDE5",
  "#D9D9D9", "#BC80BD", "#CCEBC5"
)

major_group_col <- c(
  "Case" = "#3B4992",
  "Ctrl" = "#008B45"
)

age_group_col <- c(
  "[20, 40)" = "#CCEBC5",
  "[40, 60)" = "#4DAF4A",
  "[60, 80)" = "#80B1D3",
  "[80, 100)" = "#1782ae",
  ">=100" = "#464a96"
)

gender_col <- c(
  "F" = "#514fef",
  "M" = "#FB8072"
)

change_col <- c(
  "up" = "#E41A1C",
  "down" = "#514fef"
)


# settings ------------------------------------------------
theme_set(theme_pubr(12))
options(readr.show_col_types = FALSE)


# funcs ---------------------------------------------------
n_unique <- function(df, cname) {
  dplyr::pull(df, cname) %>%
    unique() %>%
    length()
}

butterfly_plot <- function(
  plot_data, x, y, wing_col,
  left_wing, right_wing,
  ...
) {
  if (!is.factor(plot_data[[y]])) {
    plot_data[[y]] <- factor(
      plot_data[[y]],
      levels = rev(sort(unique(plot_data[[y]])))
    )
  }
  p_ls <- mapply(
    SIMPLIFY = FALSE,
    wname = c(left_wing, right_wing),
    is_left = c(TRUE, FALSE),
    FUN = function(wname, is_left) {
      p <- plot_data %>% 
        dplyr::filter(.data[[wing_col]] == wname) %>%
        ggplot(aes_string(x = x, y = y, ...)) +
        geom_bar(stat = 'identity') +
        ggtitle(wname)
      if (is_left) {
        p <- p +
          scale_x_reverse() +
          scale_y_discrete(position = "right") +
          theme(axis.text.y.right = element_blank())
      }
      return(p)
    }
  )
  p <- wrap_plots(p_ls, nrow = 1, guides = 'collect') & 
    theme(
      axis.title.y = element_blank(),
      axis.text.y = element_text(hjust = 0.5),
      legend.position = 'right'
    )
  return(p)
}
