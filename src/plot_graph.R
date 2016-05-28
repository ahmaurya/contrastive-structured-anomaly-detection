require(igraph)

detected_delta_csad_correct <- c(as.numeric(read.csv("../results/detected_delta_csad_correct.csv", header=FALSE)))
detected_delta_csad_incorrect <- c(as.numeric(read.csv("../results/detected_delta_csad_incorrect.csv", header=FALSE)))
detected_delta_bsad_correct <- c(as.numeric(read.csv("../results/detected_delta_bsad_correct.csv", header=FALSE)))
detected_delta_bsad_incorrect <- c(as.numeric(read.csv("../results/detected_delta_bsad_incorrect.csv", header=FALSE)))

detected_delta_csad_correct_edges <- length(detected_delta_csad_correct)/2
detected_delta_csad_incorrect_edges <- length(detected_delta_csad_incorrect)/2
detected_delta_bsad_correct_edges <- length(detected_delta_bsad_correct)/2
detected_delta_bsad_incorrect_edges <- length(detected_delta_bsad_incorrect)/2

G <- graph( c(detected_delta_bsad_incorrect, detected_delta_bsad_correct), directed = FALSE )

#set.seed(2)

# Assign attributes to the graph
#G$name    <- "CSAD - Detected Graph"

# Assign attributes to the graph's vertices
V(G)$name  <- rep("",100)
#V(G)$color <- sample(rainbow(100),100,replace=FALSE)

# Plot the graph -- details in the "Drawing graphs" section of the igraph manual
plot(G, layout = layout.auto, 
     #main = G$name,
     vertex.size = 5,
     #vertex.color= V(G)$color,
     vertex.frame.color= "white",
     vertex.label.color = "white",
     vertex.label.family = "sans",
     edge.width=1.5,
     edge.curved=FALSE,
     edge.color=c(rep("red",detected_delta_bsad_incorrect_edges), rep("green",detected_delta_bsad_correct_edges))
     )
