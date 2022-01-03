# Color Plot
background.separat.frame.KDE <- function(filename, frame){
  require(imager)
  
  # Loading the video
  vid <- load.video(filename)
  
  # Separated Image
  prob.kde <- matrix(0, nrow = dim(vid)[1], ncol = dim(vid)[2])
  
  # Filling in the kde values for the kth frame
  N <- dim(vid)[3]
  sig.opt <- ((0.8/N)^(3/7))
  k <- frame
  for (i in 1:dim(vid)[1]) {
    for (j in 1:dim(vid)[2]) {
      r <- vid[i,j,,1]
      g <- vid[i,j,,2]
      b <- vid[i,j,,3]
      prob.kde[i,j] <- (1/(N*((2*pi)^1.5)*sig.opt))*sum(exp(-((r-r[k])^2 + (g-g[k])^2 + (b-b[k])^2)/(2*(sig.opt^2))))
    }
  }
  
  # Setting the separation color
  prob.quantile <- quantile(prob.kde)
  sep.img <- vid[,,k,]
  for (i in 1:dim(sep.img)[1]) {
    for (j in 1:dim(sep.img)[2]) {
      if((prob.kde[i,j] >= prob.quantile[2]))
        sep.img[i,j,] <- sep.img[i,j,]/5
    }
  }
  sep.img <- as.cimg(sep.img)
  plot(sep.img)
}

# Prob Plot
background.separat.frame.KDE.prob <- function(filename, frame, th = 0.05){
  require(imager)
  
  # Loading the video
  vid <<- load.video(filename)
  vid <<- vid[,,1:frame,]
  
  # Separated Image
  prob.kde <<- matrix(0, nrow = dim(vid)[1], ncol = dim(vid)[2])
  
  # Filling in the kde values for the kth frame
  N <- dim(vid)[3]
  sig.opt <- ((0.8/N)^(3/7))
  k <- frame
  for (i in 1:dim(vid)[1]) {
    for (j in 1:dim(vid)[2]) {
      r <- vid[i,j,,1]
      g <- vid[i,j,,2]
      b <- vid[i,j,,3]
      prob.kde[i,j] <<- (1/(N*((2*pi)^1.5)*sig.opt))*sum(exp(-((r-r[k])^2 + (g-g[k])^2 + (b-b[k])^2)/(2*(sig.opt^2))))
    }
  }
  
  # Prob Plot
  cat("Info:\n", "Min. Prob: ", min(prob.kde),"\n", "Max. Prob: ", max(prob.kde), '\n')
  prob.kde[prob.kde >= th] = 1
  grid::grid.raster(t(1-prob.kde))
}


# Prob Plot - Faster Pass
background.separat.frame.KDE.prob <- function(filename, frame, th = 0.05){
  require(imager)
  
  # Loading the video
  vid <<- load.video(filename)
  vid <<- vid[,,1:frame,]
  
  # Separated Image
  prob.kde <<- matrix(0, nrow = dim(vid)[1], ncol = dim(vid)[2])
  
  # Filling in the kde values for the kth frame
  N <- dim(vid)[3]
  sig.opt <- ((0.8/N)^(3/7))
  k <- frame
  for (i in 1:dim(vid)[1]) {
    for (j in 1:dim(vid)[2]) {
      r <- vid[i,j,,1]
      g <- vid[i,j,,2]
      b <- vid[i,j,,3]
      prob.kde[i,j] <<- (1/(N*((2*pi)^1.5)*sig.opt))*sum(exp(-((r-r[k])^2 + (g-g[k])^2 + (b-b[k])^2)/(2*(sig.opt^2))))
    }
  }
  
  # Prob Plot
  cat("Info:\n", "Min. Prob: ", min(prob.kde),"\n", "Max. Prob: ", max(prob.kde), '\n')
  prob.kde[prob.kde >= th] = 1
  grid::grid.raster(t(1-prob.kde))
}


# Usage:
background.separat.frame.KDE("vid1.mp4", 40)
for (i in seq(1, 47, by= 4)) {
  background.separat.frame.KDE("vid1.mp4", i)
}

background.separat.frame.KDE("shortVideo.mp4", 100)
background.separat.frame.KDE.prob("shortVideo.mp4", 100, 0.1)

background.separat.frame.KDE.prob("traffic2.mp4", 20, 0.05)

dim(grayscale(vid))
