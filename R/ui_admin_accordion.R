

bs_credentials = function(x,enable_care) {
    bs_append(x,
        title = "Management",
        content = fluidRow(column(12,
            splitLayout(
                textInput("name_player","Player name:"),
                actionButton("save_name_player","Save player name")
            ),
            splitLayout(
                textInput("pass_player","Player password:"),
                actionButton("save_pass_player","Save player password")
            ),
            splitLayout(
                textInput("pass_admin","Admin password:"),
                actionButton("save_pass_admin","Save admin password")
            )
        ),
        br(),
        fluidRow(column(12,align = "center",
            actionButton("enable_care",
            ifelse(enable_care,
                "Disable automatic care",
                "Enable automatic care")
            ))
        ))
    )
}

ui_admin_accordion = function(running, enable_care) {

    if(running) {
        accordion = bsplus::bs_accordion(
            id = "admin_running"
        ) |>
        bs_set_opts(
            panel_type = "info"
        ) |>
        bs_credentials(
            enable_care
        ) |>
        bs_append(
            title = "Play as admin",
            content = fluidRow(column(12,
                splitLayout(
                    actionButton("a","A",class="small"),
                    actionButton("b","B",class="small"),
                    actionButton("c","C",class="small"),
                    actionButton("ac","A+C",class="small"),
                    cellWidths = c("25%")
                ),
                align = "center"
            ))
        )
    } else {
    accordion = bsplus::bs_accordion(
            id = "admin_stopped"
        ) |>
        bs_set_opts(
            panel_type = "warning"
        ) |>
        bs_credentials(
            enable_care
        ) |>
        bs_append(
            title = "Aesthetics",
            content = fluidRow(column(12,
                splitLayout(
                    actionButton("p2","Switch to P2 sprites"),
                    fileInput("background","Change background", multiple = FALSE)
                ),
                br(),
                splitLayout(
                    downloadButton("save_rom", "Dump the ROM"),
                    fileInput("load_rom", "Load a ROM", multiple = FALSE)
                ),
                br(),
                actionButton("reset_aes","Reset all aesthetics"),
                align = "center"
            ))
        ) |>
        bs_append(
            title = "Game state",
            content = fluidRow(column(12,
                splitLayout(
                    downloadButton("save_state", "Save the game"),
                    fileInput("load_state", "Load a game", multiple = FALSE)
                ),
                br(),
                actionButton("reset_state","Reset the game"),
                align = "center"
            ))
        )
    }
}