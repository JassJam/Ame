project_utils:declare_target({
    name = "EditorCore",
    group = "Ame/Editor",
    kind = "shared",

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