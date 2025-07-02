# ~ with open("inputs/clusters/980_PM100", "w") as f:
with open("inputs/clusters/10_PM100", "w") as f:
    # ~ for i in range(980):
    for i in range(10):
        line = (
            f"{{ id: {i} memory: 256 bandwidth: 0 core: 32 cpu_tdp: 0 ncpu: 2 "
            f"ngpu: 4 idle_power: 0 carbon_rate: 0 carbon_intensity: 0 endpoint_id: {i} }}\n"
        )
        f.write(line)
