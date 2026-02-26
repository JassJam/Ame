#pragma once

#include <Shaders/EngineShader.hpp>

namespace Ame::Rhi
{
    class AME_ENGINE_API StructStdSamplersShader : public EngineShader
    {
    private:
        static constexpr const char c_SourceCode[] = {
#include "StandardSamplers.static.hlsli.h"
            ,
            0x00
        };

    public:
        static constexpr const char* Name = "Structs/Rendering/StdSamplers.hlsli";

        StructStdSamplersShader()
        {
            Setup({ "S_StdMaterialFragment", Dg::SHADER_TYPE_UNKNOWN }, c_SourceCode);
        }
    };
}
