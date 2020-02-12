//ThermoInit(void);
/*
/*
 *  Define literals for the SPI port accesses and the thermocouple chip
 *  select line.
 */
#define  PORT_THERMO_CS           PORTE
#define  DDR_THERMO_CS            DDRE
#define  BIT_THERMO_CS            3
#define  MASK_THERMO_CS           (1<<BIT_THERMO_CS)

#define  PORT_SPI                 PORTB
#define  DDR_SPI                  DDRB
#define  BIT_SPI_SCK              1
#define  MASK_SPI_SCK             (1<<BIT_SPI_SCK)
#define  BIT_SPI_SS               0
#define  MASK_SPI_SS              (1<<BIT_SPI_SS)
#define  BIT_SPI_MISO             3
#define  MASK_SPI_MISO            (1<<BIT_SPI_MISO)

/*
 *  ThermoInit      set up hardware for using the MAX31855
 *
 *  This routine configures the SPI as a master for exchanging
 *  data with the MAX31855 thermocouple converter.  All pins
 *  and registers for accessing the various port lines are
 *  defined at the top of this code as named literals.
 */
/*
void  ThermoInit(void)
{
    PORT_THERMO_CS |= MASK_THERMO_CS;        // start with CS high
    DDR_THERMO_CS |= MASK_THERMO_CS;         // now make that line an output

    PORT_SPI |= MASK_SPI_SS;                 // SS* is not used but must be driven high
    DDR_SPI |= MASK_SPI_SS;                  // SS* is not used but must be driven high
    PORT_SPI &= ~MASK_SPI_SCK;               // drive SCK low
    DDR_SPI |= MASK_SPI_SCK;                 // now make SCK an output

    SPCR = (1<<SPE) | (1<<MSTR) | (1<<SPR0) | (1<<SPR1) | (1<<CPHA);
                                             // enable SPI as master, slowest clock,
                                             // data active on trailing edge of SCK
}


/*
 *  ThermoReadRaw      return 32-bit raw value from MAX31855
 *
 *  This routine uses a four-byte SPI exchange to collect a
 *  raw reading from the MAX31855 thermocouple converter.  That
 *  value is returned unprocessed to the calling routine.
 *
 *  Note that this routine does NO processing.  It does not
 *  check for error flags or reasonable data ranges.

//  d = 0x01900000;            // thermocouple = +25C, reference = 0C, no faults
//  d = 0xfff00000;            // thermocouple = -1C, reference = 0C, no faults
//  d = 0xf0600000;            // thermocouple = -250C, reference = 0C, no faults
//  d = 0x00010001;            // thermocouple = N/A, reference = N/A, open fault
//  d = 0x00010002;            // thermocouple = N/A, reference = N/A, short to GND
//  d = 0x00010004;            // thermocouple = N/A, refernece = N/A, short to VCC
*/

/*
signed int  ThermoReadRaw (void)
{
    signed int                   d;
    unsigned char                n;

    PORT_THERMO_CS &= ~MASK_THERMO_CS;    // pull thermo CS low
    d = 0;                                // start with nothing
    for (n=3; n!=0xff; n--)
    {
        SPDR = 0;                         // send a null byte
        while ((SPSR & (1<<SPIF)) == 0)  ;    // wait until transfer ends
        d = (d<<8) + SPDR;                // add next byte, starting with MSB
    }
    PORT_THERMO_CS |= MASK_THERMO_CS;     // done, pull CS high
    return  d;
}

/*
 *  ThermoReadC      return thermocouple temperature in degrees C
 *
 *  This routine takes a raw reading from the thermocouple converter
 *  and translates that value into a temperature in degrees C.  That
 *  value is returned to the calling routine as an integer value,
 *  rounded.
 *
 *  The thermocouple value is stored in bits 31-18 as a signed 14-bit
 *  value, where the LSB represents 0.25 degC.  To convert to an
 *  integer value with no intermediate float operations, this code
 *  shifts the value 20 places right, rather than 18, effectively
 *  dividing the raw value by 4 and scaling it to unit degrees.
 *
 *  Note that this routine does NOT check the error flags in the
 *  raw value.  This would be a nice thing to add later, when I've
 *  figured out how I want to propagate the error conditions...
 */  
 /*
int  ThermoReadC(void)
{
    signed int d;
    int neg;


    neg = 0;                    // assume a positive raw value
    d = ThermoReadRaw();        // get a raw value
    d = ((d >> 10) & 0x3fff);   // leave only thermocouple value in d
    if (d & 0x2000)             // if thermocouple reading is negative...
    {
        d = -d & 0x3fff;        // always work with positive values
        neg = 1;                // but note original value was negative
    }
    d = d + 2;                  // round up by 0.5 degC (2 LSBs)
    d = d >> 2;                 // now convert from 0.25 degC units to degC
    if (neg)  d = -d;           // convert to negative if needed
    return  d;                  // return as integer
}
   */

/*
 *  ThermoReadF      return thermocouple temperature in degrees F
 *
 *  This routine takes a reading from the thermocouple converter in
 *  degC and converts it to degF.
 *
 *  Note that this routine simply calls ThermoReadC and converts
 *  from degC to degF using integer math.  This routine does not
 *  see the raw converter value and cannot do any error checking.
 */
/*int  ThermoReadF(void)
{
    int t;

    t = ThermoReadC();           // get the value in degC
    t = ((t * 90) / 50) + 32;    // convert to degF
    return  t;                   // all done
}*/


