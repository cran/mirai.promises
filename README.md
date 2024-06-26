
<!-- README.md is generated from README.Rmd. Please edit that file -->

# mirai.promises

<!-- badges: start -->

[![CRAN
status](https://www.r-pkg.org/badges/version/mirai.promises?color=112d4e)](https://CRAN.R-project.org/package=mirai.promises)
[![mirai.promises status
badge](https://shikokuchuo.r-universe.dev/badges/mirai.promises?color=ddcacc)](https://shikokuchuo.r-universe.dev/mirai.promises)
[![R-CMD-check](https://github.com/shikokuchuo/mirai.promises/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/shikokuchuo/mirai.promises/actions/workflows/R-CMD-check.yaml)
[![Codecov](https://codecov.io/gh/shikokuchuo/mirai.promises/branch/main/graph/badge.svg)](https://app.codecov.io/gh/shikokuchuo/mirai.promises)
[![DOI](https://zenodo.org/badge/647242817.svg)](https://zenodo.org/badge/latestdoi/647242817)
<!-- badges: end -->

`mirai.promises` makes ‘mirai’ ‘promises’ for easy integration in
‘plumber’ or ‘shiny’ pipelines.

`mirai.promises` also makes
[`nanonext`](https://cran.r-project.org/package=nanonext) ‘recvAio’
‘promises’, working on asynchronous message receives.

`mirai` \>= 0.11.1 already supports ‘promises’ out of the box. In this
case, loading `mirai.promises` after `mirai` will mask the equivalent
method to provide additional functionality offered by this package such
as allowing a custom polling interval.

### Installation

Install the latest release from CRAN:

``` r
install.packages("mirai.promises")
```

Or the development version from R-universe:

``` r
install.packages("mirai.promises", repos = "https://shikokuchuo.r-universe.dev")
```

### Polling Interval

`polling()` may be used to customise the frequency with which to poll
for promise resolution (defaults to every 100 ms).

Package authors wishing to use the S3 methods contained within this
package may simply import the `polling()` function to make them
available.

### Example

The below example simulates a plot function requiring a long compute in
a ‘shiny’ app.

This app takes c. 2s to start compared to the 8s it would otherwise take
if the ‘long-running’ computations were not running on parallel workers.

``` r
library(shiny)
library(mirai)
library(promises)
library(mirai.promises)

polling(freq = 50L)

# set 4 persistent workers
daemons(n = 4L)

ui <- fluidPage(
  fluidRow(
    plotOutput("one"),
    plotOutput("two"),
  ),
  fluidRow(
    plotOutput("three"),
    plotOutput("four"),
  )
)

make_plot <- function(time) {
  Sys.sleep(time)
  runif(10)
}

args <- list(make_plot = make_plot, time = 2)

server <- function(input, output, session) {
  output$one <- renderPlot(mirai(make_plot(time), .args = args) %...>% plot())
  output$two <- renderPlot(mirai(make_plot(time), .args = args) %...>% plot())
  output$three <- renderPlot(mirai(make_plot(time), .args = args) %...>% plot())
  output$four <- renderPlot(mirai(make_plot(time), .args = args) %...>% plot())
  session$onSessionEnded(stopApp)
}

shinyApp(ui = ui, server = server)
```

### Thanks

[Joe Cheng](https://github.com/jcheng5) for optimising the promises
method to work seamlessly within Shiny.

[Daniel Falbel](https://github.com/dfalbel/) for the original version of
the above example and agreeing to its use here, as well as the specific
use case that motivated this package.

### Links

`mirai.promises` on CRAN:
<https://cran.r-project.org/package=mirai.promises>

`mirai` website: <https://shikokuchuo.net/mirai/><br /> `mirai` on CRAN:
<https://cran.r-project.org/package=mirai><br />   - High Performance
Computing CRAN Task View:
<https://cran.r-project.org/view=HighPerformanceComputing>

`nanonext` website: <https://shikokuchuo.net/nanonext/><br /> `nanonext`
on CRAN: <https://cran.r-project.org/package=nanonext>

–

### Code of Conduct

Please note that the mirai.promises project is released with a
[Contributor Code of
Conduct](https://contributor-covenant.org/version/2/1/CODE_OF_CONDUCT.html).
By contributing to this project, you agree to abide by its terms.
