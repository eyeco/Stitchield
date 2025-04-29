-- =============================================================================
-- The following directives assign pins to the locations specific for the
-- PSoC 4200 - BLE device.
-- =============================================================================

-- === CapSense ===
attribute port_location of \CapSense:Cmod(0)\ : label is "PORT(4,0)";
attribute port_location of \CapSense:Sns(0)\ : label is "PORT(2,1)";


-- === I2C ===
attribute port_location of \EZI2C:scl(0)\ : label is "PORT(3,5)";
attribute port_location of \EZI2C:sda(0)\ : label is "PORT(3,4)";