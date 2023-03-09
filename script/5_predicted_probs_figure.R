#---- 

# Libraries

library(tidyverse)
library(readxl)
library(gridExtra)

#----

# Specifying file path
path <- "insert/path/to/data/"

# Reading in data
probs <- read_excel(paste0(path, "predicted_probs.xlsx"), sheet = "probabilties")

#----

# Self-reported oral health

sroh <- ggplot(data = probs, aes(x = reorder(stratum, sroh), y = sroh)) +
  geom_point(color = "red") + theme_bw() +
  theme(plot.title = element_text(hjust = 0.5, size = 10),
        axis.title.y = element_text(size = 8),
        axis.text.x = element_text(angle = 90, vjust = 0.5, hjust = 1, size = 6)) +
  geom_errorbar(aes(x = reorder(stratum, sroh), ymin = sroh_lo, ymax = sroh_hi),
                color = "black", width = 0.3, linewidth = 0.25) +
  ylim(0, 1) +
  labs(title = "Poor self-reported oral health", x = "", y = "Predicted probability (95% CI)")

# Edentulism

dent <- ggplot(data = probs, aes(x = reorder(stratum, edent), y = edent)) +
  geom_point(color = "red") + theme_bw() +
  theme(plot.title = element_text(hjust = 0.5, size = 10),
        axis.title.y = element_text(size = 8),
        axis.text.x = element_text(angle = 90, vjust = 0.5, hjust = 1, size = 6)) +
  geom_errorbar(aes(x = reorder(stratum, edent), ymin = edent_lo, ymax = edent_hi),
                color = "black", width = 0.3, linewidth = 0.25) +
  ylim(0, 1) +
  labs(title = "Edentulism", x = "", y = "Predicted probability (95% CI)")

# Untreated caries

caries <- ggplot(data = probs, aes(x = reorder(stratum, caries), y = caries)) +
  geom_point(color = "red") + theme_bw() +
  theme(plot.title = element_text(hjust = 0.5, size = 10),
        axis.title.y = element_text(size = 8),
        axis.text.x = element_text(angle = 90, vjust = 0.5, hjust = 1, size = 6)) +
  geom_errorbar(aes(x = reorder(stratum, caries), ymin = caries_lo, ymax = caries_hi),
                color = "black", width = 0.3, linewidth = 0.25) +
  ylim(0, 1) +
  labs(title = "Untreated caries", x = "", y = "Predicted probability (95% CI)")

# Periodontitis

perio <- ggplot(data = probs, aes(x = reorder(stratum, perio), y = perio)) +
  geom_point(color = "red") + theme_bw() +
  theme(plot.title = element_text(hjust = 0.5, size = 10),
        axis.title.y = element_text(size = 8),
        axis.text.x = element_text(angle = 90, vjust = 0.5, hjust = 1, size = 6)) +
  geom_errorbar(aes(x = reorder(stratum, perio), ymin = perio_lo, ymax = perio_hi),
                color = "black", width = 0.3, linewidth = 0.25) +
  ylim(0, 1) +
  labs(title = "Periodontitis", x = "", y = "Predicted probability (95% CI)")

#----

# Combining figures

tiff(paste0(path, "probs_figure.tiff"), units = "cm", 
     width = 25, height = 20, res = 600, compression = 'lzw')

grid.arrange(sroh, dent, caries, perio, ncol = 2)

dev.off()
