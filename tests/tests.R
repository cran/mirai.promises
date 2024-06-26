library(nanonext)
requireNamespace("mirai", quietly = TRUE)
library(promises)
library(mirai.promises)
nanotest <- function(x) invisible(x || stop("is not TRUE when expected to be TRUE"))

s <- socket()
r <- recv_aio(s)
nanotest(is.promise(as.promise(r)))
nanotest(is.promising(r))
close(s)
if (requireNamespace("mirai", quietly = TRUE)) {
  nanotest(is.promise(p1 <- as.promise(mirai::mirai("completed"))))
  nanotest(is.promise(p2 <- mirai::mirai("completed") %...>% identity()))
  Sys.sleep(3L)
}
nanotest(mirai.promises:::.[["pollfreq"]] == 0.1)
nanotest(is.null(polling(freq = 1000)))
nanotest(mirai.promises:::.[["pollfreq"]] == 1L)
nanotest(is.null(polling()))
nanotest(mirai.promises:::.[["pollfreq"]] == 0.1)
