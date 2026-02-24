project_utils:declare_target({
    name = "PluginHost",
    group = "Examples",
    kind = "shared",

    files = {
        {path = "Private/**.cpp"}
    },
    
    deps = {
        { name = "AmeEngine", opts = {public = false} },
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