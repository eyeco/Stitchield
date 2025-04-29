-- =============================================================================
-- The following directives assign pins to the locations specific for the
-- PSoC 4200 device.
-- =============================================================================

-- === CapSense ===
attribute port_location of \CapSense:Cmod(0)\ : label is "PORT(4,2)";
attribute port_location of \CapSense:Sns(0)\ : label is "PORT(1,1)";


-- === I2C ===
attribute port_location of \EZI2C:scl(0)\ : label is "PORT(3,0)";
attribute port_location of \EZI2C:sda(0)\ : label is "PORT(3,1)";