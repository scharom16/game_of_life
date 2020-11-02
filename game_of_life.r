options <- commandArgs(trailingOnly = TRUE)
options = as.double(unlist(options))
options = as.list(options)

create_world <- function(length, width, initial_living_cell_ratio) {
    
    world = matrix(0, nrow = length, ncol = width)
    world = apply(world, c(1,2), function(x) sample(c(0,1),1,TRUE, c(1-initial_living_cell_ratio, initial_living_cell_ratio)))
    print(world)
    world
}

count_living_cells <- function(world, x, y, neighborhood_size) {
    print(neighborhood_size)
    x_vals = (x-neighborhood_size):(x+neighborhood_size)
    y_vals = (y-neighborhood_size):(y+neighborhood_size)
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
    alive = world.sum()
    new_world = Matrix(0,nrow(world),ncol(world))
    for (x in 1:nrow(world)) {
        for (y in 1:ncol(world)) {
            neighbor_count = count_living_cells(world, x, y, 1)
            # is cell alive?
            if(world[x,y] == 1){
                # is neigbourhood over or under populated
                if (neighbor_count < 2 | 3 < neighbor_count) {
                    new_world[x,y] = 0
                } else {
                    new_worldp[x,y] = 1
                }
                # cell is dead and is reproduction possible
            } else if (world[x,y] == 0 & neighbor_count == 3){
                new_world[x,y] = 1
            }
        }
    }
    new_world
}