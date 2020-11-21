library(png)
create_world <- function(height, width, living_cell_ratio) {
    world = matrix(0, nrow = height, ncol = width)
    world = apply(world, c(1,2), function(x) sample(c(0,1),1,TRUE, c(living_cell_ratio, 1-living_cell_ratio)))
    world
}

function(input, output, session) {
    output$game_of_life_state <- renderImage({
        height = input$height
        width  = input$width
        living_cell_ratio = input$living_cell_ratio
        outfile = tempfile(fileext = ".png")
        pic = create_world(height, height, living_cell_ratio)
        writePNG(pic, target = outfile)

        list(src = outfile,
         contentType = "image/png",
         width = width,
         height = height,
         alt = "Game of life current state")
    }, deleteFile=TRUE)
}