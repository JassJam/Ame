#pragma once

#include <Shaders/EngineShader.hpp>

namespace Ame::Rhi
{
    class AME_ENGINE_API StructStdVertexOutputShader : public EngineShader
    {
    private:
        static constexpr const char c_SourceCode[] = {
#include "StdVertexOutput.static.hlsli.h"
            , 0x00
        };

    public:
        static constexpr const char* Name = "Structs/Outputs/StdVertexOutput.hlsli";

        StructStdVertexOutputShader()
        {
            Setup({ "S_StdVertexOutput", Dg::SHADER_TYPE_UNKNOWN }, c_SourceCode);
        }
    };
} // namespace Ame::Rhi