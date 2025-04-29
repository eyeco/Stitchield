#include "project.h"

#include "stdio.h"

int main()
{   
    // Enable global interrupts for CapSense operation
    CyGlobalIntEnable;
    
    //--- init uart communication
    UART_Start();
    
    // Start EZI2C block
    EZI2C_Start();
    
    // Set up communication data buffer to CapSense data structure to 
    // expose to I2C master at primary slave address request        
    EZI2C_EzI2CSetBuffer1(sizeof(CapSense_dsRam), sizeof(CapSense_dsRam),\
                         (uint8 *)&CapSense_dsRam);

    // Start CapSense block - Initializes CapSense data structure and 
    // performs first scan of all widgets/sensors to set up sensors
    // baselines 
    CapSense_Start();
    
    uint16 rawCapCount;
    
    // Configure button sensor parameters and connect it to AMUXBUS
    CapSense_CSDSetupWidgetExt(CapSense_BUTTON0_WDGT_ID, CapSense_BUTTON0_SNS0_ID);
    
    char tempStr[1024];
    
    while( 1 )
    {
        // Process all widgets
        CapSense_ProcessAllWidgets();
                   
        // To sync with Tuner application
        CapSense_RunTuner(); 
        
        // Start next scan
        CapSense_ScanAllWidgets(); 
        
        // aquire sensor value
        rawCapCount = CapSense_BUTTON0_SNS0_RAW0_VALUE;    //sensor raw counts
        
        // send data        
        sprintf(tempStr, "r:%d\n", 
            rawCapCount
        );
        UART_UartPutString(tempStr);
        
#if (CapSense_TST_SNS_CAP_EN == CapSense_ENABLE)      
    
        // get raw capacitance
    
        CapSense_TST_MEASUREMENT_STATUS_ENUM status_s = CapSense_TST_MEASUREMENT_SUCCESS;
    
        uint32 C_s = CapSense_GetSensorCapacitance(CapSense_BUTTON0_WDGT_ID, CapSense_BUTTON0_SNS0_ID, &status_s); //Returns the capacitance of a sensor element in femtofarads
        if(status_s != CapSense_TST_MEASUREMENT_SUCCESS) // If measurementStatus is not equal to CapSense_TST_MEASUREMENT_SUCCESS, a fail occurs and the returned capacitance should be ignored.
            C_s = 0;

        // external C_mod capacitor (mandatory for CSD, 2.2nF recommended)
        uint32 C_mod = CapSense_GetExtCapCapacitance(CapSense_TST_CMOD_ID); // Returns a status of the test execution: The capacitance (in pF) of the specified external capacitor; CapSense_TST_BAD_PARAM if the input parameter is invalid.
        if(C_mod == CapSense_TST_BAD_PARAM)
            C_mod = 0;
        
#if (CapSense_TST_SH_CAP_EN == CapSense_ENABLE)
    
        // shield electrode(s) capacitance
    
        CapSense_TST_MEASUREMENT_STATUS_ENUM status_sh = CapSense_TST_MEASUREMENT_SUCCESS;
    
        uint32 C_sh = CapSense_GetShieldCapacitance(&status_sh); //Returns the capacitance of a shield in femtofarads.
        if(status_sh != CapSense_TST_MEASUREMENT_SUCCESS) // If measurementStatus is not CapSense_TST_MEASUREMENT_SUCCESS, the returned value should be ignored.
            C_sh = 0;

        // external shield tank capacitor (optional for driven shield, 10nF recommended)
        uint32 C_sh_tank = CapSense_GetExtCapCapacitance(CapSense_TST_CSH_ID); // Returns a status of the test execution: The capacitance (in pF) of the specified external capacitor; CapSense_TST_BAD_PARAM if the input parameter is invalid.
        if(C_sh_tank == CapSense_TST_BAD_PARAM)
            C_sh_tank = 0;
#else
        uint32 C_sh = 0;
        uint32 C_sh_tank = 0;
#endif // (CapSense_TST_SH_CAP_EN == CapSense_ENABLE)

        // send data        
        sprintf(tempStr, "cs:%lu\ncm:%lu\ncsh:%lu\ncsht:%lu\n",
            (status_s == CapSense_TST_MEASUREMENT_SUCCESS ? C_s : -1 ),
            C_mod,
            (status_sh == CapSense_TST_MEASUREMENT_SUCCESS ? C_sh : -1 ),
            C_sh_tank
        );
        UART_UartPutString(tempStr);

#endif //(CapSense_TST_SNS_CAP_EN == CapSense_ENABLE)
    }  
}


// [] END OF FILE
