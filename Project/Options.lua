-- set the type of graphics backend to use
option("gfx-backend-vulkan", {
    showmenu = true,
    default = true,
    description = "Enable Vulkan graphics backend"
})
option("gfx-backend-d3d12", {
    showmenu = true,
    default = true,
    description = "Enable Direct3D 12 graphics backend"
})
option("gfx-backend-d3d11", {
    showmenu = true,
    default = true,
    description = "Enable Direct3D 11 graphics backend"
})
option("gfx-backend-opengl", {
    showmenu = true,
    default = false,
    description = "Enable OpenGL graphics backend"
})

-- disable imgui by defining AME_NO_IMGUI
option("no-imgui", {
    showmenu = true,
    default = false,
    description = "Disable ImGui"
})
if has_config("no-imgui") then
    add_defines("AME_NO_IMGUI")
end
