library(imager)

# Grayscale Plot
background.separat.frame.KDE <- function(filename, frame, th = 0.05){
  require(imager)
  
  # Loading the video
  if(typeof(filename) != "double")
    vid <- load.video(filename)
  else
    vid <- filename
  
  # Separated Image
  prob.kde <<- matrix(0, nrow = dim(vid)[1], ncol = dim(vid)[2])
  
  # Filling in the kde values for the kth frame
  N <- dim(vid)[3]
  sig.opt <- ((0.8/N)^(1/7))
  k <- frame
  for (i in 1:dim(vid)[1]) {
    for (j in 1:dim(vid)[2]) {
      r <- vid[i,j,,1]
      prob.kde[i,j] <<- (1/(N*((2*pi)^1.5)*sig.opt))*sum(exp(-((r-r[k])^2)/(2*(sig.opt^2))))
    }
  }
  
  # Setting the separation color
  prob.quantile <- quantile(prob.kde)
  sep.img <- vid[,,k,]
  for (i in 1:dim(sep.img)[1]) {
    for (j in 1:dim(sep.img)[2]) {
      if((prob.kde[i,j] >= th))
        sep.img[i,j,] <- sep.img[i,j,]/5
    }
  }
  sep.img <- as.cimg(sep.img)
  return(sep.img)
}

# Prob Plot
background.separat.frame.KDE.prob <- function(filename, frame, th = 0.05){
  require(imager)
  
  # Loading the video
  if(typeof(filename) != "double")
    vid <- load.video(filename)
  else
    vid <- filename
  
  # Separated Image
  prob.kde <<- matrix(0, nrow = dim(vid)[1], ncol = dim(vid)[2])
  
  # Filling in the kde values for the kth frame
  N <- dim(vid)[3]
  sig.opt <- ((0.8/N)^(1/7))
  k <- frame
  for (i in 1:dim(vid)[1]) {
    for (j in 1:dim(vid)[2]) {
      r <- vid[i,j,,1]
      prob.kde[i,j] <<- (1/(N*((2*pi)^1.5)*sig.opt))*sum(exp(-((r-r[k])^2)/(2*(sig.opt^2))))
    }
  }
  
  # Prob Plot
  cat("Info:\n", "Min. Prob: ", min(prob.kde),"\n", "Max. Prob: ", max(prob.kde), '\n')
  prob.kde[prob.kde >= th] = 1
  grid::grid.raster(t(1-prob.kde))
}

vid <- load.video("shortVideo.mp4")
vid1 <- grayscale(vid)
save.video(vid1, "shortVideo_gray.mp4")

background.separat.frame.KDE.prob("vid1_gray.mp4", 40, 0.099)
plot(background.separat.frame.KDE("shortVideo_gray.mp4", 100, 0.123))

# prob change at 228, 68 pixel
prob.changes.motion <- rep(0, length(seq(90, 110, by= 1)))
prob.changes.bg <- rep(0, length(seq(90, 110, by= 1)))
j <- 1
for(i in seq(90, 110, by= 1)){
  background.separat.frame.KDE.prob(vid, i, 0.123)
  prob.changes.motion[j] <- prob.kde[228, 63]
  prob.changes.bg[j] <- prob.kde[3,3]
  j <- j+1
}

prob.change.data <- tibble(time = 90:110, prob.mot = prob.changes, prob.bg = prob.changes.bg)
prob.change.data %>%
  gather(prob.bg, prob.mot, key = "Class", value = "prob") %>%
  ggplot(aes(time, prob, color = Class)) +
  geom_smooth(se = FALSE)

tibble(t = 1:148, x = vid[228, 63, , 1]) %>%
  ggplot(aes(x)) +
  stat_density(bw = ((0.8/148)^(1/7)))


vid <- load.video("traffic2.mp4")
vid1 <- grayscale(vid)
save.video(vid1, "traffic_gray.mp4")
