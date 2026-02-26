#pragma once

#include <Shaders/EngineShader.hpp>

namespace Ame::Rhi
{
    class AME_ENGINE_API GeometryPlanesShader : public EngineShader
    {
    private:
        static constexpr const char c_SourceCode[] = {
#include "Cone.static.hlsli.h"
            ,
            0x00
        };

    public:
        static constexpr const char* Name = "Structs/Geometry/Planes.hlsli";

        GeometryPlanesShader()
        {
            Setup({ "G_Planes", Dg::SHADER_TYPE_UNKNOWN }, c_SourceCode);
        }
    };
}
