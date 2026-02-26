#pragma once

#include <Shaders/EngineShader.hpp>

namespace Ame::Rhi
{
    class AME_ENGINE_API StructLightShader : public EngineShader
    {
    private:
        static constexpr const char c_SourceCode[] = {
#include "Light.static.hlsli.h"
            ,
            0x00
        };

    public:
        static constexpr const char* Name = "Structs/Light.hlsli";

        StructLightShader()
        {
            Setup({ "S_Light", Dg::SHADER_TYPE_UNKNOWN }, c_SourceCode);
        }
    };
}
