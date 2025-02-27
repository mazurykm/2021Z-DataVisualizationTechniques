library(ggplot2)

function(input, output, session){

  observeEvent(input[["max_slider"]], {
    updateSliderInput(session, "slider1", max = input[["max_slider"]])
  })
  
  output[["text_value"]] <- renderText({
    paste0("Title is ", input[["text1"]])
  })
  
  output[["long_text_box"]] <- renderUI({
    if(nchar(input[["text1"]]) < 12){
      NULL
    } else {
      textOutput("long_text")
    }
  })
  output[["long_text"]] <- renderText({
    "Text too long :("
  })
  
  df <- reactive({
    data.frame(x = input[["slider1"]][1]:input[["slider1"]][2], 
               y = 5)
  })
  
  # points_df <- reactive({
  #   nearPoints(df(),
  #              coordinfo = input[["plot1_click"]],
  #              allRows = TRUE,
  #              maxpoints = 1,
  #              threshold = 20
  #              )
  # })
  
  output[["plot1"]] <- renderPlot({
    
    plot_df <- df()
    plot_df[["selected_"]] <- FALSE
    plot_df[rv[["clicked_id"]], "selected_"] <- TRUE
    
    ggplot(plot_df, aes(x=x, y=y, color=selected_)) +
      geom_point(size = 7) +
      ggtitle(input[["text1"]])
    
  })
  
  output[["click_value"]] <- renderPrint({
    input[["plot1_click"]]
    # points_df()
  })
  
  rv <- reactiveValues(
    clicked = NULL,
    clicked_id = c()
  )
  observeEvent(input[["plot1_click"]], {
    rv[["clicked"]] <- nearPoints(df(),
                                  coordinfo = input[["plot1_click"]],
                                  allRows = TRUE,
                                  maxpoints = 1,
                                  threshold = 20
    )
    rv[["clicked_id"]] <- which(rv[["clicked"]][["selected_"]])
  })
  
  
  
  
}