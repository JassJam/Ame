includes("Project/Options.lua")

--

rule("csharp")
	set_extensions(".csproj", ".cs")
rule_end()

--

set_languages("cxxlatest")
add_rules("mode.debug", "mode.releasedbg")
set_policy("install.strip_packagelibs", false)

--

includes("Project/Utils.lua")

--

_script_root_dir = os.scriptdir()

--

add_defines("NOMINMAX")
set_warnings("allextra", "error")

--

-- linking for asan, adding directory of clang_rt.asan
if is_mode("check") then
    on_load(function (target)
        local msvc = target:toolchain("msvc")
        if msvc then
            local runenvs = msvc:runenvs()
            if runenvs then
                local lib_path = runenvs["LIB"]
                -- split by ';' lib_path
                for cur_path in lib_path:gmatch("([^;]+)") do
                    target:add("linkdirs", cur_path)
                end
            end
        end
    end)
end

--

add_extrafiles("LICENSE.txt")
add_extrafiles(".clang-format")
add_extrafiles(".clang-tidy")

--

includes("Project/Ame.lua")
