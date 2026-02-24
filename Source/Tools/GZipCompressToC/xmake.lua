project_utils:declare_target({
    name = "GZipCompressToC",
    group = "Tools",
    kind = "binary",

    files = {
        {path = "Private/**.cpp"}
    },
    
    deps = {
        { name = "AmeEngine", opts = {public = false} },
    },
})