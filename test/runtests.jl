using PSRIO
using Test

@testset "PSRIO integration tests" begin
    psrio = PSRIO.create()
    ver = PSRIO.version()
    PSRIO.set_executable_chmod(0o755)

    path = "./data/Case01/"

    com = """thermal = Thermal(); thermal.max_generation:save("thermal_max_generation")"""
    a = PSRIO.run(psrio, path, command = com, verbose = 3)

    # Everything runs
    @test true 
end
