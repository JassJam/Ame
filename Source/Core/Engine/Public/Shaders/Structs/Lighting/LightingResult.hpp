#pragma once

#include <Shaders/EngineShader.hpp>

namespace Ame::Rhi
{
    class AME_ENGINE_API StructLightingResultShader : public EngineShader
    {
    private:
        static constexpr const char c_SourceCode[] = {
#include "LightingResult.static.hlsli.h"
            ,
            0x00
        };

    public:
        static constexpr const char* Name = "Structs/Lighting/LightingResult.hlsli";

        StructLightingResultShader()
        {
            Setup({ "SL_LightingResult", Dg::SHADER_TYPE_UNKNOWN }, c_SourceCode);
        }
    };
}
