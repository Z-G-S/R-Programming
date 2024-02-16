# Load necessary libraries
library(ggplot2)
library(ggiraph)
library(tidyr)
library(dplyr)

# Ensure 'Date' is in Date format
COMBINED_DATA_33763542$Date <- as.Date(COMBINED_DATA_33763542$Date)

# Reshape the dataset from wide to long format using the correct column names
long_dataset <- pivot_longer(COMBINED_DATA_33763542, 
                             cols = c("BTC Growth", "MSTR Growth", "NASDAQ Growth"), 
                             names_to = "Metric", values_to = "Growth")

# Create a ggplot object for the long dataset with customized theme
p <- ggplot(long_dataset, aes(x = Date, y = Growth, color = Metric, group = Metric)) +
  geom_line_interactive(aes(group = Metric, data_id = Metric), size = .5) +
  geom_point_interactive(aes(data_id = Metric, tooltip = paste(Metric, "Percentage:", round(Growth, 2))), size = 3) +
  scale_color_manual(values = c("BTC Growth" = "orange", "MSTR Growth" = "red", "NASDAQ Growth" = "green")) +
  theme_minimal() +
  theme(
    panel.background = element_rect(fill = "black", colour = "black"),
    plot.background = element_rect(fill = "black", colour = "black"),
    text = element_text(color = "white"),
    axis.title = element_text(color = "white"),
    axis.text = element_text(color = "white"),
    axis.line = element_line(color = "white"),
    plot.title = element_text(color = "white"),
    legend.title = element_text(color = "white"),
    legend.text = element_text(color = "white"),
    panel.grid.major = element_blank(),  # Remove major grid lines
    panel.grid.minor = element_blank()   # Remove minor grid lines
  ) +
  labs(title = "10-Day Growth Comparison", x = "Date", y = "Growth")

# Convert to interactive ggiraph object with hover options
interactive_plot <- girafe(ggobj = p) %>%
  girafe_options(
    opts_hover(css = "opacity:1;"),  # Ensure hovered elements are fully opaque
    opts_hover_inv(css = "opacity:0.2;"),  # Non-hovered elements are more transparent
    opts_tooltip(
      css = "background-color:white; color:black; font-weight:bold; padding:5px; border:1px solid black;"
    )
  )

# Print the interactive chart
print(interactive_plot)
