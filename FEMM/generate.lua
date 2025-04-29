-- FEMM 4.2 LUA version 4.0
-- https://www.lua.org/manual/4.0/

-- FEMM 4.2 LUA version 4.0
-- https://www.lua.org/manual/4.0/

root = "E:\\work\\cap-shielding\\FEMM\\"
outPath = root .. "scenes\\"

--constants
t_insulation    = 0.01
d_i             = 0.15

width_sensor = 10
width_shield = 20

sensor_shield_offset = 0.01

arm_width       = 50
arm_thickness   = 4
arm_offset      = 1 --0.01 --0

r_finger = 8
h_finger = 15
d_finger = 5
finger_group_ID = 1

V_ref = 1.2

conductor   = "Copper"
insulator   = "Enamel"
air         = "Air"
skin        = "Skin"

relperm_conductor   = 1.0
relperm_insulator   = 3.5
relperm_air         = 1.0
relperm_skin        = 10000

low     = "low"
high    = "high"

iabc_shells = 7
iabc_r      = 60
iabc_x      = 0
iabc_y      = 10
iabc_method = 1 -- 0: Dirichlet
                -- 1: Neumann

r_i = d_i/2
d_o = d_i+2*t_insulation
r_o = d_o/2

function floor( val )
    s = tostring( val )
    gs = gsub( s, "%..*", "" )
    n = tonumber( gs )
    return n
end

function createArm(x0,y0,x1,y1)
    ei_addnode(x0,y0)
    ei_addnode(x1,y0)
    ei_addnode(x1,y1)
    ei_addnode(x0,y1)

    ei_addsegment(x0,y0,x1,y0)
    ei_addsegment(x1,y0,x1,y1)
    ei_addsegment(x1,y1,x0,y1)
    ei_addsegment(x0,y1,x0,y0)
    
    ei_clearselected()
    ei_selectsegment((x0+x1)/2,y0)
    ei_selectsegment(x1,(y0+y1)/2)
    ei_selectsegment((x0+x1)/2,y1)
    ei_selectsegment(x0,(y0+y1)/2)
    ei_setsegmentprop("<None>", 0, 1, 0, 0, low)

    ei_addblocklabel((x0+x1)/2,(y0+y1)/2)

    ei_clearselected()
    ei_selectlabel((x0+x1)/2,(y0+y1)/2)
    ei_setblockprop(skin, 1, 0, 0)

    ei_clearselected()
end

function createFinger(x,y,r,h)
    ei_addnode(x-r,y)
    ei_addnode(x+r,y)
    ei_addnode(x-r,y+h)
    ei_addnode(x+r,y+h)

    ei_addarc(x-r,y,x+r,y,180)
    ei_addsegment(x+r,y+h,x-r,y+h)
    ei_addsegment(x-r,y,x-r,y+h)
    ei_addsegment(x+r,y,x+r,y+h)

    ei_clearselected()
    ei_selectarcsegment(x,y-r)
    ei_setarcsegmentprop(0, "<None>", 0, finger_group_ID, low)
    
    ei_clearselected()
    ei_selectsegment(x,y+h)
    ei_setsegmentprop("<None>", 0, 1, 0, finger_group_ID, low)

    ei_clearselected()
    ei_selectsegment(x-r,y+h/2)
    ei_setsegmentprop("<None>", 0, 1, 0, finger_group_ID, low)

    ei_clearselected()
    ei_selectsegment(x+r,y+h/2)
    ei_setsegmentprop("<None>", 0, 1, 0, finger_group_ID, low)

    ei_addblocklabel(x,y-r/2)

    ei_clearselected()
    ei_selectlabel(x,y-r/2)
    ei_setblockprop(skin, 1, 0, finger_group_ID)

    ei_clearselected()
end

function createCircularProfile(x,y,ri,ro,voltage)

    -- create copper core
    ei_addnode(x-ri,y)
    ei_addnode(x+ri,y)

    ei_addarc(x-ri,y,x+ri,y,180,1)
    ei_addarc(x+ri,y,x-ri,y,180,1)
    
    if voltage == 0 then
        label = low
    else
        label = high
    end

    ei_clearselected()
    ei_selectarcsegment(x,y-ri)
    ei_selectarcsegment(x,y+ri)
    ei_setarcsegmentprop(0, "<None>", 0, 0, label)

    ei_addblocklabel(x,y)
    
    ei_clearselected()
    ei_selectlabel(x,y)
    ei_setblockprop(conductor, 1, 0, 0)


    -- create insulation
    ei_addnode(x-ro,y)
    ei_addnode(x+ro,y)

    ei_addarc(x-ro,y,x+ro,y,180,1)
    ei_addarc(x+ro,y,x-ro,y,180,1)

    bx=x
    by=y+ri+(ro-ri)/2
    ei_addblocklabel(bx,by)
    
    ei_clearselected()
    ei_selectlabel(bx,by)

    ei_setblockprop(insulator, 1, 0, 0)

    ei_clearselected()
end

function createRectangularProfile(x,y,wi,hi,wo,ho,voltage)

    -- create copper core
    x0 = x-wi/2
    y0 = y+hi/2
    x1 = x+wi/2
    y1 = y-hi/2

    ei_addnode(x0,y0)
    ei_addnode(x1,y0)
    ei_addnode(x1,y1)
    ei_addnode(x0,y1)

    ei_addsegment(x0,y0,x1,y0)
    ei_addsegment(x1,y0,x1,y1)
    ei_addsegment(x1,y1,x0,y1)
    ei_addsegment(x0,y1,x0,y0)

    if voltage == 0 then
        label = low
    else
        label = high
    end

    ei_clearselected()
    ei_selectsegment((x0+x1)/2,y0)
    ei_selectsegment(x1,(y0+y1)/2)
    ei_selectsegment((x0+x1)/2,y1)
    ei_selectsegment(x0,(y0+y1)/2)
    ei_setsegmentprop("<None>", 0, 1, 0, 0, label)

    ei_addblocklabel(x,y)

    ei_clearselected()
    ei_selectlabel(x,y)
    ei_setblockprop(conductor, 1, 0, 0)

    -- create insulation
    x0 = x-wo/2
    y0 = y+ho/2
    x1 = x+wo/2
    y1 = y-ho/2

    ei_addnode(x0,y0)
    ei_addnode(x1,y0)
    ei_addnode(x1,y1)
    ei_addnode(x0,y1)

    ei_addsegment(x0,y0,x1,y0)
    ei_addsegment(x1,y0,x1,y1)
    ei_addsegment(x1,y1,x0,y1)
    ei_addsegment(x0,y1,x0,y0)

    bx=x
    by=y+hi/2+(ho-hi)/4
    ei_addblocklabel(bx,by)

    ei_clearselected()
    ei_selectlabel(bx,by)
    ei_setblockprop(insulator, 1, 0, 0)

    ei_clearselected()
end

function createBoundary()
    ei_makeABC(iabc_shells,iabc_r,iabc_x,iabc_y,iabc_method)
    ei_addblocklabel(arm_width / 2, 0)

    ei_clearselected()
    ei_selectlabel(arm_width / 2, 0)
    ei_setblockprop("Air", 1, 0, 0)

    ei_clearselected()
end

function generate(dist,rotated,parallel,shielded,arm)

    --set up document
    newdocument(1)
    ei_probdef("millimeters","planar",1.E-8)

    --define materials
    ei_addmaterial(conductor, relperm_conductor,  relperm_conductor, 0)
    ei_addmaterial(insulator, relperm_insulator,  relperm_insulator, 0)
    ei_addmaterial(air,       relperm_air,        relperm_air,       0)
    ei_addmaterial(skin,      relperm_skin,       relperm_skin,      0)

    --define conductors
    ei_addconductorprop(high, V_ref, 0, 1)
    ei_addconductorprop(low,      0, 0, 1)

    --create environment geometry
    if arm == 1 then
        if shielded == 1 then
            createArm(-arm_width/2,-d_o*2-sensor_shield_offset-arm_offset,arm_width/2,-d_o*2-arm_thickness-arm_offset)
        else
            createArm(-arm_width/2,-d_o-sensor_shield_offset-arm_offset,arm_width/2,-d_o-arm_thickness-arm_offset)
        end
    end

    createFinger(0,d_finger+r_finger,r_finger,h_finger)

    --create sensor electrode geometries
    if rotated == 1 then
        circular = 0
    else
        circular = 1
    end

    n_sensor = floor( width_sensor / dist ) + 1
    n_shield = floor( width_shield / dist ) + 1

    if circular == 1 then
        y = -r_o
        for i=0,n_sensor-1 do
            x=(i-(n_sensor-1)/2)*dist
            
            createCircularProfile(x,y,r_i,r_o,high_voltage)
        end
    else
        w_i = (n_sensor-1) * dist
        w_o = w_i + 2 * t_insulation
        y = -r_o
        createRectangularProfile(0,y,w_i,d_i,w_o,d_o,high_voltage)
    end

    if shielded == 1 then
        --create shield geometries
        if parallel == 0 then
            if rotated == 1 then
                circular = 1
            else
                circular = 0
            end
        end

        if circular == 1 then
            y = -r_o - d_o
            for i=0,n_shield-1 do
                x=(i-(n_shield-1)/2)*dist
                
                createCircularProfile(x,y - sensor_shield_offset,r_i,r_o,high_voltage)
            end
        else
            w_i = (n_shield-1) * dist
            w_o = w_i + 2 * t_insulation
            y = -r_o - d_o
            createRectangularProfile(0,y - sensor_shield_offset,w_i,d_i,w_o,d_o,high_voltage)
        end
    end

    --define bounding area
    createBoundary()

    ei_zoomnatural()


    name = format("%.2f",dist)

    if parallel == 1 then
        name = "P-" .. name
    end

    if arm == 1 then
        name = name .. "-arm"
    end

    if shielded == 1 then
        name = name .. "-shielded"
    end        

    if rotated == 1 then
        name = name .. "-90"
    end    

    filename = outPath .. name .. ".FEE"
    print("saving to " .. filename)
    ei_saveas(filename)

    ei_close()
end


-- generate args:
--    dist
--    rotated
--    parallel
--    shielded
--    arm

generate(  0.5,  0,  0,  0,  0 )
generate(  0.5,  0,  0,  0,  1 )
generate(  0.5,  0,  0,  1,  0 )
generate(  0.5,  0,  0,  1,  1 )

generate(  1.0,  1,  0,  0,  1 )
generate(  1.0,  1,  0,  1,  1 )
generate(  0.75, 1,  0,  1,  1 )
generate(  0.5,  1,  0,  1,  1 )
generate(  0.25, 1,  0,  1,  1 )