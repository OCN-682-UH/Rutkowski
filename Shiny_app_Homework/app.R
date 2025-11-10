library(tidyverse)
library(shiny)
library(tidytuesdayR)

# Load the tidy tuesday Flint water data 

tuesdata<- tt_load('2025-11-04')

# Extract the data 

flint_mdeq<- tuesdata$flint_mdeq # michigan dept of environmental quality
flint_vt<- tuesdata$flint_vt # virginia tech data 

# Take a look at the data 
view(flint_mdeq)
view(flint_vt)

summary(flint_mdeq)
summary(flint_vt)

# The 2 datasets show that:
# MDEQ has 71 samples - lead from 0-104 ppb 
# VT has 271 samples - lead from 0.344-158 ppb
# The EPA action level for lead in water is 15 ppb

# ===============================================================================================================
# In my shiny app I will create an interactive histogram showing lead distribution with the EPA action level marked
# and a summary table showing the statistics and % of samples exceeding the EPA limit 
# ===============================================================================================================

# User interface 

ui<- fluidPage(
  titlePanel("Flint Water Crisis: Lead Concentration Analysis (2015)"), # add a title at top of app page 
  sidebarLayout( # side bar for user controls
    sidebarPanel( # sidebar panel contains input controls 
      selectInput(inputId = "dataset", # internal ID used to access this input
                  label = "Choose Dataset", #the label shown to the user 
                  choices = c("Virginia Tech (Citizen Science)" = "vt", # the display name = internal value 
                              "Michigan DEQ (State Agency)" = "mdeq"),
                  selected = "vt"), # make vt default selected values when app loads 
      
      # Add slider to let users adjust the # of bins in histogram
      sliderInput( # creates a slider control
        inputId = "bins", # internalID to access this input
        label = "Zoom Level (Broader ← → More Detail)", # the label shown to the user (more or less histogram bars)
        min = 10, # min value
        max = 50, # max value
        value = 30), # initial default vlue of slider 
      
      # Add explanatory text
      hr(), # horizontal line separator 
      
      # Display information about EPA action level
      h4("EPA Action Level:"), # h4 creates a heading
      p(" The EPA action level for lead in drinking water is 15 ppb."), # p creates paragraph text 
      p(" Lead exposure can cause serious health problems, especially for children."),
      p("To learn more,",
        tags$a("click here", # add a hyperlink 
               href = "https://onlinelibrary.wiley.com/doi/abs/10.1111/test.12187?casa_token=av3lP7OmqS0AAAAA%3AQAF3yU5kGzsUkqi1VlXkMlIN8ExolHZBSkdJ3hIHnlptUES57dGVoXjE3qdwPPHtLHNRd9VvX1x8f6VN",
               target = "_blank"), # open link in new tab 
        ".")
      ),
    # Main Panel shows the outputs (plots and table)
    mainPanel(plotOutput( # plotOutput displays a plot
      outputId = "leadPlot", # internal id for this plot
      height = "400px"), # plot height 
      
      br(), # add some space - creates a line break
      
      # Create a table output
      h3("Summary Statistics:"), # h3 creates a heading 
      tableOutput( # displays a table
        outputId = "summaryTable" #Internal id for this table
        )
      )
              # My brain is broken trying to keep up with all these parentheses xO     
    )
)

# Server - creates outputs based on user inputs
server<-function(input, output) {
  flint_data<- reactive({ # reactive expression loads the data- creates an expression that re-runs when inputs chnage
    tuesdata %>%
      list(vt = tuesdata$flint_vt, # return both datasets as a list 
           mdeq = tuesdata$flint_mdeq)})
  # Create a reactive expression to get the selectd dataset- updates when user changes the dropdown selection
  selected_data<-reactive({
    all_data<- flint_data() # get all the data
    # Get the dataset based on user selection
    if(input$dataset == "vt"){ # dropdown menu value
      data <- all_data$vt}
    else {
      data<- all_data$mdeq %>%
        select(sample, lead = lead2) %>% # renaming columns to just lead 
        filter(!is.na(lead)) # remove NAs
    }
    return(data)
  })
  
  # Create the histogram plot
  # use same outPut ID as plotPutput ID in the UI
  # renderPlot will create a plot that updates when inputs change 
  output$leadPlot <- renderPlot({
    data<- selected_data() # get selected data 
    num_bins<- input$bins # get # of bins from slider - slider value 
    
    # Create histogram 
    ggplot(data, aes(x = lead))+ #x-axis set to lead values
      geom_histogram(bins = num_bins, # user selected bins
                     fill = "steelblue", # bar color
                     color = "white", # border color
                     alpha = 0.7)+ # transparency
      geom_vline(xintercept = 15, # add vertical line at EPA action level 
                 color = "red", # red for danger 
                 linetype = "dashed", # line style 
                 size = 1.5)+ # line thickness
      annotate("text", # text annotation
               x = 15, y = Inf, # position of text 
               label = "EPA Action Level (15 ppb)", # label for EPA
               vjust = 1.5, # vertical adjustment 
               hjust = -0.1, # horizontal adjust
               color = "red", # red for bad 
               size = 4)+ # text size 
      labs(title = "Distribution of Lead Concentrations in Flint Water Samples",
           x = "Lead Concentration (ppb)",
           y = "Number of Samples")+
      theme_minimal()+
      theme(plot.title = element_text(hjust = 0.5)) # center title 
  })
  
  # Summary Table
  # output$summaryTable refers to the tableOuout Id in the UI
  # renderTable creates a table tht will update when input changes 
  
  output$summaryTable<- renderTable({
    data<- selected_data() # get selected data 
    # calculate summary statistics and make data fframe with statistics 
    summary_df<- data.frame(Metric = c("Number of Samples", # row labels
                                       "Minimum (ppb)",
                                       "Median (ppb)",
                                       "Mean (ppb)",
                                       "Maximum (ppb)",
                                       "Samples > 15 ppb",
                                       "% Above EPA Level"),
                            Value = c(nrow(data), # calculate values 
                                      min(data$lead),
                                      median(data$lead),
                                      mean(data$lead),
                                      max(data$lead),
                                      sum(data$lead>15), # samples above epa level 
                                      paste0(100*sum(data$lead>15)/nrow(data),"%"))) # % above epa level 
    return(summary_df)
  })
}

# Run shiny app
# Combine UI and server 
shinyApp(ui = ui, server = server)