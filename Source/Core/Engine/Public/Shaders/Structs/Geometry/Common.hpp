#pragma once

#include <Shaders/EngineShader.hpp>

namespace Ame::Rhi
{
    class AME_ENGINE_API GeometryCommonShader : public EngineShader
    {
    private:
        static constexpr const char c_SourceCode[] = {
#include "Common.static.hlsli.h"
            , 0x00
        };

    public:
        static constexpr const char* Name = "Structs/Geometry/Common.hlsli";

        GeometryCommonShader()
        {
            Setup({ "G_Common", Dg::SHADER_TYPE_UNKNOWN }, c_SourceCode);
        }
    };
} // namespace Ame::Rhi