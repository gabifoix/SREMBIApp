# ui.R


shinyUI(fluidPage(
  titlePanel("Spanish Real Estate Market Bubble Index (SREMBI) Shiny App"),
  
  sidebarLayout(
    sidebarPanel(
      helpText("Please, select weight and equilibrium value."),
 
      fluidRow(column(6,  h4("Weight %", align = "center"))
               ,column(6,  h4("Equilibrium", align = "center")))
      
      
      , fluidRow(column(12,  h5("1. House Prices relative Annual Income", align = "center")))
        , fluidRow(
          column(6,  sliderInput("slider1", "", min = 0, max = 100, value = 35, step = 5)),
          column(6,  sliderInput("slider2", "", min = 1, max = 12, value = 5)))
 
      , fluidRow(column(12,  h5("2. House Prices relative Annual Rent", align = "center")))      
        , fluidRow(
          column(6, sliderInput("slider3", "",min = 0, max = 100, value = 35, step = 5)),
          column(6, sliderInput("slider4", "", min = 6, max = 40, value = 20)))

      , fluidRow(column(12,   h5("3. Construction relative GDP %", align = "center")))
       , fluidRow(    
          column(6, sliderInput("slider5", "" ,min = 0, max = 100, value = 15, step = 5)),
          column(6, sliderInput("slider6", "",min = 1, max = 16, value = 8)))

      , fluidRow(column(12,  h5("4. Change House prices relative Consumer prices", align = "center")))     
        , fluidRow ( 
          column(6, sliderInput("slider7", "",min = 0, max = 100, value = 15 , step = 5)),
          column(6, div("Equilibrium = 1, Change Houses Prices always equals Change Consumer Prices",align = "center", style = "color:blue")))      
      ),

    
    mainPanel(
      textOutput("text1"),
      htmlOutput("plot")
    )
    
    
  )
))

