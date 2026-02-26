#pragma once

#include <Shaders/EngineShader.hpp>

namespace Ame::Rhi
{
    class AME_ENGINE_API StructRenderInstanceShader : public EngineShader
    {
    private:
        static constexpr const char c_SourceCode[] = {
#include "RenderInstance.static.hlsli.h"
            ,
            0x00
        };

    public:
        static constexpr const char* Name = "Structs/RenderInstance.hlsli";

        StructRenderInstanceShader()
        {
            Setup({ "S_RenderInstance", Dg::SHADER_TYPE_UNKNOWN }, c_SourceCode);
        }
    };
}
