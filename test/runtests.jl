using PSRIO
using Test

@testset "PSRIO integration tests" begin
    psrio = PSRIO.create()
    ver = PSRIO.version()
    PSRIO.set_executable_chmod(0o755)

    path = "./data/Case01/"

    com = """thermal = Thermal(); thermal.capacity:save("thermal_capacity")"""
    a = PSRIO.run(psrio, path, command = com, verbose = 3)

    # Everything runs
    @test true 
end
