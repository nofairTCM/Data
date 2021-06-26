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
            ["--this"] = "this";
        };
        execute = function (args,options)
            os.execute(("%s\\bin\\rojo.exe build %s -o %s"):format(options.this or "Package",options.project,options.output));
        end;
    };
    updateList = {
        options = {
            ["--info"] = "info"; -- info file path
            ["--name"] = "name"; -- name of module
            ["--verAdd"] = "verAdd";
            ["--this"] = "this";
        };
        execute = function (args,options)
            local info = json.decode(file.fileLoad(options.info));
            local list = json.decode(file.fileLoad(("%s\\packageList.json"):format(options.this or "Package")));

            local verAdd = options.verAdd;
            local name = options.name;
            if verAdd then
                info.publishVersion = info.publishVersion + 1;
                info.version = ("%d.%d.%d"):format(info.majorVersion,info.publishVersion,info.buildVersion);
            end

            local item = list[name];
            for i,v in pairs(info) do
                item[i] = v;
            end

            file.fileSave(("%s\\packageList.json"):format(options.this or "Package"),json.encode(list,{indent = true}));

            os.execute(
                "git config --global user.email \"41898282+github-actions[bot]@users.noreply.github.com\"" ..
                "&&git config --global user.name \"github-actions[bot]\"" ..
                ("&&git -C Package commit -m \"data base updated by github workflow (%s)\" -a"):format(name)
            );
        end;
    };
    upload = {
        options = {
            ["--project"] = "project"; -- project file path
            ["--assetId"] = "assetId"; -- asset id
            ["--cookie"] = "cookie"; -- RBLXTOKEN
            ["--this"] = "this";
        };
        execute = function (args,options)
            os.execute(("%s\\bin\\rojo.exe upload %s --asset_id %s --cookie \"%s\""):format(options.this or "Package",options.project,options.assetId,options.cookie));
        end;
    };
    uploadFromProjectInfo = {
        options = {
            ["--project"] = "project"; -- project file path
            ["--cookie"] = "cookie"; -- RBLXTOKEN
            ["--this"] = "this";
            ["--info"] = "info";
        };
        execute = function (args,options)
            local info = json.decode(file.fileLoad(options.info));
            os.execute(("%s\\bin\\rojo.exe upload %s --asset_id %s --cookie \"%s\""):format(options.this or "Package",options.project,info.toolboxID,options.cookie));
        end;
    };
};

local thisCommand = commands[commandName];
if not thisCommand then
    error(("Command %s found"):format(tostring(commandName)));
end

thisCommand.execute(commandArg(args,thisCommand.options));

--Package/packageList.json
