//#include <variables.h>



void input(int next)                         //next recieves value no of options we will have in the next menu
{   //int next = 4;
    //int flag = 0;   
    Pt = Pointer_vert;
    pointer_display_vert();
    delay_ms(100);
    if (PINE.2 == 0)                                            //UP
       {
        while(PINE.2 == 0);
        Pt--;
        Pointer_vert = ((Pt < 0) ? (next+Pt): Pt) % next;
        pointer_display_vert();
       }
                                    
    if (PINE.3 == 0)                                            //DOWN
       {
        while(PINE.3 == 0);
        Pointer_vert++;
        Pointer_vert = Pointer_vert % next;        
        pointer_display_vert();
       }
       
    if (PINE.0 == 0)                                            //ENTER
       {
        while(PINE.0 == 0);
        if(Screen < 10)
        {
            Screen = ((Screen+1)*10) + Pointer_vert;
        }            
        else
        {
            Screen = ((Screen)*10) + Pointer_vert;
        }
        
        //flag = 1;       
       }
       
    if (PINE.1 == 0)                                            //ESCAPE
       {
        while(PINE.1 == 0);                               
        if(Screen > 100)
        {Screen = Screen/10;}
        else                
        {
        Screen = (Screen/10)-1;
        }
        //flag = 1;
       }              
       
    //return (flag);   
}


void input_volt(int next)
{   
    int change = pow(10,(next-Pointer_horiz-1));
    pointer_display_horiz();
    delay_ms(100);
    if (PINE.2 == 0)                                            //UP     1
       {
        while(PINE.2 == 0);  
        if(change == 1)
        {voltage = voltage + (change);}
        else
        {voltage = voltage + 1 + (change);}
        voltage = voltage % 1000;
        show_volt();      
        pointer_display_horiz();
       }
                                    
    if (PINE.3 == 0)                                            //Next   2
       {
        while(PINE.3 == 0);
        Pointer_horiz++;
        
        Pointer_horiz = Pointer_horiz % next;        
        pointer_display_horiz();
       }
       
    if (PINE.0 == 0)                                             //ENTER 3
        {  
         while(PINE.0 == 0);
         if(110 <= voltage && voltage <= 135)
         { 
            lcd_clear();
            lcd_gotoxy(0,0);
            lcd_puts("Voltage set to:");
            show_volt();      
            //Voltage = temp_volt; 
            flag = 11; 
            Screen = 30; 
            delay_ms(2000);
         }
         else
         {
            lcd_clear();   
            lcd_gotoxy(0,0);
            lcd_putsf("Set value should");
            lcd_gotoxy(0,1);
            lcd_putsf("be between 110-");
            lcd_gotoxy(0,2);
            lcd_putsf("135 volts");
            voltage = 000;
            Screen = 300;
            flag = 11; 
            delay_ms(2000); 
         }               
        }  
        
    if (PINE.1 == 0)                                            //ESCAPE 4
       {
        while(PINE.1 == 0);    
        flag = 11;
        if(Screen > 100)
        {Screen = Screen/10;}    
        else        
        {Screen = (Screen/10)-1;}
        //flag = 1;
       }
}

void input_current(int next)
{
    int change = pow(10,(next-Pointer_horiz-1));
    pointer_display_horiz();
    delay_ms(100);
    if (PINE.2 == 0)                                            //UP     1
       {
        while(PINE.2 == 0);  
        if(change == 1)
        {current = current + (change);}
        else
        {current = current + 1 + (change);}
        current = current % 1000;
        show_current();      
        pointer_display_horiz();
       }
                                    
    if (PINE.3 == 0)                                            //Next   2
       {
        while(PINE.3 == 0);
        Pointer_horiz++;
        
        Pointer_horiz = Pointer_horiz % next;        
        pointer_display_horiz();
       }             

    if (PINE.0 == 0)                                             //ENTER 3
        {  
         while(PINE.0 == 0);
         if(10 <= current && current <= 20)
         { 
            lcd_clear();
            lcd_gotoxy(0,0);
            lcd_puts("Current set to:");
            show_current();      
            flag = 11; 
            Screen = 30; 
            delay_ms(2000);
         }
         else
         {
            lcd_clear();   
            lcd_gotoxy(0,0);
            lcd_putsf("Set value should");
            lcd_gotoxy(0,1);
            lcd_putsf("be between 10-");
            lcd_gotoxy(0,2);
            lcd_putsf("20 amps");
            current = 000;
            Screen = 301;
            flag = 11; 
            delay_ms(2000); 
         }               
        }  
       
    if (PINE.1 == 0)                                            //ESCAPE 4
       {
        while(PINE.1 == 0);    
        flag = 11;
        if(Screen > 100)
        {Screen = Screen/10;}
        else        
        {Screen = (Screen/10)-1;}
        //flag = 1;
       }
       
       
}
