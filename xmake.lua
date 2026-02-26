includes("Project/Options.lua")
includes("Project/Rules.lua")

--

add_rules("mode.debug", "mode.release")
set_languages("c++23")
add_defines("NOMINMAX")

set_policy("install.strip_packagelibs", false)
set_warnings("allextra", "error")

--

if is_mode("check") then
    set_policy("build.sanitizer.address", true)
end

--

if is_mode("debug") then
    add_defines("AME_DEBUG")
    set_symbols("debug", "edit")
elseif is_mode("check") then 
    add_defines("AME_DEBUG")
    add_defines("AME_DEBUG_SANITIZE")
    set_symbols("debug")
elseif is_mode("releasedbg") then
    add_defines("AME_RELEASE")
    set_symbols("debug")
elseif is_mode("release") then
    add_defines("AME_DIST")
    set_symbols("hidden")
end

if is_plat("windows") then
    add_defines("AME_PLATFORM_WINDOWS")
elseif is_plat("linux") then
    add_defines("AME_PLATFORM_LINUX")
end

--

add_extrafiles("LICENSE.txt")
add_extrafiles(".clang-format")
add_extrafiles(".clang-tidy")

--

includes("Project/ThirdParty.lua")
includes("Project/Projects.lua")
