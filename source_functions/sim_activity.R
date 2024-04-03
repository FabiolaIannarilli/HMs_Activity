#' Simulate activity patterns (cos+cos)
#'
#' Simulate realized activity patterns based on a 'true' activity pattern distribution density.
#'
#' @param M Numeric. Number of sampling units (e.g. sites).
#' @param J Numeric. Number of cycles (e.g. days).
#' @param wavelength Numeric. Length of a period (i.e. distance between identical points in a trigonometric function)
#' @param b0 Numeric. Intercept.
#' @param b0_constant Logic. If TRUE (default), b0 is held constant; otherwise time-varying.
#' @param tau_constant Logic. If TRUE (default), random intercept is equal to 0 and there is no variability among sampling units
#' @param sdtau Numeric. Only if \code{tau_constant} = FALSE. Random intercept describing variability among sampling units coded as a Normal distribution N(0,sdtau).
#' @param b1 Numeric. Wave amplitude of first cosinusoidal curve.
#' @param b2 Numeric. Wave amplitude of second cosinusoidal curve.
#' @param theta0 Numeric. Curve-specific phaseshift for the first cosinusoidal curve.
#' @param theta1 Numeric. Curve-specific phaseshift for the second cosinusoidal curve.
#' @param n_peak Numeric. Number of peak in activity during a day (e.g. unimodal = 1, bimodal = 2). Must be a positive integer.
#' @param phaseshift_constant. Should all the sites have a peak at the same time? (Default = TRUE).
#' @param sd_phaseshift Numeric. Temporal variability among sites  (i.e. standard deviation of the phaseshift in the sinusoidal curve that determines an horizonthal shift).
#' @param n_sim Numeric. Number of datasets of realized detections to create.
#' @param plot_true_act Logic. If TRUE (default), a plot of the average probability of activity by occasion is returned.
#'
#' @examples
#' sim <- sim_activity(M=10, J=5, n_sim = 5)
#' sim$true_activity
#' sim$sim_data

#' @export
sim_activity <- function(M = 100, J = 30, wavelength = 48, b0 = -8, b0_constant = TRUE, tau_constant = TRUE, sdtau = 0.05, b1 = 1, b2 = 0.7, theta0 = 1, theta1 = 1, n_peak = 1, phaseshift_constant = TRUE, sd_phaseshift = 1, n_sim = 5, method = "trigonometric", n_y1=100, pmix = c(0.5, 0.5), mu_constant = TRUE, sdmu = 0.3, plot_true_act = TRUE){
  
  J = J*wavelength
  
  # Create covariate time
  time <- matrix(data = seq(1,J,1), nrow = M, ncol = J, byrow = TRUE)
  
  # Set constant or time-varying
  b0 <- ifelse(b0_constant == TRUE, rep(b0, J), 2-bo*time[1,])
  
  # Site-level variability: random intercept
  taus <- if(tau_constant == TRUE){
    0
  }else{
    rnorm(M, 0, sd=sdtau)
  }
  
  # Site-level variability: random phaseshift
  phaseshift <- if(phaseshift_constant == TRUE){
    0
  }else{
    rnorm(M, 0, sd=sd_phaseshift)
  }
  
  # Parameters daily sinusoidal curve:
  bp <- 24/n_peak
  b2 <- ifelse(n_peak == 1, 0, b2) # b2=0 when unimodal
  gamma <- b1*cos(2*pi*time/(24) + theta0 + phaseshift) +
    b2*cos(2*pi*time/(bp) + theta1 + phaseshift)
  
  
  # Data simulation
  p <- boot::inv.logit(matrix(b0, nrow=M, ncol=J, byrow=TRUE) + # intercept
                         matrix(taus, nrow=M, ncol=J, byrow=FALSE) + # random intercept
                         gamma)  # sinusoidal wave
  
  
  list_res <- vector("list", length = n_sim)
  for(i in 1:n_sim){
    y <- matrix(NA, nrow = M, ncol = J)
    for(j in 1:J){
      y[,j] <- rbinom(n=M, size = 1, prob = p[,j])
    }
    list_res[[i]] <- y
  }
  
  
  # export xy curves:
  seq_time_aggreg <- seq(0, wavelength, wavelength/512)
  
  # conditional mean (i.e. at typical site)
  cond_mean <- data.frame(p = boot::inv.logit(b0 +
                                                b1*cos(2*pi*seq_time_aggreg/(24) + theta0 + mean(phaseshift)) +
                                                b2*cos(2*pi*seq_time_aggreg/(bp) + theta1 + mean(phaseshift))), time = seq_time_aggreg) %>%
    dplyr::mutate(y_dens = p/MESS::auc(time, p))
  
  # marginal mean (i.e. population averaged)
  marg_phas <- rnorm(100000, 0, sd = sd_phaseshift)
  marg_tau <- rnorm(100000, 0, sd = sdtau)
  temp <- boot::inv.logit(matrix(b0, nrow=100000, ncol=length(seq_time_aggreg), byrow=TRUE) + # intercept
                            matrix(marg_tau, nrow=100000, ncol=length(seq_time_aggreg), byrow=FALSE) + # random intercept
                            b1*cos(matrix(2*pi*seq_time_aggreg/(24), nrow = 100000, ncol = length(seq_time_aggreg), byrow = TRUE) + theta0 + marg_phas) +
                            b2*cos(matrix(2*pi*seq_time_aggreg/(bp), nrow = 100000, ncol = length(seq_time_aggreg), byrow = TRUE) + theta1 + marg_phas))  # sinusoidal wave
  marg_mean <- data.frame(p = apply(temp, 2, mean), time = seq_time_aggreg) %>%
    dplyr::mutate(y_dens = p/MESS::auc(time, p))
  
  
  if(plot_true_act == TRUE){
    cond_mean2 <- cond_mean
    cond_mean2$Mean <- "Conditional"
    marg_mean2 <- marg_mean
    marg_mean2$Mean <- "Marginal"
    both_means <- rbind(cond_mean2, marg_mean2)
    pl <- ggplot2::ggplot(both_means, ggplot2::aes(x = time, y = p)) +
      ggplot2::geom_line(ggplot2::aes(color = Mean, linetype = Mean), linewidth=1) +
      #ggplot2::geom_line(ggplot2::aes(y = mean_realized), color = "red", linetype = "dashed") +
      ggplot2::scale_color_manual(values = c("red", "blue")) +
      ggplot2::theme_classic() +
      ggplot2::theme(legend.position = "top", legend.title = element_text(size = 12, face = "bold"), axis.title = element_text(size = 12)) +
      ggplot2::labs(x = "Time of day (Hour)", y = "Activity Pattern (probabilities)") +
      ggplot2::coord_cartesian(xlim = c(0, wavelength)) +
      ggplot2::scale_x_continuous(breaks=seq(0,wavelength,length.out = 7), labels=seq(0,24,4), expand = ggplot2::expansion(mult = c(0.02,0.02)))
    print(pl)
  }
  sim_act <- list("true_activity_prob" = p, "Conditional" = cond_mean, "Marginal" = marg_mean,  "sim_data" = list_res, "phaseshift" = phaseshift)
  return(sim_act)
  
}
  