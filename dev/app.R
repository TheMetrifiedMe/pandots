library(shiny)
library(bslib)
library(plotly)
library(markdown)

source("labels.R")
#read data
rw_proddata <- read.csv("ac24res_v5_production.csv")
rw_impov_grp <- read.csv("ac24res_v5_cit_tbyt.csv")
rw_hoggdata <- read.csv("ac24res_v5_cit_hstats.csv")

#turn integers to dates
add.months= function(n) seq(as.Date("2019-12-01", "%Y-%m-%d"), by = paste(n, "months"), length = 2)[2]

rw_proddata$datelabel  <- lapply(rw_proddata$citing_date, add.months)

#Calculate some additional totals
ProdabsTotal = aggregate(rw_proddata$itemcount, by=list(citingcorona=rw_proddata$citingcorona), FUN=sum)

rw_impov_grp$absTotal = merge(x = rw_impov_grp, 
                              y = aggregate(rw_impov_grp$cited_absolute, by=list(citing_date = rw_impov_grp$citing_date, 
                                                                                 citing_corona = rw_impov_grp$citing_corona, 
                                                                                 citing_type_agg = rw_impov_grp$citing_type_agg, 
                                                                                 cited_corona = rw_impov_grp$cited_corona), FUN=sum), 
                              by.x = c("citing_date","citing_corona","citing_type_agg","cited_corona"),
                              by.y = c("citing_date","citing_corona","citing_type_agg","cited_corona"),
                              all.x = TRUE,
                              sort = FALSE
                              )$x



link_gitlab <- tags$a("gitlab", href = "https://gitlab.com/aschniedermann/pandots", target = "_blank")
link_gdoc <- tags$a("googledoc", href = "https://docs.google.com/document/d/1gKOqGy08cAQfdV-0sTJy-Whdw8gEi391G0B0vWx4MKw/edit#heading=h.r67ikr567okf", target = "_blank")


#shinylive::export("C:/Users/schniedermann/Documents/Forschung/Data Projects/pandots-app/dev", "C:/Users/schniedermann/Documents/Forschung/Data Projects/pandots-app/docs")
#shinylive::export("C:/Users/trantor/Documents/git_projects/pandots-shiny/dev", "C:/Users/trantor/Documents/git_projects/pandots-shiny/docs")


# Define UI for app that draws a histogram ----
ui <- page_navbar(
  title = "PanDots",
  bg = "black",
  
  nav_panel(
    "Introduction",
    full_screen = TRUE,
    includeMarkdown("texts/0-INTRO.md")
  ),
  
  nav_panel(
    "Publication dynamics",
    card_header(""),
    full_screen = TRUE,
    sidebarLayout(
      sidebarPanel(
        checkboxGroupInput("prod_types",
                    "Genre group",
                    unique(as.character(rw_proddata$citing_type)),
                    selected = unique(as.character(rw_proddata$citing_type))
        ),
        HTML(lblProdExpl),
        width = 2
      ),
      mainPanel(
        includeMarkdown("texts/1-PUBLISHING-1-INTRO.md"), 
        plotlyOutput("plot_prod_c"),
        includeMarkdown("texts/1-PUBLISHING-2-BLOCK-A.md"), 
        plotlyOutput("plot_prod_nc"),
        includeMarkdown("texts/1-PUBLISHING-3-BLOCK-B.md"),
        width = 10
      )
    )
  ),

  nav_panel(
    "References: Overview",
    card_header(""),
    full_screen = TRUE,
    sidebarLayout(
      sidebarPanel(
        selectInput("ref_articletype",
                    "Genre of citing item:",
                    unique(as.character(rw_proddata$citing_type))
        ),
        HTML(lblRefResults),
        width = 2
      ),
      mainPanel(
        includeMarkdown("texts/2-REFERENCES-1-INTRO.md"),
        plotlyOutput("plot_refstypedavg"),
        includeMarkdown("texts/2-REFERENCES-2-BLOCK-A.md"),
        plotlyOutput("plot_refstypedport"),
        includeMarkdown("texts/2-REFERENCES-3-BLOCK-B.md"),
        width = 10
      )
    )
  ),  


  
  nav_panel(
    "Genres of pandemic evidence",
    card_header(""),
    full_screen = TRUE,
    sidebarLayout(
      sidebarPanel(
        selectInput("cxc_citingtype",
                    "Genre of citing item:",
                    unique(as.character(rw_impov_grp$citing_type_agg))
        ),
        HTML(lblRefTbTResults),
        selectInput("cxc_ratetype",
                    "Calculation of shares:",
                    c("Set-based" = "percent_setbased", 
                      "Item-based" = "percent_itembased")
                    
        ),
        width = 2
      ),
      mainPanel(
        includeMarkdown("texts/3-REFGENRES-1-INTRO.md"),
        plotlyOutput("plot_refstypebytypeC"),       
        includeMarkdown("texts/3-REFGENRES-2-BLOCK-A.md"),
        plotlyOutput("plot_refstypebytypeNC"),
        includeMarkdown("texts/3-REFGENRES-3-BLOCK-B.md"),
        width = 10
      )
    ) 
  ),

  nav_panel(
    "Citation concentration",
    card_header(""),
    full_screen = TRUE,
    sidebarLayout(
      #fillable = TRUE,
      sidebarPanel(
        selectInput("hogg_citedType",
                    "Genre group of cited item",
                    unique(as.character(rw_hoggdata$cited_type))
        ),
        HTML(lblRefHoggResults),
        HTML(lblRefMethodHHI),
        HTML(lblRefMethodGini),
        HTML(lblRefMethodOTHER),
        selectInput("hogg_method",
                    "Distribution Indicator:",
                    c("Rate of distinct items" = "rate_of_distinct",
                      "Skewness (lognormal)" = "lognormal_skewness",
                      "Skewness (Hogg)" = "hogg_skewness",
                      "Kurtosis (lognormal)" = "lognormal_kurtosis",
                      "Kurtosis (Hogg)" = "hogg_kurtosis",
                      "Pearson's Coefficient" ="pearson_coeff",
                      "absolute citations" = "total_cit_cnt"
                    )
                    
        ),
        width = 3
      ),
      mainPanel(
        includeMarkdown("texts/4-REFCONC-1-INTRO.md"),
        plotlyOutput("plot_refsHHI"),
        includeMarkdown("texts/4-REFCONC-2-BLOCK-A.md"),
        plotlyOutput("plot_refsgini"),
        includeMarkdown("texts/4-REFCONC-3-BLOCK-B.md"),
        plotlyOutput("plot_distr"),
        includeMarkdown("texts/4-REFCONC-4-BLOCK-C.md"),
        width = 9
      )
    ) 
  ),

  nav_panel(  
    "Conclusions",
    card_header(""),
    full_screen = TRUE,  
    mainPanel(
      includeMarkdown("texts/5-CONCLUSIONS.md"),
    )
  )
)




server <- function(input, output) {
  
# -------------------------------#
# ------Production of items------#
# -------------------------------# 

  
  output$plot_prod_c <- renderPlotly({
    plot_prod <- plot_ly(rw_proddata[rw_proddata$citingcorona == 'true' & rw_proddata$citing_type %in% input$prod_types,],
                         x=~citing_date) %>%
      add_trace(y=~percent, 
                color = ~citing_type,
                type = 'scatter',
                hovertext = ~itemcount,
                hovertemplate = "%{y}% (N=%{hovertext})",
                mode = 'lines') %>%
      add_trace(y= ~portion_by_corona, 
                yaxis = "y2",
                name = 'Monthly Share',
                hovertext = ~monthlytotal,
                hovertemplate = "%{y} %<br>N = %{hovertext}",
                type = "bar", 
                marker = list(color = '#F3F3F3', opacity = 0.1)) %>%
      layout(yaxis2 = list(side = "right", title=lblyaxis2Portion, showgrid=FALSE),
             showlegend=FALSE, 
             xaxis=list(title=lblxaxisPanMon
                        #, type = 'date', tickformat = "%d %B %Y"
                        ), 
             yaxis=list(title=lblyaxisPortion, overlaying = "y2"), 
             barmode = 'overlay'
             ,hovermode = "x unified"
      )
    
  })
  
  output$plot_prod_nc <- renderPlotly({
    plot_prod <- plot_ly(rw_proddata[rw_proddata$citingcorona == 'false' & rw_proddata$citing_type %in% input$prod_types,],
                         x=~citing_date) %>%
      add_trace(y=~percent, 
                color = ~citing_type,
                type = 'scatter',
                hovertext = ~itemcount,
                hovertemplate = "%{y}% (N=%{hovertext})",
                mode = 'lines') %>%
      add_trace(y= ~portion_by_corona, 
                yaxis = "y2",
                name = 'Monthly Share',
                hovertext = ~monthlytotal,
                hovertemplate = "%{y} %<br>N = %{hovertext}",
                type = "bar", 
                marker = list(color = '#F3F3F3', opacity = 0.1)) %>%
      layout(yaxis2 = list(side = "right", title=lblyaxis2Portion, showgrid=FALSE),
             showlegend=FALSE, 
             xaxis=list(title=lblxaxisPanMon
                        #, type = 'date', tickformat = "%d %B %Y"
             ), 
             yaxis=list(title=lblyaxisPortion, overlaying = "y2"), 
             barmode = 'overlay'
             ,hovermode = "x unified"
      )
    
  })
  
  
  
  # output$prod_table <- DT::renderDT(
  #     DT::datatable(
  #       rw_proddata[rw_proddata$citingcorona == input$prod_citingcorona & rw_proddata$citing_type %in% input$prod_types,c(1:10)],
  #       rownames = FALSE,
  #       colnames = c("Date","about C19","Genre","Refs.(avg)","Refs. to C19","Nr.Items by Genre","Nr.Items by Month","Monthly Share (in %)","Share by C19 (in %)","Share by all (in %)")
  #     )
  #   )

# ---------------------------------------#
# ------References General Overview------#
# ---------------------------------------#  
  
    
  output$plot_refstypedavg <- renderPlotly({
    plot_prod <- plot_ly(rw_proddata[rw_proddata$citing_type %in% input$ref_articletype,],
                         x=~citing_date) %>%
                  add_trace(y=~avg_refcount, 
                            color=~citingcorona, 
                            type = 'scatter', 
                            mode = 'lines',
                            hovertemplate = "%{y} avg refs"
                            ) %>%
                  add_trace(y= ~itemcount,
                            color=~citingcorona,
                            yaxis = "y2",
                            hovertemplate = "N = %{y}",
                            type = "bar", 
                            marker = list(opacity = 0.2)) %>%
                  layout(yaxis2 = list(side = "right", title=lblyaxis2Portion, showgrid=FALSE),
                         showlegend=FALSE, 
                         xaxis=list(title="No. Items"), 
                         yaxis=list(title="Mean No. References", overlaying = "y2"), 
                         barmode = 'group',
                         hovermode = "x unified"
                  )
    
  })
  
  output$plot_refstypedport <- renderPlotly({
    plot_prod <- plot_ly(rw_proddata[rw_proddata$citing_type %in% input$ref_articletype,],
                         x=~citing_date) %>%
                  add_trace(y=~avg_refrate_to_corona, 
                            color=~citingcorona, 
                            type = 'scatter', 
                            mode = 'lines',
                            hovertext = ~avg_refcount,
                            hovertemplate = "%{y}% of those %{hovertext} refs are about C19") %>%
                  layout(showlegend=FALSE, 
                         xaxis=list(title=lblxaxisPanMon), 
                         yaxis=list(title=lblyaxisPortion),
                         hovermode = "x unified"
                  )
    
  })

# -----------------------------------#
# ------References Type by Type------#
# -----------------------------------#
  
  output$plot_refstypebytypeC <- renderPlotly({
    plot_prod <- plot_ly(rw_impov_grp[rw_impov_grp$citing_corona == 'true' & 
                                        rw_impov_grp$citing_type_agg %in% input$cxc_citingtype & 
                                        rw_impov_grp$cited_corona == 'true',],
                         x=~citing_date) %>%
      add_trace(y=~get(input$cxc_ratetype), 
                color=~cited_type_agg, 
                type = 'scatter', 
                mode = 'lines',
                hovertemplate = "%{y}%"
                ) %>%
      add_trace(y=~absTotal,
                yaxis = "y2",
                name = 'Of N',
                hovertemplate="%{y} absolute citations",
                type = "bar", 
                marker = list(color = '#F3F3F3', opacity = 0.1)
                ) %>%
      layout(yaxis2 = list(side = "right", title="No. Citations", showgrid=FALSE),
             showlegend=FALSE, 
             xaxis=list(title=lblxaxisPanMon), 
             yaxis=list(title=lblyaxisPortion, overlaying = "y2"), 
             hovermode = "x unified",
             barmode = 'overlay'
      )
    
  })
  
  output$plot_refstypebytypeNC <- renderPlotly({
    plot_prod <- plot_ly(rw_impov_grp[rw_impov_grp$citing_corona == 'true' & 
                                        rw_impov_grp$citing_type_agg %in% input$cxc_citingtype & 
                                        rw_impov_grp$cited_corona == 'false',],
                         x=~citing_date) %>%
      add_trace(y=~get(input$cxc_ratetype), 
                color=~cited_type_agg, 
                type = 'scatter', 
                mode = 'lines',                
                hovertemplate = "%{y}%"
                ) %>%
      add_trace(y=~absTotal,
                yaxis = "y2",
                name = "Of N",
                hovertemplate="%{y} absolute citations",
                type = "bar", 
                marker = list(color = '#F3F3F3', opacity = 0.1)
                ) %>%
      layout(yaxis2 = list(side = "right", title="No. Citations", showgrid=FALSE),
             showlegend=FALSE, 
             xaxis=list(title=lblxaxisPanMon), 
             yaxis=list(title=lblyaxisPortion, overlaying = "y2"), 
             hovermode = "x unified",
             barmode = 'overlay'
      )
    
  })
  
# -----------------------------------#
# ------References Concentration-----#
# -----------------------------------#

  
  output$plot_refsHHI <- renderPlotly({
    
    plot_hhi <- plot_ly(rw_hoggdata[rw_hoggdata$citing_corona == 'true' & 
                                       rw_hoggdata$cited_type %in% input$hogg_citedType,
    ],
    x=~citing_date) %>%
      add_trace(y=~hhi, 
                color=~cited_corona, 
                type = 'scatter', 
                mode = 'lines') %>%
      layout(showlegend=FALSE, 
             #title=paste0("Concentration (HHI) of references from Covid-19 ", if(input$hogg_citingcorona == "false"){"unrelated"} else {"related"}," research to ", input$hogg_citedType, " by Covid-19 relatedness"), 
             xaxis=list(title=lblxaxisPanMon), 
             yaxis=list(title="value", hoverformat = '.2f'), 
             hovermode = "x unified"
      )
    
  })
  
  output$plot_refsgini <- renderPlotly({
    plot_gini <- plot_ly(rw_hoggdata[rw_hoggdata$citing_corona == 'true' & 
                                       rw_hoggdata$cited_type %in% input$hogg_citedType,
    ],
    x=~citing_date) %>%
      add_trace(y=~gini	, 
                color=~cited_corona, 
                type = 'scatter', 
                mode = 'lines') %>%
      layout(showlegend=FALSE, 
             #title=paste0("Inequality (Gini-Coefficient) of references from Covid-19 ", if(input$hogg_citingcorona == "false"){"unrelated"} else {"related"}," research to ", input$hogg_citedType, " by Covid-19 relatedness"),
             xaxis=list(title=lblxaxisPanMon), 
             yaxis=list(title="value", hoverformat = '.2f'), 
             hovermode = "x unified"
      )
    
  })
  
  output$plot_distr <- renderPlotly({
    plot_distr <- plot_ly(rw_hoggdata[rw_hoggdata$citing_corona == 'true' & 
                                       rw_hoggdata$cited_type %in% input$hogg_citedType,
    ],
    x=~citing_date) %>%
      add_trace(y=~get(input$hogg_method),
                color=~cited_corona, 
                type = 'scatter', 
                mode = 'lines') %>%
      layout(showlegend=FALSE, 
             title=paste0("(Indicator: ",input$hogg_method, "; Genre group: ",input$hogg_citedType, ")"),
             xaxis=list(title=lblxaxisPanMon), 
             yaxis=list(title="value"), 
             hovermode = "x unified"
      )
    
  })

  
}

shinyApp(ui = ui, server = server)

