#pragma once

#include <Shaders/EngineShader.hpp>

namespace Ame::Rhi
{
    class AME_ENGINE_API StructGeometryFrustumPlanesShader : public EngineShader
    {
    private:
        static constexpr const char c_SourceCode[] = {
#include "Frustum.static.hlsli.h"
            ,
            0x00
        };

    public:
        static constexpr const char* Name = "Structs/Geometry/Frustum.hlsli";

        StructGeometryFrustumPlanesShader()
        {
            Setup({ "SG_FrustumPlanes", Dg::SHADER_TYPE_UNKNOWN }, c_SourceCode);
        }
    };
}
