
# Plot text along an arbitrary path
pacman::p_load(ggplot2,geomtextpath)


t <- seq(-1, 5, length.out = 1000) * pi
spiral <- data.frame(
  x = rev(sin(t) * 1000:1),
  y = rev(cos(t) * 1000:1),
  s = seq(1, 10, length.out = 100),
  text = paste(
    "Like a circle in a spiral, like a wheel within a wheel,",
    "never ending or beginning on an ever spinning reel"
  )
)

ggplot(spiral, aes(x, y, label = text)) +
  geom_textpath(size = 7, vjust = 2, linewidth = 0) +
  coord_equal(xlim = c(-1500, 1500), ylim = c(-1500, 1500))

# Use geom_textline as a drop-in for geom_line

df <- data.frame(x = rep(1:100, 3),
                 y = sin(c(seq(0, pi, len = 100),
                           seq(pi, 2*pi, len = 100),
                           rep(0, 100))),
                 label = rep(c("y is increasing",
                               "y is falling",
                               "y is flat"), each = 100))

ggplot(df, aes(x, y, label = label, color = label)) +
  geom_textline(size = 6) + theme(legend.position = "none")

# Rich text labels can contain a subset of HTML tags
label <- paste0(
  "Indometacin (",
  "C<sub>19</sub>H<sub>16</sub>",
  "<span style='color:limegreen'>Cl</span>",
  "<span style='color:blue'>N</span>",
  "<span style='color:red'>O</span><sub>4</sub>",
  ") concentration"
)

# These are interpreted when `rich = TRUE`
ggplot(Indometh, aes(time, conc)) +
  geom_point() +
  geom_labelpath(
    label = label,
    stat = "smooth", formula = y ~ x, method = "loess",
    vjust = -3, size = 8, rich = TRUE
  ) +
  scale_x_log10()


#### https://rdrr.io/github/AllanCameron/geomtextpath/man/geom_textsegment.html
# The convenience here is that the position and angle
# are in sync automatically with the data
sleep2 <- reshape(sleep, direction = "wide",
                  idvar = "ID", timevar = "group")

ggplot(sleep2, aes(x = "Drug 1", y = extra.1)) +
  geom_textsegment(
    aes(xend = "Drug 2", yend = extra.2,
        label = paste0("Patient #", ID))
  )

# As an annotation
ggplot(mapping = aes(x, y)) +
  geom_col(
    data = data.frame(x = c(1, 2), y = c(1, 10))
  ) +
  annotate(
    "textsegment",
    x = 1, xend = 2, y = 1, yend = 10,
    label = "10x increase", arrow = arrow()
  )


# https://search.r-project.org/CRAN/refmans/geomtextpath/html/coord_curvedpolar.html
# Examples

# A pie chart = stacked bar chart + polar coordinates
pie <- ggplot(mtcars, aes(x = factor(1), fill = factor(cyl))) +
  geom_bar(width = 1)
pie + coord_curvedpolar(theta = "y")

# Demonstrating curved category labels
p <- ggplot(data.frame(x = paste("Category label", 1:5), y = runif(5)),
            aes(x, y, fill = x)) +
  geom_col() +
  theme_bw() +
  theme(panel.border = element_blank(),
        legend.position = "none",
        axis.text.x = element_text(size = 10, vjust = 0.5))

# Standard bar chart in Cartesian Co-ordinates
p

# Standard coord_polar axis labels
p + coord_polar()

# Curved polar co-ordinate labels
p + coord_curvedpolar()
