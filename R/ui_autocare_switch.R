

ui_autocare_switch = function() {
    tagList(
        br(),br(),br(),
        fluidRow(
            column(3),
            column(3,align = "left",
                fluidRow(tags$label("Automatic care:")),
                br(),
                fluidRow(tags$label("Care for discipline:", id = "disc_tag"))
            ),
            column(3, align = "left",
                fluidRow(switchInput("care", onLabel = "", offLabel = "", value = F, handleWidth = "50px")),
                fluidRow(switchInput("disc", onLabel = "", offLabel = "", value = T, handleWidth = "50px"))
            ),
            column(3)
        )
    )
}