#!/usr/bin/julia
#####################
#       Notes       #
#####################
# Shadercleanup:
#   -> For now I will leave the shitty push! robj + pipeline situation as it is to later implement a better way, redoing all the visualizes into also returning what pipeline

# Rendering issues:
#   -> glClear clears all colors?
#   -> I think I isolated the issue to the vertexarray + shader!

# Renderingcleanup:
#   -> Right now the way that the screenbuffer is displayed to the plot window requires there to be
#      at least one pipeline is inside the pipelines of the Screen. This should probably change.

#TODO generalcleanup: Put finalizer(free) for all the GLobjects!



using Makie
scene = Scene()
function xy_data(x, y)
    r = sqrt(x^2 + y^2)
    r == 0.0 ? 1f0 : (sin(r)/r)
end

r = linspace(-2, 2, 50)
surf_func(i) = [Float32(xy_data(x*i, y*i)) for x = r, y = r]
z = surf_func(20)
surf = surface!(scene, r, r, z)[end]

wf = wireframe!(scene, r, r, Makie.lift(x-> x .+ 1.0, surf[3]),
    linewidth = 2f0, color = Makie.lift(x-> to_colormap(x)[5], surf[:colormap]))


mesh([(0.0, 0.0), (0.5, 1.0), (1.0, 0.0)], color = [:red, :green, :blue],shading = false)

begin
    coordinates = [
        0.0 0.0;
        0.5 0.0;
        1.0 0.0;
        0.0 0.5;
        0.5 0.5;
        1.0 0.5;
        0.0 1.0;
        0.5 1.0;
        1.0 1.0;
    ]
    connectivity = [
        1 2 5;
        1 4 5;
        2 3 6;
        2 5 6;
        4 5 8;
        4 7 8;
        5 6 9;
        5 8 9;
    ]
    color = [0.0, 0.0, 0.0, 0.0, -0.375, 0.0, 0.0, 0.0, 0.0]
    scene = mesh(coordinates, connectivity, color = color, shading = false)
    wireframe!(scene[end][1], color = (:black, 0.6), linewidth = 3)
end
