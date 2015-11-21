require(shiny)
#Define UI for MPG application
shinyUI(pageWithSidebar(
    
    #application title
    headerPanel("Picking out a Car"),
    
    #Sidebar with input widgets to select Trans type, #cylinders and HP
sidebarPanel(
    h5("Make a selection for each of the following vehicle attributes. Projected MPG will begin to populate once
Transmission Type and Engine Size are selected.  Play around with different selections to see how the estimated MPG changes."),
        radioButtons("TransType", 
                           label = h4("Select a Transmission Type"),
                           c("None Selected"= NA, "Automatic" = 0,"Manual" = 1)
    ),
        radioButtons("Cyl",
                           label = h4("Select an engine size"),
                           c("None Selected"=NA,"
                             4 Cyl" = 4,
                                          "6 Cyl" = 6,
                                          "8 Cyl" = 8)
    ),
    sliderInput("integer", "Select desired Horsepower:", 
                min=0, max=500, value=NA)

    ),
mainPanel(
    h4("Your Selections:"),
    textOutput("trans"),
    textOutput("cyl"),
    textOutput("hp"),
    
    
    h3(textOutput("mpg"))
    )
))
