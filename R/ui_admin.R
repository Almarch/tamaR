
ui_admin = function() {
    tagList(
        fluidRow(
            column(9,align="center",
                plotOutput("screen")
            ),
            column(3,align = "center",
                br(),br(),br(),br(),br(),br(),br(),
                uiOutput("startstop")
            )
        ),
        br(),
        fluidRow(column(12,align = "center",
            uiOutput("admin")
        ))
    )

}