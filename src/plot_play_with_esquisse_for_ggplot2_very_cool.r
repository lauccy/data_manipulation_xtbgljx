
# esquisse包—不写代码生成ggplot图
# https://zhuanlan.zhihu.com/p/338575339

##### Install
# From CRAN
# "install.packages("esquisse")"
# remotes::install_github("dreamRs/esquisse")
#Load the package in R
library(esquisse)

pacman::p_load(esquisse) # first check whether the package is installed or not, if not, install it then load it.

##### Activate and Use it
esquisse::esquisser() #helps in launching the add-in
#or
## 通过RStudio菜单启动插件（推荐）"'ggplot2' builder"

#### 好处
####    1. 图形界面调整ggplot2图形的各个参数，同时生成可复制的代码，用于后续微调及重复制图
####    2. 因此可以用来教学让学员体会ggplot各个图层，各个细节之处如何定制
####    3. 生成的图形可以导出各种格式，尤其有用的导出位ppt格式的图形且图片各个部分均可在ppt中编辑修改