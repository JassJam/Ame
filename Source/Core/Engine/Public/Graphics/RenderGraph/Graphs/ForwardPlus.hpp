#pragma once

namespace Ame
{
    namespace Rg
    {
        class Graph;
    }
    namespace Ecs
    {
        class World;
    }
}

namespace Ame::Gfx
{
    /// <summary>
    /// Registers the Forward+ rendering pass to the graph.
    /// </summary>
    AME_ENGINE_API void RegisterForwardPlus(Rg::Graph& graph, Ecs::World* world);
}
