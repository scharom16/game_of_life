library(png)
library(plyr)
library(doMC)

registerDoMC(8)

state = NULL

create_world <- function(height, width, living_cell_ratio) {
    world = matrix(0, nrow = height, ncol = width)
    apply(world, c(1,2), function(x) sample(c(0,1),1,TRUE, c(1-living_cell_ratio, living_cell_ratio)))
}

calc_index <-function(base, value,  neighborhood_size=0, index_shift=1) {
    (((base + value - neighborhood_size - index_shift) %% base) + index_shift)
}

create_lower_bounds <- function(x, y, nrows, ncols, neighborhood_size=1, index_shift=1) {
    c(calc_index(nrows,x,1), calc_index(ncols,y,1))
}

count_living_cells <- function(world, x, y, neighborhood_size) {
    ncols = ncol(world)
    nrows = nrow(world)
    lower_bounds = create_lower_bounds(x, y, nrows, ncols)
    sum = 0
    interval_lenght = neighborhood_size * 2
    for(x_hat in lower_bounds[1]:(lower_bounds[1]+interval_lenght)) {
        x_hat = calc_index(nrows, x_hat)
        for(y_hat in lower_bounds[2]:(lower_bounds[2]+interval_lenght)) {
            y_hat = calc_index(ncols, y_hat)
            if (x_hat == x & y_hat == y) {
                next
            }
            sum = sum + world[x_hat,y_hat]
        }   
    }
    sum
}

getValue <- function(world, x, y, neighborhoodSize, birth, survival) {
        value = 0
        neighbor_count = count_living_cells(world, x, y, neighborhoodSize)
        # is cell alive?
        alive = world[x,y] == 1
        # print(sprintf('alive: %s', alive))
        if (alive) {
            # is neigbourhood over or under populated
            if ((neighbor_count < survival) || (birth < neighbor_count)) {
                value = 0
            } else {
                value = 1
            }
        # cell is dead and is reproduction possible
        } else if (!alive && (neighbor_count == birth)) {
            value = 1
        }
        value
}

tick <- function(world, neighborhoodSize, birth, survival) {
    newWorld = laply(1:nrow(world), function(i) {
        t <- laply(1:ncol(world), function(j) {
            getValue(world, i, j, neighborhoodSize, birth, survival)
        })
        matrix(c(rep(0,nrow(world)-length(t)), t))
    }, .parallel = TRUE)
    newWorld
}

init_game_of_life <- function(input) {
    list(iter=0, world=create_world(input$matrixSize, input$matrixSize, input$livingCellRatio))
}

generate_out_file <- function(session) {
    uiwidth  <- session$clientData$output_gameOfLifeState_width
    pixelratio <- session$clientData$pixelratio
    outfile = tempfile(fileext = ".png")
    png(outfile, width=uiwidth, height=uiwidth)
    if(!is.null(state)) {
        title = sprintf('Iteration: %s, Alive: %s', state$iter, sum(state$world))
        image(state$world, col=gray.colors(2, rev = TRUE), xaxt='n', yaxt='n', main=title)
    } else {
        plot.new()
        text(.5,.9, '@jwuerf Fun FUn FUN @jwuerf', cex=2, col=rgb(.2,.2,.2,.7))
    }
    dev.off()
    outfile
}



function(input, output, session) {
    rv <- reactiveValues(is_running = FALSE, restart=FALSE, state=NULL)

    observeEvent(input$startStop, {
        rv$is_running = !rv$is_running
        if(rv$is_running) {
            updateActionButton(session, 'startStop', label = "Stop", icon('stop'))
        } else {
            updateActionButton(session, 'startStop', label = "Start", icon('play'))
        }
    })

    observeEvent(input$restart, {
        rv$restart = TRUE
        if(rv$is_running) {
            rv$is_running = !rv$is_running
            updateActionButton(session, 'startStop', label = "Start", icon('play'))
        }
    })



    output$gameOfLifeState <- renderImage({

        maxIter=input$maxIteration
        speed=input$speed
        birth=input$birth
        survival=input$survival
        neighborhoodSize=input$neighborhoodSize
        if(is.null(state) || rv$restart) {
            state <<- init_game_of_life(input)
            rv$restart = FALSE
        }
        if(rv$is_running && !is.null(state) && (state$iter < maxIter)) {
            state <<- list(iter=state$iter+1, world=tick(state$world, neighborhoodSize, birth, survival))
            invalidateLater(speed, session)
        }
        list(src = generate_out_file(session), 
         contentType = "image/png",
         width = session$clientData$output_gameOfLifeState_width,
         height = session$clientData$output_gameOfLifeState_width,
         alt = "Game of life current state")
    }, deleteFile=TRUE)
}