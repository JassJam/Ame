local targets = {
    {
        name = "AmeSharp.Core",
        path = "AmeSharp.Core"
    },
    {
        name = "AmeSharp.RuntimeHost",
        path = "AmeSharp.RuntimeHost"
    },
    -- {
    --     name = "AmeSharp.Rhi",
    --     path = "AmeSharp.Rhi"
    -- },
    {
        name = "Sample",
        path = "Sample"
    },
}
for _, target in ipairs(targets) do
    project_utils:declare_target({
        name = target.name,
        group = "Ame/Scripting",
        kind = "shared",

        files = {
            "./" .. target.path .. "/**.cs",
            "./" .. target.path .. "/**.csproj",
        },
        extrafiles = {
            "./" .. target.path .. "/**.cs",
            "./" .. target.path .. "/**.csproj",
        },
        rules = {
            "target-csharp",
        },

        callback = function ()
            on_load(function (target)
                local target_dir = target:targetdir()
                target:set("targetdir", target_dir .. "/Plugins")
            end)

            on_install(function (target)
                local install_dir = target:installdir()
                install_dir = (install_dir and install_dir .. "/Plugins") or target:targetdir()
                if install_dir ~= target:targetdir() then
                    os.cp(target:targetdir(), install_dir)
                end
            end)
        end
    })
end
-- project_utils:declare_target({
--     name = "AmeSharp.Core",
--     group = "Ame/Scripting",
--     kind = "shared",

--     files = {
--         "./AmeSharp.Core/**.cs",
--         "./AmeSharp.Core/**.csproj",
--     },
--     extrafiles = {
--         "./AmeSharp.Core/**.cs",
--         "./AmeSharp.Core/**.csproj",
--     },
--     rules = {
--         "target-csharp",
--     },

--     callback = function ()
--         on_load(function (target)
--             local target_dir = target:targetdir()
--             target:set("targetdir", target_dir .. "/Plugins")
--         end)

--         on_install(function (target)
--             local install_dir = target:installdir()
--             install_dir = (install_dir and install_dir .. "/Plugins") or target:targetdir()
--             if install_dir ~= target:targetdir() then
--                 os.cp(target:targetdir(), install_dir)
--             end
--         end)
--     end
-- })
