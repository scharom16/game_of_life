fluidPage(
    HTML("<link rel=\"icon\" type=\"image/gif\" href=\"glider.gif\" />"),
    title = 'Game of life',
    titlePanel('Game of life'),
    sidebarLayout(
        position = "right",
        sidebarPanel(
            textInput("text", h4("Rulestring(B/S):"), value = '3/2'),
            numericInput("width", h4("Width:"),value = 100),
            numericInput("height", h4("Height:"), value = 100),
            sliderInput("living_cell_ratio", h4('Initial (living) cell ratio:'), min = 0, max=1, value=0.8)
        ),
        mainPanel(
            imageOutput('game_of_life_state', width=1000, height=1000)
        )
    )
)