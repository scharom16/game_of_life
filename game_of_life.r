options <- commandArgs(trailingOnly = TRUE)
options = as.double(unlist(options))
options = as.list(options)

create_world <- function(length, width, initial_living_cell_ratio) {
    
    world = matrix(0L, nrow = length, ncol = width)
    world = apply(world, c(1,2), function(x) sample(c(0,1),1,TRUE, c(1-initial_living_cell_ratio, initial_living_cell_ratio)))
    print(world)
    world
}

count_living_cells <- function(world, x, y, neighborhood_size) {
    print(neighborhood_size)
    x_vals = (x-neighborhood_size):(x+neighborhood_size)
    y_vals = (y-neighborhood_size):(y+neighborhood_size)
    print(x_vals)
    sum = 0
    for(x_hat in x_vals) {
        for(y_hat in y_vals) {
            if (x_hat == x & y_hat == y) {
                next
            }
            sum = sum + world[x_hat,y_hat]
        }   
    }
    sum
}

print(count_living_cells(do.call(create_world,options), 6,6, 1))

tick <- function(world) {
    iteration = 0
    alive = world.sum()

}