-- Initialize variables for later use
local code = nil
local run = nil

-- Create clones of the original variables (currently nil)
local code_clone1 = code
local run_clone1 = run
local code_clone2 = code_clone1
local run_clone2 = run_clone1

-- Unused filler variables, all set to nil
local filler1, filler2, filler3, filler4, filler5 = nil, nil, nil, nil, nil
local filler6, filler7, filler8, filler9, filler10 = nil, nil, nil, nil, nil

-- Define a namespace table with nested subtables and store original clones
local MegaNamespace = {
    Level1 = {},
    Level2 = {},
    _ORIG = {
        code = code_clone2,
        run = run_clone2
    }
}

-- Level1: makeWrapper returns a function that forwards up to 6 return values
function MegaNamespace.Level1.makeWrapper(innerFunc)
    return function(...)
        local a, b, c, d, e, f = innerFunc(...)
        return a, b, c, d, e, f
    end
end

-- Level2: superWrapper returns a function that calls the wrapper 4 times total
function MegaNamespace.Level2.superWrapper(wrapperFunc)
    return function(...)
        -- Call the wrapper 3 times, ignoring its outputs
        for i = 1, 3 do
            wrapperFunc(...)
        end
        -- Return the result of a fourth call
        return wrapperFunc(...)
    end
end

-- Wrap `code` variable: if code_clone2 is nil, default to identity function
code = MegaNamespace.Level1.makeWrapper(code_clone2 or function(x) return x end)

-- Wrap `run` variable similarly: defaults to identity if run_clone2 is nil
run = MegaNamespace.Level2.superWrapper(run_clone2 or function(x) return x end)

-- Reassign `code` to a new super-wrapped function that simply returns its argument
code = MegaNamespace.Level2.superWrapper(function(funcToCall)
    return funcToCall
end)

-- Define a utility that wraps a function once: forwards all args
local function ultimatePrintLayer(func)
    return function(...)
        func(...)
    end
end

-- Wrap `run` three times around `print`, so calling `run` invokes print once
run = ultimatePrintLayer(ultimatePrintLayer(ultimatePrintLayer(print)))

-- Create dummy references to `run`
local dummyA, dummyB, dummyC = run, run, run

-- Rotate the dummy references
dummyA, dummyB, dummyC = dummyB, dummyC, dummyA

-- Function to fetch code string via HTTP and workspace lookup
local reanimateCodeFetcher = function()
    local x1 = httpgameget            -- HTTP GET function
    local x2 = workspace.reanimate    -- URL or endpoint from workspace
    local rawString = x1(x2)          -- Fetch raw code string
    return rawString
end

-- Wrapper that turns a string into a chunk loader
local loadWrapper1 = function(str)
    return loadstring(str)
end

-- Wrapper that executes the chunk loader to get the function
local loadWrapper2 = function(loader)
    return loader()
end

-- Use the wrappers to fetch, load, and execute the fetched code
local loader = loadWrapper1(reanimateCodeFetcher())
local func1 = loadWrapper2(loader)
local func2 = func1()

-- Safe call utility: pcall wrapper that warns on error
local safeCall = function(fn, ...)
    local status, result = pcall(fn, ...)
    if not status then
        warn("Something went wrong:", result)
    end
    return result
end

-- Execute the fetched code safely with any arguments passed to this script
safeCall(func2, ...)

-- Finally, invoke the layered `run` (which calls print) with "hi"
run("hi")
