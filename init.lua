--- 패키지 메니저

local json = require("json");
local file = require("file");
local commandArg = require("commandArg");

local commandName = args[2];
table.remove(args,2);

local commands = {
    build = {
        options = {
            ["--project"] = "project"; -- project file path
            ["--output"] = "output"; -- output file path
        };
        execute = function (args,options)
            os.execute(("Package\\bin\\rojo.exe build %s -o %s"):format(options.project,options.output));
        end;
    };
    updateList = {
        options = {
            ["--info"] = "info"; -- info file path
            ["--name"] = "name"; -- name of module
        };
        execute = function (args,options)
            local info = json.decode(file.fileLoad(options.info));
            local list = json.decode(file.fileLoad("Package\\packageList.json"));

            local item = list[options.name];
            for i,v in pairs(info) do
                item[i] = v;
            end

            file.fileSave("Package\\packageList.json",json.encode(list));
        end;
    };
    upload = {
        options = {
            ["--project"] = "project"; -- project file path
            ["--assetId"] = "assetId"; -- asset id
            ["--cookie"] = "cookie"; -- RBLXTOKEN
        };
        execute = function (args,options)
            os.execute(("Package\\bin\\rojo.exe upload %s --asset_id %s --cookie %s"):format(options.project,options.assetId,options.cookie));
        end;
    };
};

local thisCommand = commands[commandName];
if not thisCommand then
    error(("Command %s found"):format(tostring(commandName)));
end

thisCommand.execute(commandArg(args,thisCommand.options));

--Package/packageList.json