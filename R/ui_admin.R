
ui_admin = function() {
    tagList(
        fluidRow(
            column(12,align="center",
                plotOutput("screen")
            )
        ),fluidRow(
            column(12,align = "center",
                uiOutput("startstop")
            )
        ),
        br(),br(),br(),
        fluidRow(column(12,align = "center",
            uiOutput("admin")
        ))
    )

}