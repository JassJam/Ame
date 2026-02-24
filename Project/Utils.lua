project_utils = {}

-- rule to process .env files and generate C++ defines
-- supports typed environment variables: KEY:TYPE=VALUE
-- types: string (quoted), int, bool, double/float, raw (default, unquoted)
-- priority: system env vars > .env.local (debug only) > .env
-- Examples:
--   DEFAULT_PASSWORD:string=R"(test"test)"  -> #define DEFAULT_PASSWORD R"(test"test)"
--   API_KEY:string=secret123                -> #define API_KEY "secret123"
--   MAX_RETRIES:int=5                       -> #define MAX_RETRIES 5
--   DEBUG_MODE:bool=true                    -> #define DEBUG_MODE true
--   TIMEOUT:double=30.5                     -> #define TIMEOUT 30.5
--   CONFIG_PATH="C:\Program Files\App"      -> #define CONFIG_PATH C:\Program Files\App (raw)
rule("target-env")
    set_extensions(".env")

    on_load(function(target)
        local function _parse_env_file(file)
            local env_vars = {}
            local content = io.readfile(file)
            if not content then
                return env_vars
            end
            for line in content:gmatch("[^\r\n]+") do
                if not line:match("^%s*$") and not line:match("^%s*#") then
                    local key, type_hint, value = line:match("^([A-Z_][A-Z0-9_]*):([a-z]+)%s*=%s*(.*)$")
                    if not key then
                        key, value = line:match("^([A-Z_][A-Z0-9_]*)%s*=%s*(.*)$")
                        type_hint = ""
                    end
                    if key and value then
                        value = value:match("^(.-)%s*$")
                        env_vars[key] = {value = value, type = type_hint}
                    end
                end
            end
            return env_vars
        end

        local function _merge_env_vars(dest, source)
            for k, v in pairs(source) do
                dest[k] = v
            end
        end

        local sourcefiles = target:sourcefiles()
        local env_files = {}
        
        for _, sourcefile in ipairs(sourcefiles) do
            local file_name = path.filename(sourcefile)
            if file_name:match("^%.env") and not file_name:match("%.local$") then
                local local_file = sourcefile .. ".local"
                local local_exists = os.isfile(local_file)
                table.insert(env_files, {
                    base = sourcefile,
                    local_file = local_exists and local_file or nil
                })
            end
        end
        
        local env_vars = {}
        
        for _, env_pair in ipairs(env_files) do
            _merge_env_vars(env_vars, _parse_env_file(env_pair.base))
            
            if env_pair.local_file and is_mode("debug") then
                _merge_env_vars(env_vars, _parse_env_file(env_pair.local_file))
            end
        end
        
        if #env_files > 0 then
            local build_dir = path.join(os.projectdir(), "build")
            os.mkdir(build_dir)
            
            local header_path = path.join(build_dir, target:name() .. "_env_config.h")
            local need_regenerate = not os.isfile(header_path)
            if need_regenerate then
                io.writefile(header_path, "// Auto-generated from .env file\n#pragma once\n\n")
            end
            
            if not need_regenerate then
                local header_mtime = os.mtime(header_path)
                for _, env_pair in ipairs(env_files) do
                    if os.mtime(env_pair.base) > header_mtime then
                        need_regenerate = true
                        break
                    end
                    if env_pair.local_file and is_mode("debug") and os.mtime(env_pair.local_file) > header_mtime then
                        need_regenerate = true
                        break
                    end
                end
            end
            
            if need_regenerate then
                local header_content = "// Auto-generated from .env file\n#pragma once\n\n"
                
                local count = 0
                for key, var_info in pairs(env_vars) do
                    count = count + 1
                    local value = var_info.value
                    local var_type = var_info.type
                    
                    local system_value = os.getenv(key)
                    if system_value then
                        value = system_value
                    end
                    
                    if var_type == "int" then
                        header_content = header_content .. string.format('#define %s %s\n', key, value)
                    elseif var_type == "bool" then
                        local bool_val = (value == "true" or value == "1") and "true" or "false"
                        header_content = header_content .. string.format('#define %s %s\n', key, bool_val)
                    elseif var_type == "double" or var_type == "float" then
                        header_content = header_content .. string.format('#define %s %s\n', key, value)
                    elseif var_type == "string" then
                        local raw_content = value:match('^R"%((.*)%)"$')
                        if raw_content then
                            header_content = header_content .. string.format('#define %s R"(%s)"\n', key, raw_content)
                        elseif value:match('^".*"$') then
                            value = value:gsub("\\\\", "\\")
                            header_content = header_content .. string.format('#define %s %s\n', key, value)
                        else
                            value = value:gsub("\\", "\\\\")
                            value = value:gsub('"', '\\"')
                            header_content = header_content .. string.format('#define %s "%s"\n', key, value)
                        end
                    else
                        header_content = header_content .. string.format('#define %s %s\n', key, value)
                    end
                end
                
                local existing_content = io.readfile(header_path)
                if existing_content ~= header_content then
                    io.writefile(header_path, header_content)
                end
            end
            
            target:add("forceincludes", header_path)
        end
    end)
rule_end()

-- TODO: will be removed in favor of https://github.com/xmake-io/xmake/pull/7342
rule("target-csharp")
    set_extensions(".cs", ".csproj")

    local function find_csproj(target)
        local sourcefiles = target:sourcefiles()
        print("Finding .csproj file for target " .. target:name())
        for _, file in ipairs(sourcefiles) do
            if path.extension(file) == ".csproj" then
                print("Found .csproj file: " .. file)
                return file
            end
        end
        return nil
    end

    local function print_missing_csproj_warning(target)
        print("Warning: No .csproj file found for target " .. target:name() .. ", C# build will be skipped")
    end

    on_build(function (target)
        local target_path =  target:targetdir()
        local csproj = find_csproj(target)
        if csproj then
            local mode = "Debug"
            if is_mode("release") then
                mode = "Release"
            end

            os.execv("dotnet", {
                "build", csproj,
                "--configuration", mode,
                "--output", target_path,
                "--nologo",
                "--verbosity", "minimal",
            })
        else
            print_missing_csproj_warning(target)
        end
    end)
    on_clean(function (target)
        local csproj = find_csproj(target)
        if csproj then
            os.execv("dotnet", {
            "clean", csproj,
            "--nologo",
            "--verbosity", "minimal",
        })
        else
            print_missing_csproj_warning(target)
        end
    end)
    on_run(function (target)
        local csproj = find_csproj(target)
        if csproj then
            local mode = "Debug"
            if is_mode("release") then
                mode = "Release"
            end

            os.execv("dotnet", {
                "run", csproj,
                "--configuration", mode,
                "--nologo",
                "--verbosity", "minimal",
            })
        else
            print_missing_csproj_warning(target)
        end
    end)
    on_install(function (target)
        local install_path =  target:installdir()
        local csproj = find_csproj(target)
        if csproj then
            local mode = "Debug"
            if is_mode("release") then
                mode = "Release"
            end
            os.execv("dotnet", {
                "publish", csproj,
                "--configuration", mode,
                "--output", install_path,
                "--nologo",
                "--verbosity", "minimal",
            })
        else
            print_missing_csproj_warning(target)
        end
    end)
rule_end()

--

local function _make_moduleonly_library()
    set_kind("moduleonly")
end

local function _make_headeronly_library()
    set_kind("headeronly")
end

local function _make_static_library()
    set_kind("static")
end

local function _make_shared_library()
    set_kind("shared")
end

local function _make_binary_library()
    set_kind("binary")
end

local function _make_phony_library()
    set_kind("phony")
end

local function _declare_target(opts)
    target(opts.name)
        add_rules("target-env")

        if not opts.path then
            opts.path = "."
        end

        set_group(opts.group)

        if opts.rules then
            for _, rule in ipairs(opts.rules) do
                add_rules(rule)
            end
        end

        local switch = {
            moduleonly = _make_moduleonly_library,
            headeronly = _make_headeronly_library,
            static = _make_static_library,
            shared = _make_shared_library,
            binary = _make_binary_library,
            phony = _make_phony_library,
        }
        if opts.kind then
            switch[opts.kind]()
        end

        for _, dir in ipairs(opts.include_dirs or {}) do
            if type(dir) == "string" then
                add_includedirs(opts.path .. "/" .. dir)
            else
                add_includedirs(opts.path .. "/" .. dir.path, dir.opts)
            end
        end

        if opts.files then
            for _, file in ipairs(opts.files) do
                if type(file) == "string" then
                    add_files(file)
                else
                    add_files(file.path, file.opts)
                end
            end
        end

        if opts.extrafiles then
            for _, file in ipairs(opts.extrafiles) do
                if type(file) == "string" then
                    add_extrafiles(file)
                else
                    add_extrafiles(file.path, file.opts)
                end
            end
        end

        if opts.headerfiles then
            for _, file in ipairs(opts.headerfiles) do
                if type(file) == "string" then
                    add_headerfiles(file)
                else
                    add_headerfiles(file.path, file.opts)
                end
            end
        end

        if opts.forceincludes then
            for _, file in ipairs(opts.forceincludes) do
                if type(file) == "string" then
                    add_forceincludes(file)
                else
                    add_forceincludes(file.path, file.opts)
                end
            end
        end

        if opts.defines then
            for _, define in ipairs(opts.defines) do
                if type(define) == "string" then
                    add_defines(define)
                else
                    add_defines(define.name, define.opts)
                end
            end
        end

        if opts.deps then
            for _, dep in ipairs(opts.deps) do
                if type(dep) == "string" then
                    add_deps(dep)
                else
                    add_deps(dep.name, dep.opts)
                end
            end
        end

        if opts.packages then
            for _, package in ipairs(opts.packages) do
                if type(package) == "string" then
                    add_packages(package)
                else
                    add_packages(package.name, package.opts)
                end
            end
        end

        if opts.filegroups then
            for _, filegroup in ipairs(opts.filegroups) do
                add_filegroups(filegroup.name, filegroup.opts)
            end
        end

        if opts.callback then
            opts.callback()
        end

    target_end()
end

local function _add_tests(opts)
    local test_opts = opts.test
    if not test_opts then
        return
    end

    local test_group = opts.group
    if test_group then
        test_group = "tests/" .. test_group
    else
        test_group = "tests"
    end

    local initial_name = test_opts.name
    if not initial_name then
        initial_name = "test." .. opts.name
    end

    local test_deps = test_opts.deps or {}
    table.insert(test_deps, opts.name)

    local test_packages = test_opts.packages or {}
    table.insert(test_packages, {name = "boost-common", {public = true, inherit = true}})

    local test_config = {
        name = initial_name,
        kind = "binary",
        group = test_group,
        path = test_opts.path or opts.path or ".",
        deps = test_deps,
        packages = test_packages,
        files = test_opts.files,
        extrafiles = test_opts.extrafiles,
        include_dirs = test_opts.include_dirs,
        headerfiles = test_opts.headerfiles,
        filegroups = test_opts.filegroups,
        defines = test_opts.defines,
        forceincludes = test_opts.forceincludes,
        rules = test_opts.rules,
    }

    test_config.callback = function()
        add_tests("default")
        if test_opts.callback then
            test_opts.callback()
        end
    end
    _declare_target(test_config)
end

---
-- Declare a project with the given options
-- opts:
-- - name: the name of the project
-- - path: the path to the project
-- - group: the group of the project
-- - kind: the kind of the project
-- - callback?: a callback function to be called after the project is declared
-- - files[]?: a list of files to be added to the project
-- - - path: the path to the files
-- - - opts?: options for the files
-- - - OR
-- - - a string with the path to the files
-- - extrafiles[]?: a list of extra files to be added to the project (not compiled, just for organization)
-- - - path: the path to the extra files
-- - - opts?: options for the extra files
-- - - OR
-- - - a string with the path to the extra files
-- - headerfiles[]?: a list of header files to be added to the project
-- - - path: the path to the files
-- - - opts?: options for the files
-- - - OR
-- - - a string with the path to the files
-- - deps[]?: a list of dependencies
-- - - name: the name of the dependency
-- - - opts?: options for the dependency
-- - - OR
-- - - a string with the name of the dependency
-- - packages[]?: a list of packages
-- - - name: the name of the package
-- - - opts?: options for the package
-- - - OR
-- - - a string with the name of the package
-- - forceincludes[]?: a list of forceincludes
-- - - path: the path to the forceincludes
-- - - opts?: options for the forceincludes
-- - - OR
-- - - a string with the path to the forceincludes
-- - defines[]?: a list of defines
-- - - name: the name of the define
-- - - opts?: options for the define
-- - - OR
-- - - a string with the name of the define
-- - include_dirs[]?: a list of include directories
-- - - path: the path to the include directories
-- - - opts?: options for the include directories
-- - - OR
-- - - a string with the path to the include directories
-- - filegroups[]?: a list of file groups
-- - - name: the name of the file group
-- - - opts: options for the file group
-- - test?: test configuration (inherits from parent opts and can override/extend)
-- - - files[]: a list of test files to be added to the project (REQUIRED if test is defined)
-- - - - path: the path to the test files
-- - - - opts?: options for the test files
-- - - - OR
-- - - - a string with the path to the test files
-- - - include_dirs[]?: a list of include directories for test targets
-- - - - path: the path to the include directories
-- - - - opts?: options for the include directories
-- - - - OR
-- - - - a string with the path to the include directories
-- - - headerfiles[]?: a list of header files for test targets
-- - - filegroups[]?: a list of file groups for test targets
-- - - defines[]?: a list of defines for test targets
-- - - forceincludes[]?: a list of force includes for test targets
-- - - packages[]?: additional packages for test targets (boost-common is always included)
-- - - deps[]?: additional dependencies for test targets (parent target is always included)
-- - - callback?: a callback function for test targets
-- - - rules[]?: a list of additional rules for test targets
function project_utils:declare_target(opts)
    _declare_target(opts)

    if is_config("with-tests", true) then
        _add_tests(opts)
    end
end
