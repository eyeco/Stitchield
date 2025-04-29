-- FEMM 4.2 LUA version 4.0
-- https://www.lua.org/manual/4.0/

root = "E:\\work\\cap-shielding\\FEMM\\"
inPath =  root .. "scenes\\"
bmpPath = root .. "plots\\"
txtPath = root .. "txt\\"


--constants
legend = 0
grid = 0
points = 0
names = 0
equipotentialLines = 0

voltage = 0
magD = 1
magE = 2

minV = 0
maxV = 1.2

minE = 0
maxE = 300

plotPoints = 1500

d_finger        = 5

function prepare()
	ei_analyze()
	ei_loadsolution()
end

function showAndSave(name)--a,y)

	--analyze and show reaults:
	--eo_zoomnatural()
	--eo_zoom(-5,-2,5,3)
	eo_zoom(-15,-5,15,13)

    if grid == 1 then
	    eo_showgrid()
    else
        eo_hidegrid()
    end

    if points == 1 then
        eo_showpoints()
    else
    	eo_hidepoints()
    end

	eo_shownames(names)

	postfix = ""
	if legend == 1 then
		postfix = "-lgd"
	end

	eo_showdensityplot(legend,0,voltage,maxV,minV)

	--save screenshot
	eo_savebitmap(bmpPath .. "V-" .. name .. postfix .. ".bmp")

	eo_showdensityplot(legend,0,magE,maxE,minE)

	if equipotentialLines == 1 then
        eo_showcontourplot(19,0,maxV)
    end

	--save screenshot
	eo_savebitmap(bmpPath .. "E-" .. name .. postfix .. ".bmp")

	eo_seteditmode("contour")
	eo_addcontour(0,0)
	eo_addcontour(0,d_finger)

	eo_makeplot(4,plotPoints,txtPath .. name .. ".txt",0)
end

files = {
    "0.50",
	"0.50-shielded",
	"0.50-arm",
	"0.50-arm-shielded",

	"1.00-arm-90",
	"1.00-arm-shielded-90",
	"0.75-arm-shielded-90",
	"0.50-arm-shielded-90",
	"0.25-arm-shielded-90"
}

for i = 1,getn(files) do
	file = files[i]
	open(inPath .. file .. ".FEE")

	prepare()
	showAndSave(file)

	ei_close()
	eo_close()
end
