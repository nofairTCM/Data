local module = {};

local json;
function module:setJson(newJson)
    json = newJson;
    return self;
end

local fileLoad;
function module:setFileLoad(newFileLoad)
    fileLoad = newFileLoad;
    return self;
end

local fileSave;
function module:setFileSave(newFileSave)
    fileSave = newFileSave;
    return self;
end

function module.update(moduleName,data)
    local DB = json.decode(fileLoad("db/data/main.json"));

    local this = DB[moduleName];
    if not this then
        error("Module %s was not found from db, pls manage module info to fix this error");
    end

    for i,v in pairs(data) do
        this[i] = v;
    end

    return fileSave("db/data/main.json",json.encode(DB,{indent = true}));
end

return module;