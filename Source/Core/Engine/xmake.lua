project_utils:declare_target({
    name = "AmeEngine",
    group = "Ame/Core",
    kind = "shared",

    include_dirs = {
        {path = "Public",   opts = {public = true}},
        {path = "Private",  opts = {public = false}},
    },
    headerfiles = {
        {path = "Public/**.h",      opts = {public = true}},
        {path = "Public/**.hpp",    opts = {public = true}},
        {path = "Private/**.hpp",   opts = {public = false}},
    },
    files = {
        {path = "Public/**.static.hlsli", opts = {public = true, nozeroend = true}},
        {path = "Private/**.cpp"},
    },

    defines = {
        "AME_ENGINE_EXPORT"
    },
    forceincludes = {
        { path = "Core/Api.hpp", opts = {public = true} },
    },
    
    packages = {
        { name = "boost-common",    opts = {public = true} },
        { name = "cereal",          opts = {public = true} },
        { name = "diligentcore",    opts = {public = true} },
        { name = "ame.kangaru",     opts = {public = true} },
        { name = "spdlog",          opts = {public = true} },
        { name = "fmt",             opts = {public = true} },
        { name = "cryptopp",        opts = {public = true} },
        { name = "magic_enum",      opts = {public = true} },
        { name = "glm",             opts = {public = true} },
        { name = "ame.mimalloc",    opts = {public = true} },
        { name = "ame.concurrencpp",opts = {public = true} },
        { name = "ame.glfw",        opts = {public = true} },
        { name = "ame.octree",      opts = {public = true} },
        { name = "flecs",           opts = {public = true} },
        { name = "freeimage",       opts = {public = true} },
        { name = "ame.imgui",       opts = {public = true} },
        { name = "assimp",          opts = {public = false} },
    },

    rules = {
        {name = "utils.bin2c", opts = {linewidth = 16, extensions = {".static.hlsli"}}},
    }
})