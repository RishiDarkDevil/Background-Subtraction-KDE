library(imager)

# Loading the video
vid <- load.video('vid1.mp4')

# Seeing the data
dim(vid)
dim(vid[,,,1])
vid[,,,1]

# Separated Image
prob.kde <- matrix(0, nrow = dim(vid)[1], ncol = dim(vid)[2])

# Filling in the kde values for the kth frame
N <- dim(vid)[3]
sig.opt <- ((0.8/N)^(3/7))
k <- 30 # 30th Frame 
for (i in 1:dim(vid)[1]) {
  for (j in 1:dim(vid)[2]) {
    r <- vid[i,j,,1]
    g <- vid[i,j,,2]
    b <- vid[i,j,,3]
    prob.kde[i,j] <- (1/(N*((2*pi)^1.5)*sig.opt))*sum(exp(-((r-r[k])^2 + (g-g[k])^2 + (b-b[k])^2)/(2*(sig.opt^2))))
  }
}

# Setting the separation color
th <- (1/((sqrt(2*pi)*sig.opt)^3))*exp(-((N/4)^2)*1.5) # Threshold
prob.quantile <- quantile(prob.kde)
sep.img <- vid[,,k,]
for (i in 1:dim(sep.img)[1]) {
  for (j in 1:dim(sep.img)[2]) {
    if((prob.kde[i,j] >= prob.quantile[2]-0.1))
      sep.img[i,j,] <- sep.img[i,j,]/5
  }
}
sep.img <- as.cimg(sep.img)
plot(sep.img)
grid::grid.raster(t(prob.kde))
