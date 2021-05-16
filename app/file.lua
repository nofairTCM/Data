---load file
---@param fileName string
---@return string
local function fileLoad(fileName)
    local file = io.open(fileName,"r");
    local str = file:read("a");
    file:close();
    return str;
end

---save file
---@param fileName string
---@param str string
---@return nil
local function fileSave(fileName,str)
    local file = io.open(fileName,"w");
    file:write(str);
    file:close();
    return;
end

return {
    fileLoad = fileLoad;
    fileSave = fileSave;
};