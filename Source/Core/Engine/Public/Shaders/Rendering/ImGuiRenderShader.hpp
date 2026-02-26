#pragma once

#include <Shaders/EngineShader.hpp>

namespace Ame::Rhi
{
    class AME_ENGINE_API ImGuiRenderVertexShader : public EngineShader
    {
    private:
        static constexpr const char c_SourceCode[] = {
#include "ImGuiRenderShader_VS.static.hlsli.h"
            , 0x00
        };

    public:
        ImGuiRenderVertexShader()
        {
            Setup({ "R_ImGui_VS", Dg::SHADER_TYPE_VERTEX }, c_SourceCode);
        }
    };

    class AME_ENGINE_API ImGuiRenderPixelShader : public EngineShader
    {
    private:
        static constexpr const char c_SourceCode[] = {
#include "ImGuiRenderShader_PS.static.hlsli.h"
            , 0x00
        };

    public:
        ImGuiRenderPixelShader()
        {
            Setup({ "R_ImGui_PS", Dg::SHADER_TYPE_PIXEL, true }, c_SourceCode);
        }
    };
} // namespace Ame::Rhi