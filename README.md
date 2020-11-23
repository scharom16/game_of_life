# Conway's Game of Life

This is a project for the introductory course in R at the University of Leipzig.

## Run the game

### Locally for Linux
Clone repo and change into repo dir.

#### Install dependencies
Execute as root bc there are no compiled upstream binaries for Linux.
```
# R -e "install.packages(c('shiny', 'png', 'plyr', 'doMC'), repos='https://cran.rstudio.com/')"
```
#### Set default browser
```
$ R
> options(browser=system('which [BROWER OF YOUR CHOICE]',intern=TRUE))
```
#### Run App
```
> library(shiny)
> runApp()
```

### Hosted

You can find a hosted version [here](https://scharom.shinyapps.io/game_of_life/).
Due to the serverside rendering and thus network delay the refresh interval of the game board is a little bit on the weak side. For full fun, run the app locally 
