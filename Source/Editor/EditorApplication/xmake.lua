project_utils:declare_target({
    name = "AmeEditor",
    group = "Ame/Editor",
    kind = "binary",

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
        { name = "Ame.EditorPlugin", opts = {public = false} },
        { name = "Ame.Application", opts = {public = false} },
    },
    packages = {
        "dotnet"
    },

    callback = function ()
        set_runargs("-p", "Shared/Assets/Projects/EmptyProject", "-n", "Test")
    end
})