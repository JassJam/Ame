project_utils:declare_target({
    name = "SimpleWindow",
    group = "Examples",
    kind = "binary",

    files = {
        {path = "Private/**.cpp"}
    },
    
    deps = {
        { name = "AmeEngine", opts = {public = false} },
    },
})