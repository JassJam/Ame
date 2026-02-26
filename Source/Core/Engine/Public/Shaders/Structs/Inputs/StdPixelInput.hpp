#pragma once

#include <Shaders/EngineShader.hpp>

namespace Ame::Rhi
{
    class AME_ENGINE_API StructStdPixelInputShader : public EngineShader
    {
    private:
        static constexpr const char c_SourceCode[] = {
#include "StdPixelInput.static.hlsli.h"
            ,
            0x00
        };

    public:
        static constexpr const char* Name = "Structs/Inputs/StdPixelInput.hlsli";

        StructStdPixelInputShader()
        {
            Setup({ "S_StdPixelInput", Dg::SHADER_TYPE_UNKNOWN }, c_SourceCode);
        }
    };
}
