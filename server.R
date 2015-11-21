require(shiny)
require(pls)
#load the mtcars dataset
data(mtcars)
mtcars<-mtcars
#load caret package and partition the data
require(caret)
inTrain<-createDataPartition(y=mtcars$mpg,p=0.7,list=FALSE)
train<-mtcars[inTrain,]
test<-mtcars[-inTrain,]

#set the tune control to do repeated cross validation 5 times
ctrl<-trainControl(method="repeatedcv",
                   repeats=5)
#build a Partial Least Squares model and test it out
pls<-train(mpg~.,
           data=train,
           method="pls",
           tuneLength=15,
           tuneControl=ctrl,
           preProc=c("center","scale"))
plspred<-predict(pls,newdata=test)
#confirm that the resulting predictions are statistically similar to the test set
result<-data.frame(cbind(plspred,test$mpg))
names(result)<-c("pred","test")
cor.test(result$pred,result$test)

#build a dummy dataframe with the mean values for every variable, 
#then we can change each variable one at a time to get new mpg predictions
pick<-as.data.frame.list(colMeans(mtcars))

# Define server logic required to plot various variables against mpg
shinyServer(function(input, output) {
   
    # set up reactive function for printing transaction type as a caption
    formulaText1 <- reactive({
        paste("Transmission Type: ", input$TransType)
    })
    output$trans <- renderText({
        formulaText1()
    })
    
    #do the same for #cylinders
    formulaText2 <- reactive({
        paste("Number of Cylinders: ", input$Cyl)
    })
    output$cyl <- renderText({
        formulaText2()
    })    
    
    # Reactive expression to display slider result as a caption
    sliderValues <- reactive({
        paste("Horsepower: ",input$integer)
    })
    output$hp <- renderText({
        sliderValues()
    })
    
    
    
    ##build a reactive function to populate "pick" values and run the prediction function
    pred<-reactive({
        pick[2]<-as.numeric(input$Cyl)
        pick[4]<-input$integer
        pick[9]<-as.numeric(input$TransType)
        mpg<-predict(pls,pick)
        paste("Projected MPG: ",mpg)
    })
    
    output$mpg<-renderText({
        pred()
    })
})
