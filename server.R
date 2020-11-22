library(png)
create_world <- function(height, width, living_cell_ratio) {
    world = matrix(0, nrow = height, ncol = width)
    world = apply(world, c(1,2), function(x) sample(c(0,1),1,TRUE, c(living_cell_ratio, 1-living_cell_ratio)))
    world
}

function(input, output, session) {
    output$gameOfLifeState <- renderImage({
        height = input$height
        width  = input$width
        uiwidth  <- session$clientData$output_gameOfLifeState_width
        pixelratio <- session$clientData$pixelratio
        livingCellRatio = input$livingCellRatio
        outfile = tempfile(fileext = ".png")
        pic = create_world(height, height, livingCellRatio)

        png(outfile, width=uiwidth, height=uiwidth)
        image(pic, col=gray.colors(2), xaxt='n', yaxt='n')
        dev.off()
        # writePNG(pic, target = outfile, dpi=100000000000)
        list(src = outfile,
         contentType = "image/png",
         width = uiwidth,
         height = uiwidth,
         alt = "Game of life current state")
    }, deleteFile=TRUE)
}