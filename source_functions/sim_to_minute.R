sim_to_minute <- function(time, group){
  temp <- floor(time/group)
  return(time-group*temp)
}
