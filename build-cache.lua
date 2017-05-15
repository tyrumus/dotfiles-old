require("lfs")
local iconSize = 32
local appCachePath = "/home/legostax/.config/awesome/app-cache.txt"
local gtkPyPath = "/home/legostax/.config/awesome/gtk-icon.py"
local desktopFilePaths = {
    "/home/legostax/Desktop/",
    "/usr/share/applications/"
}
local desktopFileList = {}
-- reads file line by line and returns a table
local function readFile(path)
    local data = {}
    for line in io.lines(path) do
        table.insert(data, line)
    end
    return data
end
local function getIconPath(icon)
    local handle = io.popen(gtkPyPath.." "..icon.." "..iconSize)
    local result = handle:read("*a")
    handle:close()
    return string.sub(result, 1, result:len()-1)
end
local function processDesktopFile(data)
    local d = {}
    local start = false
    for i = 1,#data do
        if data[i] == "[Desktop Entry]" then
            start = true
        end
        if start then
            if string.find(data[i], "Name=") and d.name == nil then
                d.name = string.sub(data[i], 6)
            elseif string.find(data[i], "Exec=") and d.exec == nil and not string.find(data[i], "TryExec=") then
                d.exec = string.sub(data[i], 6)
            elseif string.find(data[i], "Icon=") and d.icon == nil then
                d.icon = getIconPath(string.sub(data[i], 6))
            end
            if d.name ~= nil and d.exec ~= nil and d.icon ~= nil then break end
        end
    end
    if d.icon == nil then
        d.icon = "$dne"
    elseif d.icon == "0" then
        d.icon = "$dne"
    end
    return d
end
local function listDesktopFiles(path)
    for file in lfs.dir(path) do
        if file ~= "." and file ~= ".." and string.sub(file, -8) == ".desktop" then
            table.insert(desktopFileList, path..file)
        end
    end
end

-- get list of .desktop files
print("building list of .desktop files")
for i = 1,#desktopFilePaths do
    listDesktopFiles(desktopFilePaths[i])
end
-- write .desktop files to app-cache.txt
print("processing and writing list to cache...")
file, err = io.open(appCachePath, "w")
for i = 1,#desktopFileList do
    local entry = processDesktopFile(readFile(desktopFileList[i]))
    --print("Entry: "..desktopFileList[i])
    file:write("[Entry]\n")
    file:write(entry.name.."\n")
    file:write(entry.exec.."\n")
    file:write(entry.icon.."\n")
end
file:close()
print("job complete.")
