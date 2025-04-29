-- FEMM 4.2 LUA version 4.0
-- https://www.lua.org/manual/4.0/


root = "E:\\work\\cap-shielding\\FEMM\\"

inPath = root .. "scenes\\"
bmpPath = root .. "plots\\closeups\\"

--constants
legend = 0
grid = 0
points = 0
names = 0
equipotentialLines = 1

voltage = 0
magD = 1
magE = 2

minV = 0
maxV = 1.2

minE = 0
maxE = 1200

plotPoints = 1500

width_sensor = 12
electrode_dist = 0.5

t_insulation    = 0.01
d_i             = 0.15

dx = 0
dy = -0.25
window_w = 10
window_h = 3

function floor( val )
    s = tostring( val )
    gs = gsub( s, "%..*", "" )
    n = tonumber( gs )
    return n
end

n_sensor = floor( width_sensor / electrode_dist ) + 1
sensor0_x = (-(n_sensor-1)/2)*electrode_dist
sensor0_y = -d_i/2-t_insulation

function prepare()
	ei_analyze()
	ei_loadsolution()
end

function showAndSave(name)

	--analyze and show reaults:
	eo_zoom(dx + sensor0_x - window_w / 2, dy + sensor0_y - window_h / 2, dx + sensor0_x + window_w / 2, dy + sensor0_y + window_h / 2)

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
