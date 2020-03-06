#define EEPROM_ADDRESS 0xA0

/* write a byte to the EEPROM */
void writeByte(int address, unsigned char data) {
i2c_start();
i2c_write(EEPROM_ADDRESS);
i2c_write(address >> 8);
i2c_write(address);
i2c_write(data);
i2c_stop();
}

/* read a byte from the EEPROM */
unsigned char readByte(int address) {
unsigned char data;                     
i2c_start();
i2c_write(EEPROM_ADDRESS);
i2c_write(address >> 8);
i2c_write(address);
i2c_start();
i2c_write(EEPROM_ADDRESS | 1);
data = i2c_read(0);
i2c_stop();

return data;
}


/*write up to 128 bytes*/

void writePage( int address, unsigned char *data, unsigned char len )
{
	int i;
	
	i2c_start();
    i2c_write(EEPROM_ADDRESS);
	i2c_write(address >> 8);	// MSB of address
	i2c_write(address);		// LSB of address

	// Write data
	for(i = 0; i < len; i++)
		i2c_write(*data++);
	
	i2c_stop();
} 

/* Reads sequential data from the specified address */
void readData( int address, unsigned char *data, int len )
{
	int i;

	i2c_start();
    i2c_write(EEPROM_ADDRESS);
	i2c_write(address >> 8);	// MSB of address
	i2c_write(address);		// LSB of address

	// Start reading
    i2c_start();
	i2c_write(EEPROM_ADDRESS | 1);
	for( i = 0; i < len; i++ )
        {
//		    if(i<len-1)
//            *data++ = i2c_read(1);	// Send ACK as long as read<len – i.e. we want another byte
//	        else
//            *data++ = i2c_read(0);
            *data++ = i2c_read(i<len-1);
        }
	i2c_stop();
}


                               