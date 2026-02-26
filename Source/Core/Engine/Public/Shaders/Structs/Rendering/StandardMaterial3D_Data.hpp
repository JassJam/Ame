#pragma once

#include <Shaders/EngineShader.hpp>

namespace Ame::Rhi
{
    class AME_ENGINE_API StructStdMaterial3D_DataShader : public EngineShader
    {
    private:
        static constexpr const char c_SourceCode[] = {
#include "StandardMaterial3D_Data.static.hlsli.h"
            ,
            0x00
        };

    public:
        static constexpr const char* Name = "Structs/Rendering/StdMaterial3D_Data.hlsli";

        StructStdMaterial3D_DataShader()
        {
            Setup({ "S_StdMaterialFragment", Dg::SHADER_TYPE_UNKNOWN }, c_SourceCode);
        }
    };
}
