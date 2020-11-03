options <- commandArgs(trailingOnly = TRUE)
options = as.double(unlist(options))
options = as.list(options)

create_world <- function(length, width, initial_living_cell_ratio) {
    world = matrix(0, nrow = length, ncol = width)
    world = apply(world, c(1,2), function(x) sample(c(0,1),1,TRUE, c(1-initial_living_cell_ratio, initial_living_cell_ratio)))
    world
}

calc_index <-function(base, value,  neighborhood_size=0, index_shift=1) {
    (((base + value - neighborhood_size - index_shift) %% base) + index_shift)
}

create_lower_bounds <- function(x, y, nrows, ncols, neighborhood_size=1, index_shift=1) {
    c(calc_index(nrows,x,1), calc_index(ncols,y,1))
}

count_living_cells <- function(world, x, y, neighborhood_size) {
    ncols = ncol(world)
    nrows = nrow(world)
    lower_bounds = create_lower_bounds(x, y, nrows, ncols)
    sum = 0
    interval_lenght = neighborhood_size * 2
    for(x_hat in lower_bounds[1]:(lower_bounds[1]+interval_lenght)) {
        x_hat = calc_index(nrows, x_hat)
        for(y_hat in lower_bounds[2]:(lower_bounds[2]+interval_lenght)) {
            y_hat = calc_index(ncols, y_hat)
            if (x_hat == x & y_hat == y) {
                next
            }
            sum = sum + world[x_hat,y_hat]
        }   
    }
    sum
}

tick <- function(world, neighborhood_size) {
    new_world = matrix(0,nrow(world),ncol(world))
    for (x in 1:nrow(world)) {
        for (y in 1:ncol(world)) {
            neighbor_count = count_living_cells(world, x, y, neighborhood_size)
            # is cell alive?
            alive = world[x,y] == 1
            # print(sprintf('alive: %s', alive))
            if (alive) {
                # is neigbourhood over or under populated
                if ((neighbor_count < 2) || (3 < neighbor_count)) {
                    new_world[x,y] = 0
                } else {
                    new_world[x,y] = 1
                }
            # cell is dead and is reproduction possible
            } else if (! alive && (neighbor_count == 3)) {
                new_world[x,y] = 1
            }
        }
    }
    new_world
}