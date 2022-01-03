# Background Subtraction KDE
I have applied KDE(Kernel Density Estimation) to attain Background Subtraction by fitting a KD Estimator for each pixel over time.\
It is specially useful to detect foreground motion and separate it from background in cases like Video Surveillance and Traffic Monitoring, automatically without Manual Intervention.

For Details about the Project written in a proper way with all the supporting mathematical expression, explanations, etc. refer to `Background-Separation.html`(Download and Run for better Experience. It's more of a must cause the HTML file has the video embedded if one is interested in viewing). You can take a look at `Background-Separation.md`(But Github doesn't support Latex rendering in markdown yet). The code that generated both these previously mentioned files is written neatly in `Background-Separation.Rmd`(R-Markdown File)

Functions used in the `Background-Separation.Rmd`:
- `background.separat.frame.KDE`: It takes the video footage name(should be present in the executing folder), frame to be background separated, threshold value(to decide the background to be set to lower brightness). It outputs a cimg object basically a matrix representing the background separated image.

Tip:
- Use RStudio for smoother experience.

