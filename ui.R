fluidPage(
    tags$head(tags$script(src = "message-handler.js")),
    HTML("<link rel=\"icon\" type=\"image/gif\" href=\"glider.gif\" />"),
    title = 'Game of life',
    titlePanel(h1('Game of life',align = 'center')),
    sidebarLayout(
        position = "right",
        sidebarPanel(
            sliderInput("neighborhoodSize", h4("Neigbourhood:"), min = 1, max=4,value = 1),
            helpText('Defines the size of neigbourhood around a cell.'),
            sliderInput("birth", h4("Birth:"), min = 2, max=7,value = 3),
            helpText('Amount of neigbours needed to create a new cell.'),
            sliderInput("survival", h4("Survival:"), min = 1, max=5,value = 2),
            helpText('Amount of neigbours needed so that existing cell survives.'),
            sliderInput("matrixSize", h4("Size:"),min = 10, max=200,value = 100),
            helpText('Size of the game board.'),
            sliderInput("livingCellRatio", h4('Starting ratio:'), min = 0.1, max=0.9, value=0.4),
            helpText('Proportion of cells that are alive relative to the size of the board.'),
            sliderInput("maxIteration", h4('Max Iteration:'), min = 50, max=200, value=50),
            sliderInput('speed', h4('Speed:'), min =100, max=500, value=250),
            helpText('Time in miliseconds to show next state.'),
            actionButton("startStop" ,"Start", icon("play")),
            actionButton("restart" ,"Restart", icon("redo"))
        ),
        mainPanel(
            imageOutput('gameOfLifeState')
        )
    )
)