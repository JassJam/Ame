includes("glfw.lua")
includes("imgui.lua")
includes("concurrencpp.lua")
includes("kangaru.lua")
includes("mimalloc.lua")
includes("octree.lua")

--

local common_boost_libs = {
    "cmake",
    "asio",
    "iostreams",
    "lzma",
    "zlib",
    "bzip2",
    "filesystem",
    "system",
    "program_options",
    "serialization",
    "test",
    "thread",
    "leaf",
    "config",
    "exception",
    "regex",
}

local boost_libs_ver = "1.88.0"
local boost_libs_str = "boost[" .. table.concat(common_boost_libs, ",") .. "] " .. boost_libs_ver
add_requires(boost_libs_str, {alias = "boost-common"})

--

add_requires("assimp")

--

add_requires("cereal")

--

add_requires("dotnet 8.0.6")

--

add_requires("ame.mimalloc")

--

add_requires("ame.kangaru")

--

add_requires("spdlog")

--

-- comprimise until a fix for https://github.com/SanderMertens/flecs/issues/1032 is found
-- flecs component's id are static and can't be used in multiple dlls
-- add_defines("FLECS_CPP_NO_AUTO_REGISTRATION") 

add_requires("flecs v4.0.1", {configs = {shared = true}})

--

add_requires("freeimage", {configs = {rgb = true}})

--

add_requires("cryptopp")

--

add_requires("magic_enum")

--

add_requires("directxmath")

--

add_requires("ame.concurrencpp")

--

add_requires("ame.glfw")

--

add_requires("ame.imgui v1.91.1-docking", {configs = {shared = true, freetype = true}})

--

add_requires("ame.octree")

--

add_requires("diligentcore", {configs = {
    shared = true,
    hlsl = true,
    glslang = true,
    archiver = true,
    format_validation = true,

    vulkan = is_config("gfx-backend-vulkan", true),
    d3d12 = is_config("gfx-backend-d3d12", true),
    d3d11 = is_config("gfx-backend-d3d11", true),
    opengl = is_config("gfx-backend-opengl", true),

    debug = is_mode("debug"),
}})
