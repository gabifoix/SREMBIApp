
calcSREMBI <- function(SREMBI,weigths,equilibriums) {

  nquart <- nrow(SREMBI)
  SREMBI$IPC <- SREMBI$IPC / 100
  weigths <- weigths/100
  equilibriums$Eq.cons <- equilibriums$Eq.cons / 100
  
  # House Prices
  Avg.M2.House <- 95 # Average size 
  Avg.Pr.House <- Avg.M2.House * SREMBI$Price
  Ch.Pr.House <- matrix(0,ncol=1, nrow=nquart)
  Ch.Pr.House[4:nquart] <-  sapply(seq(4,nquart),function(x){(SREMBI$Price[x] - SREMBI$Price[x-3])/ SREMBI$Price[x-3]})
  Ch.Pr.House[1:3] <- SREMBI$IPC[1:3]
  
  # Household income / Annual Rent
  Pr.HH.Income <-  Avg.Pr.House / SREMBI$Household.Income
  Var.Equilibrium.Pr.HH.Income <- Pr.HH.Income / equilibriums$Eq.Pr.House
  Alloc.Var.Equilibrium.Pr.HH.Income <- Var.Equilibrium.Pr.HH.Income * weigths$w.Pr.House
  Annual.Rent <- 12*  SREMBI$Monthly.Rent
  Pr.Annual.Rent <- Avg.Pr.House / Annual.Rent
  Var.Equilibrium.Pr.Annual.Rent <- Pr.Annual.Rent / equilibriums$Eq.HH.income
  Alloc.Var.Equilibrium.Pr.Annual.Rent <- Var.Equilibrium.Pr.Annual.Rent * weigths$w.HH.income

  # Construction over GDP
  Const.GDP <- SREMBI$Construction / SREMBI$GDP
  Var.Equilibrium.Const.GDP <- Const.GDP / equilibriums$Eq.cons
  Alloc.Var.Equilibrium.Const.GDP <- Var.Equilibrium.Const.GDP *weigths$w.cons

  # General price index
  Ch.Prices <- Ch.Pr.House - SREMBI$IPC
  Var.Equilibrium.Ch.Prices <- (Ch.Prices / equilibriums$Eq.ipc) + 1
  Alloc.Var.Equilibrium.Ch.Prices <- Var.Equilibrium.Ch.Prices * weigths$w.ipc
  
  # Index
  Index <- Alloc.Var.Equilibrium.Pr.HH.Income + 
    Alloc.Var.Equilibrium.Pr.Annual.Rent +
    Alloc.Var.Equilibrium.Const.GDP +
    Alloc.Var.Equilibrium.Ch.Prices

  Index.df <- data.frame(Quarter = SREMBI$Date, Index = Index, stringsAsFactors = FALSE)
  
  return(Index.df)

}

