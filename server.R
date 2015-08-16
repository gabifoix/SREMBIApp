# server.R
require(XLConnect)
require(zoo)
require(googleVis)
source("helpers.R")

# Load Data (XLConnect)
wb=loadWorkbook("data/BubbleIndexSpain.xlsx")
SREMBI <- readNamedRegion(wb, name = "InputsSREMBI")

# Shiny Server function
shinyServer(
  function(input, output) {
    
    # Reactive Index
    Index <- reactive ({
      weight <- data.frame(cbind(input$slider1, input$slider3, input$slider5, input$slider7))
      equilibrium <- data.frame(cbind(input$slider2, input$slider4, input$slider6, 1))
      colnames(weight) <- c("w.Pr.House",  "w.HH.income" ,"w.cons", "w.ipc")
      colnames(equilibrium) <- c("Eq.Pr.House",  "Eq.HH.income", "Eq.cons", "Eq.ipc")
      if(sum(weight) != 100) 
        {stop("Sum weights <> 1. Please double check!")}
      Index <- calcSREMBI(SREMBI, weight, equilibrium)
    })
    
    # Reactive length
    nq <- reactive({length(Index()[,2])})
    
    # Reactive Moving Average (zoo)
    IndexMA <- reactive ({rollmean(Index()[,2],4,,align="center") })
    
    # Reactive label
    position <- reactive ({
      if(tail(Index(),1)[,2] >= 1.025)
        {position <- "above"}
      else {
        if(tail(Index(),1)[,2] <= 0.975)
        {position <- "below"}
        else {position <- "on"}
      } 
    })
    
    # Display text
    output$text1 <- renderText({
      paste("The SREMBI, corresponding to ", tail(Index(),1)[,1], "has been" , round(tail(Index(),1)[,2],4)
            , position(), "its long-term equilibrium, considered between [0.975 -1.025]")
    })
    

    # Display Chart
    output$plot <- renderGvis({
      gvisLineChart(
        data = data.frame(
                      Quarter = Index()[4:nq(),1], 
                      SREMBI = Index()[4:nq(),2], 
                      SREMBI.ma = IndexMA(),
                      Equilibrium = rep(1,nq()-3)
                      ),
        xvar = "Quarter",
        yvar = c("SREMBI","SREMBI.ma","Equilibrium"),
        options = list(height = 500, width = 800, legend = "bottom")
      )
    })
    
  }
)
