project_utils:declare_target({
    name = "Ame.EditorPlugin",
    group = "Ame/Editor",
    kind = "static",

    include_dirs = {
        {path = "Public",   opts = {public = true}},
        {path = "Private",  opts = {public = false}},
    },
    headerfiles = {
        {path = "Public/**.hpp",    opts = {public = true}},
        {path = "Private/**.hpp",   opts = {public = false}},
    },
    files = {
        {path = "Private/**.cpp"}
    },

    deps = {
        { name = "AmeEngine", opts = {public = false} },
    },
})