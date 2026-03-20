return {
    s("pdf", fmt('print(f"{{{}=}}")', { i(1, "var") })),

    s("bench", fmt([[
    import time
    t0 = time.perf_counter()
    {}
    print(time.perf_counter() - t0)
    ]], {
        i(1, "# code here")
    })),

    -- file read/write skeleton
    s("readfile", fmt([[
    with open("{}", "r") as f:
        {} = f.read()
    ]], {
        i(1, "filename"),
        i(2, "data")
    })),

    s("writefile", fmt([[
    with open("{}", "w") as f:
        f.write({})
    ]], {
        i(1, "filename"),
        i(2, "data")
    })),
}
