# ~ with open("inputs/clusters/980_PM100", "w") as f:
with open("inputs/clusters/10_PM100", "w") as f:
    # ~ for i in range(980):
    # ~ for i in range(10):
    for i in range(1):
        line = (
            f"{{ id: {i} memory: 256 core: 10 ncpu: 2 ngpu: 4 }}\n"
        )
        f.write(line)
