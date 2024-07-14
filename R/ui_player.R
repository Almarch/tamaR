
ui_player = function() {
    tagList(
        fluidRow(column(12,align="center",
            plotOutput("screen")
        )),
        fluidRow(column(12,align = "center",
            splitLayout(
                actionButton("A","",class="big"),
                actionButton("B","",class="big"),
                actionButton("C","",class="big")
            )
        )),
        fluidRow(column(12,align = "center",
            uiOutput("ui_care")
        ))
    )
}
