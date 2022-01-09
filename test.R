### Example ###
set.seed(42)
N <- 1e4
d <- 5
X <- matrix(rnorm(N*d), ncol=d)
#theta <- rep(5, d+1)
theta <- c(5,2,-7,10,-1,4)
eps <- rnorm(N)
X_test <- cbind(1, X)
y <- X_test %*% theta + eps

# bgd
bgd_theta_hat1 <- bgd_lm(X, y)
bgd_theta_hat1
bgd_theta_hat2 <- bgd_lm(X, y,step_size = 0.1)
bgd_theta_hat2
bgd_theta_hat3 <- bgd_lm(X, y,backtrack = TRUE)
bgd_theta_hat3

# mbgd
mbgd_theta_hat1 <- mbgd_lm(X, y)
mbgd_theta_hat1
# default batch_size is equal to the sample size，namely bgd
mbgd_theta_hat2 <- mbgd_lm(X, y,batch_size = 20)
mbgd_theta_hat2

# Momentum_lm
Momentum_theta_hat1 <- Momentum_lm(X, y)
Momentum_theta_hat1
# added rho parameter 
Momentum_theta_hat2 <- Momentum_lm(X, y,rho = 0.6)
Momentum_theta_hat2


# compare the time and accuracy of using backtracking or not
error1 <- t(bgd_theta_hat1$beta - theta) %*% (bgd_theta_hat1$beta - theta)
error2 <- t(mbgd_theta_hat2$beta - theta) %*% (mbgd_theta_hat2$beta - theta)
error3 <- t(Momentum_theta_hat1$beta - theta) %*% (Momentum_theta_hat1$beta - theta)
error <- c(error1, error2, error3)
error
library(microbenchmark)
testResult <- microbenchmark(bgd_lm(X, y),
                             bgd_lm(X, y,backtrack = TRUE),
                             mbgd_lm(X, y,batch_size = 20),
                             Momentum_lm(X, y),
                             Momentum_lm(X, y,batch_size = 20),times = 100)
testResult
