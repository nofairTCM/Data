local optionList = {
    -- name
    ["-n"] = "name";
    ["--name"] = "name";

    -- info
    ["-i"] = "info";
    ["--info"] = "info";

    -- help
    ["-h"] = "help";
    ["--help"] = "help";
}
local option = {};
local arg = {};
local lastOpt;

local strSub = string.sub;
local tableInsert = table.insert;
for i,this in ipairs(args) do
    if i >= 1 then
        if lastOpt then -- set option
            option[lastOpt] = this;
            lastOpt = nil;
        elseif strSub(this,1,1) == "-" then -- this = option
            local optName = optionList[this];
            if not optName then
                error("option %s was not found, -h for see info");
            end
            option[optName] = true;
            lastOpt = optName;
        else
            tableInsert(arg,this);
        end
    end
end

-- print args
for i,v in pairs(arg) do
    print(i,v);
end
for i,v in pairs(option) do
    print(i,v);
end

if option.help then
    print("luvit moduleUpdate [Module Name] [Option]\n  list of options :\n    --info (-i) : information file pos\n    --help (-h) : show help comment\n");
    os.exit(0);
elseif not option.info then
    error("info file was not found");
elseif not option.name then
    error("name was not found");
end

local fileSy = require("db.app.file");
local DBHandle = require("db.app.DBHandle");
local json = require("json")

DBHandle
    :setFileLoad(fileSy.fileLoad)
    :setFileSave(fileSy.fileSave)
    :setJson(json);

DBHandle.update(option.name,json.decode(fileSy.fileLoad(option.info)));

os.exit(0);