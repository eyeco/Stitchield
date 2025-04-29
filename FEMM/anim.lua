-- FEMM 4.2 LUA version 4.0
-- https://www.lua.org/manual/4.0/


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

d_finger        = 5
t_insulation    = 0.01

frames = 40

groupID = 1

plotPoints = 1500

badgeTex_thickness = 0.9
y0 = 10 + badgeTex_thickness

moveY = (y0 - badgeTex_thickness) / frames

j = 0

root = "E:\\work\\cap-shielding\\FEMM\\"
inPath =  root .. "scenes\\"
bmpPath = root .. "plots\\anim\\"
txtPath = root .. "txt\\anim\\"

function prepare()
	ei_analyze()	--NOTE: this apparently saves the FEE file!!
	ei_loadsolution()
end

function showAndSave(a,y,name)

	--analyze and show results:
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

	eo_showdensityplot(legend,0,voltage,maxV,minV)

	basename = name .. format("-%02d",a)
	
	--save screenshot
	--NOTE: if this gives you trouble (error message "critical error on getting bmp info, possible page fault: ahoy12") the path length may be 
	--  a problem, maybe it is too long (mere speculation, however, after changing to "C:\\temp\\", it suddenly worked for me)
	eo_savebitmap(bmpPath .. "V-" .. basename .. ".bmp")
	
	eo_showdensityplot(legend,0,magE,maxE,minE)

	if equipotentialLines == 1 then
        eo_showcontourplot(19,0,maxV)
    end

	--save screenshot
	--NOTE: if this gives you trouble (error message "critical error on getting bmp info, possible page fault: ahoy12") the path length may be 
	--  a problem, maybe it is too long (mere speculation, however, after changing to "C:\\temp\\", it suddenly worked for me)
	eo_savebitmap(bmpPath .. "E-" .. basename .. ".bmp")

	eo_seteditmode("contour")
	eo_addcontour(0,0)
	eo_addcontour(0,y)	--TODO: for some reason, this position is a few mm below the finger in many instances (but not always). figure out why!

	eo_makeplot(4,plotPoints,txtPath .. basename .. ".txt",0)
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

	print("processing file " .. file .. ".FEE")
	
	--create working copy so we don't overwrite the original
	ei_saveas(inPath .. "_temp.FEE")

	y = y0

	--move finger to initial position
	print("moving finger by " .. tostring(y0-d_finger) .. " to initial position")
	ei_selectgroup(groupID)
	ei_movetranslate(0,y0-d_finger,4)

	prepare()
	showAndSave(0,y,file)

	for j=1,frames do
		
		--move finger downward by one step
		y = y - moveY

		print("translating finger by " .. tostring(-moveY) .. " to " .. tostring(y))
		ei_selectgroup(groupID)
		ei_movetranslate(0,-moveY,4)
		
		prepare()
		
		showAndSave(j,y,file)
	end

	--return finger to initial position
	print("returning finger to initial position " .. tostring(d_finger) .. " by translating by " .. tostring(d_finger-y))
	ei_selectgroup(groupID)
	ei_movetranslate(0,d_finger-y,4)

	--force save FEE file; make sure last translation is saved
	ei_analyze()

	y = y0

	ei_close()
	eo_close()

end
