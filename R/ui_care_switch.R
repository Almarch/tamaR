

ui_care_switch = function() {
    tagList(
        br(),br(),br(),
        fluidRow(
            column(6,align = "center",
                fluidRow(tags$label(
                    "Automatic care:"
                )),
                fluidRow(switchInput(
                    "care",
                    onLabel = "",
                    offLabel = "",
                    value = F,
                    handleWidth = "50px"
                ))
            ),
            column(6, align = "center",
                fluidRow(tags$label(
                    "Care for discipline:",
                    id = "disc_tag"
                )),
                fluidRow(switchInput(
                    "disc",
                    onLabel = "",
                    offLabel = "",
                    value = T,
                    handleWidth = "50px"
                ))
            )
        )
    )
}