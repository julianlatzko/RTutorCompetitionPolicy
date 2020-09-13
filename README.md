This package constitutes an interactive R problem set based on the RTutor package (https://github.com/skranz/RTutor). 

In the first part of this problem set, the user explores an estimation strategy for the causal effect of competition policy on productivity growth. The second part focuses on the design of an effective industrial policy that conforms to sound principles of competition. The problem set is based on the articles “Competition Policy and Productivity Growth – An empirical Assessment” by Buccirossi et al. (2013) and “Industrial Policy and Competition” by Aghion et al. (2015).

## 1. Installation

RTutor and this package is hosted on Github. To install everything, run the following code in your R console.
```s
install.packages("RTutor",repos = c("https://skranz-repo.github.io/drat/",getOption("repos")))

if (!require(devtools))
  install.packages("devtools")

devtools::install_github("julianlatzko/RTutorCompetitionPolicy", upgrade_dependencies=FALSE)
```

## 2. Show and work on the problem set
To start the problem set first create a working directory in which files like the data sets and your solution will be stored. Then adapt and run the following code.
```s
library(RTutorCompetitionPolicy)

# Adapt your working directory to an existing folder
setwd("C:/problemsets/RTutorCompetitionPolicy")
# Adapt your user name
run.ps(user.name="Jon Doe", package="RTutorCompetitionPolicy",
       auto.save.code=TRUE, clear.user=FALSE)
```
If everything works fine, a browser window should open, in which you can start exploring the problem set.
