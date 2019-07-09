json = loadfile('dkjson.lua')()

local raw_input_dir = './raw_input'
local json_output_dir = './json_output'

--print(gamedata)
--print(json.encode(gamedata))

-- Lua implementation of PHP scandir function
-- https://stackoverflow.com/questions/5303174/how-to-get-list-of-directories-in-lua
function scandir(directory)
    local i, t, popen = 0, {}, io.popen
    local pfile = popen('dir /b "'..directory..'"')
    for filename in pfile:lines() do
        i = i + 1
        t[i] = filename
    end
    pfile:close()
    return t
end

function split(str,separator) 
    local splitted = {}
    local match_count = 0
     for w in string.gmatch(str, '([^'..separator..']+)') do
       splitted[match_count] = w
       match_count  = match_count + 1
     end
     return splitted
end

function getFileSize(fullFilePath)
  local file = io.open(fullFilePath, "r")
  local filesize = file:seek("end");
  io.close(file);
  return filesize;
end

function saveJsonFile(filename,content)
  local file = io.open(filename, "w+")
  io.output(file)
  io.write(content)
  io.close(file)
end

function getInputPath(filename)
  return raw_input_dir..'/'..filename
end
  
function getOutputPath(filename)
  return json_output_dir..'/'..filename..'.json'
end
  



---------------
-- Init scan --
---------------
table_list = scandir(raw_input_dir)

-- Check files validity
for key,value in pairs(table_list) do
  fname = split(value,'.')
  
  gamedata = loadfile(raw_input_dir..'/'..value)()
  if gamedata == nil then
    --error('> Nil file is found: '..value,0)
    print('> Nil file is found: '..value)
  else
    
  end  
end

-- Process each files
print('--',"Parsing starts",'--')
for key,value in pairs(table_list) do
  print(key,value)
  
  local fname = split(value,'.')
  local filename = fname[0]
  
  local inputPath = getInputPath(value)  
  local outputPath = getOutputPath(filename)
  
  gamedata = json.encode(loadfile(inputPath)())
  saveJsonFile(outputPath,gamedata)
end

print('--',"Parsing ends",'--')



-- Compare output/input size
print('--',"Checking filesize starts",'--')
for key,value in pairs(table_list) do
  local fname = split(value,'.')
  local filename = fname[0]
  
  local inputPath = getInputPath(value)
  local outputPath = getOutputPath(filename)  
  
  local inputsize = getFileSize(inputPath)
  local outputsize = getFileSize(outputPath)
  
  if outputsize*5 < inputsize then
    print('> Output size is too small ',outputsize..'/'..inputsize,filename)
  end
end
print('--',"Checking filesize ends",'--')