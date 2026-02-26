local function _make_raw_string_literal(source)
    local delimiter = "AME_SHADER"
    while source:find(")" .. delimiter .. "\"", 1, true) do
        delimiter = delimiter .. "_"
    end
    return string.format("R\"%s(%s)%s\"\n", delimiter, source, delimiter)
end

local function _write_embedded_shader(output_file, source)
    local generated = _make_raw_string_literal(source)
    local existing = nil
    if os.isfile(output_file) then
        existing = io.readfile(output_file)
    end
    if existing == generated then
        return false
    end

    local output_dir = path.directory(output_file)
    if output_dir and #output_dir > 0 then
        os.mkdir(output_dir)
    end

    io.writefile(output_file, generated)
    return true
end

local function _shader_needs_regen(input_file, output_file)
    if not os.isfile(output_file) then
        return true
    end

    local source_mtime = os.mtime(input_file) or 0
    local output_mtime = os.mtime(output_file) or 0
    return source_mtime > output_mtime
end

local function _embed_stale_shaders(shader_files)
    local updated = 0
    local unchanged = 0
    for _, shader_file in ipairs(shader_files) do
        local normalized_shader = shader_file
        if not os.isfile(normalized_shader) then
            os.raise("shader file does not exist: %s", normalized_shader)
        end

        local generated = normalized_shader .. ".generated.hpp"
        if _shader_needs_regen(normalized_shader, generated) then
            local source = io.readfile(normalized_shader)
            if not source then
                os.raise("failed to read shader file: %s", normalized_shader)
            end

            if _write_embedded_shader(generated, source) then
                updated = updated + 1
            else
                unchanged = unchanged + 1
            end
        else
            unchanged = unchanged + 1
        end
    end

    return #shader_files, updated, unchanged
end

local function _resolve_rule_files(target, rule_name)
    local files = target:extraconf("rules", rule_name, "files")
    if not files then
        print(string.format("warning: rule(%s) has no files specified for target(%s). Skipping.", rule_name, target:name()))
        return {}
    end

    local resolved_files = {}
    for _, file in ipairs(files) do
        local input, output = nil, nil
        if type(file) == "string" then
            input = file
            output = file .. ".generated.hpp"
        elseif type(file) == "table" then
            input = file.input
            output = file.output
            if not input then
                os.raise("invalid file entry in rule(%s) for target(%s). Each entry must be either a string or a table with `input` and `output` fields.", rule_name, target:name())
            end
            if not output then
                output = input .. ".generated.hpp"
            end
        else
            os.raise("invalid file entry in rule(%s) for target(%s). Each entry must be either a string or a table with `input` and `output` fields.", rule_name, target:name())
        end

        table.insert(resolved_files, { input = input, output = output })
    end

    return resolved_files
end

rule("file-to-header")
    set_extensions(".hlsli")
    on_buildcmd_file(function (target, batchcmds, sourcefile, opt)
        print("applying rule 'file-to-header' to target: " .. target:name())
    end)

    on_load(function(target)
        print("applying rule 'file-to-header' to target: " .. target:name())
        local rule_name = "file-to-header"
        local files = _resolve_rule_files(target, rule_name)
        for _, file_pair in ipairs(files) do
            print("embeding file to header: " .. file_pair.input .. " -> " .. file_pair.output)
            local updated, unchanged = _embed_stale_shaders({ file_pair.input })
        end
        -- local total, updated, unchanged = _embed_stale_shaders(shader_files)
        -- if total == 0 then
        --     return
        -- end

        -- if updated > 0 then
        --     print(string.format(
        --         "Target %s: embedded %d file(s): %d updated, %d unchanged.",
        --         target:name(),
        --         total,
        --         updated,
        --         unchanged
        --     ))
        -- end
    end)
rule_end()
