
ui_player = function() {
    tagList(
        fluidRow(column(12,align="center",
            plotOutput("screen")
        )),
        fluidRow(column(12,align = "center",
            splitLayout(
                actionButton("A","",class="plastic"),
                actionButton("B","",class="plastic"),
                actionButton("C","",class="plastic"),
                cellWidths = c("25%")
            )
        )),
        fluidRow(column(12,align = "center",
            uiOutput("ui_care")
        ))
    )
}
