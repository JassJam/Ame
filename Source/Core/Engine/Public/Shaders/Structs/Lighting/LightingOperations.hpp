#pragma once

#include <Shaders/EngineShader.hpp>

namespace Ame::Rhi
{
    class AME_ENGINE_API StructLightingOperationsShader : public EngineShader
    {
    private:
        static constexpr const char c_SourceCode[] = {
#include "LightingOperations.static.hlsli.h"
            , 0x00
        };

    public:
        static constexpr const char* Name = "Structs/Lighting/LightingOperations.hlsli";

        StructLightingOperationsShader()
        {
            Setup({ "SL_LightingOperations", Dg::SHADER_TYPE_UNKNOWN }, c_SourceCode);
        }
    };
} // namespace Ame::Rhi
