using MPSensitivity
using Test

@testset "MPSensitivity.jl" begin
    # Write your tests here.
    @test get_efficiency(4,2) == 2.0
end
