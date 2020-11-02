options <- commandArgs(trailingOnly = TRUE)
options = as.double(unlist(options))
options = as.list(options)

create_world <- function(length, width, initial_living_cell_ratio) {
    
    world = matrix(0L, nrow = length, ncol = width)
    world = apply(world, c(1,2), function(x) sample(c(0,1),1,TRUE, c(1-initial_living_cell_ratio, initial_living_cell_ratio)))
    print(sum(world))
}

do.call(create_world,options)

tick <- function(world) {
    iteration = 0
    alive = world.sum()

}