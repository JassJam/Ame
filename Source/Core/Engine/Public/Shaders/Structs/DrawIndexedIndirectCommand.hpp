#pragma once

#include <Shaders/EngineShader.hpp>

namespace Ame::Rhi
{
    class AME_ENGINE_API StructDrawIndexedIndirectCommandShader : public EngineShader
    {
    private:
        static constexpr const char c_SourceCode[] = {
#include "DrawIndexedIndirectCommand.static.hlsli.h"
            ,
            0x00
        };

    public:
        static constexpr const char* Name = "Structs/DrawIndexedIndirectCommand.hlsli";

        StructDrawIndexedIndirectCommandShader()
        {
            Setup({ "Struct DrawIndexedIndirectCommand", Dg::SHADER_TYPE_UNKNOWN }, c_SourceCode);
        }
    };
}
