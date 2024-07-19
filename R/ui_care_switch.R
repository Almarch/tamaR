

ui_care_switch = function() {
    tagList(
        br(),br(),br(),
        fluidRow(
            column(12,align = "center",
                prettyToggle(
                    inputId = "care",
                    label_off = "Automatic care",
                    label_on = "Automatic care",
                    value = F,
                    plain = T,
                    outline = T,
                    bigger = T,
                    status_on  = "danger",
                    status_off = "danger",
                    icon_on  = icon("heart", class = "fas"), 
                    icon_off = icon("heart", class = "far")
                ),
                prettyToggle(
                    inputId = "disc",
                    label_off = "Care for discipline",
                    label_on = "Care for discipline",
                    value = T,
                    plain = T,
                    outline = T,
                    bigger = T,
                    status_on  = "danger",
                    status_off = "danger",
                    icon_on  = icon("heart", class = "fas"), 
                    icon_off = icon("heart", class = "far")
                )
            )
        )
    )
}