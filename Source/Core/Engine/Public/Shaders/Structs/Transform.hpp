#pragma once

#include <Shaders/EngineShader.hpp>

namespace Ame::Rhi
{
    class AME_ENGINE_API StructTransformShader : public EngineShader
    {
    private:
        static constexpr const char c_SourceCode[] = {
#include "Transform.static.hlsli.h"
            ,
            0x00
        };

    public:
        static constexpr const char* Name = "Structs/Transform.hlsli";

        StructTransformShader()
        {
            Setup({ "S_Transform", Dg::SHADER_TYPE_UNKNOWN }, c_SourceCode);
        }
    };
}
