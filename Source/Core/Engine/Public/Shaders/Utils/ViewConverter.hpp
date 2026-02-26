#pragma once

#include <Shaders/EngineShader.hpp>

namespace Ame::Rhi
{
    class AME_ENGINE_API UtilsViewConverterShader : public EngineShader
    {
    private:
        static constexpr const char c_SourceCode[] = {
#include "ViewConverter.static.hlsli.h"
            , 0x00
        };

    public:
        static constexpr const char* Name = "Utils/ViewConverter.hlsli";

        UtilsViewConverterShader()
        {
            Setup({ "U_ViewConverter", Dg::SHADER_TYPE_UNKNOWN }, c_SourceCode);
        }
    };
} // namespace Ame::Rhi