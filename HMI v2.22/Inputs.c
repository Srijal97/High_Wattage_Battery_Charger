//#include <variables.h>



void input(int next)                         //next recieves value no of options we will have in the next menu
{   
    Pt = Pointer_vert;
    pointer_display_vert();
    delay_ms(100);
    if (PINE.7 == 0)                                            //UP
       {
        while(PINE.7 == 0);
        Pt--;
        Pointer_vert = ((Pt < 0) ? (next+Pt): Pt) % next;
        pointer_display_vert();
       }
                                    
    if (PINE.5 == 0)                                            //DOWN
       {
        while(PINE.5 == 0);
        Pointer_vert++;
        Pointer_vert = Pointer_vert % next;        
        pointer_display_vert();
       }
       
    if (PINB.3 == 0)                                            //ENTER
       {
        while(PINB.3 == 0);
        if(Screen < 10)
        {
            Screen = ((Screen+1)*10) + Pointer_vert;
        }            
        else
        {
            Screen = ((Screen)*10) + Pointer_vert;
        }
        
               
       }
       
    if (PIND.2 == 0)                                            //ESCAPE
       {
        while(PIND.2 == 0);  
           
            if (Screen == 2)
            {   
              main_screen_trigger = 1;
              current_mainscreen_flag = 1;
              Current_Screen = 0;
              set_flag = 1; 
            }                        
            else if(Screen > 100)
            {
                Screen = Screen/10;
            }
            else                
            {
                Screen = (Screen/10)-1;
            }
        
        
       }  
                       
}


void input_volt(int next)
{   
    int change = pow(10,(next-Pointer_horiz-1));
    pointer_display_horiz();
    delay_ms(100);
    if (PINE.7 == 0)                                            //UP     1
       {
        while(PINE.7 == 0);  
        if(change == 1)
        {temp_voltage = temp_voltage + (change);}
        else
        {temp_voltage = temp_voltage + 1 + (change);}
        temp_voltage = temp_voltage % 1000;
        show_volt();      
        pointer_display_horiz();
       }
                                    
    if (PINE.5 == 0)                                            //Next   2
       {
        while(PINE.5 == 0);
        Pointer_horiz++;
        
        Pointer_horiz = Pointer_horiz % next;        
        pointer_display_horiz();
       }
       
    if (PINB.3 == 0)                                             //ENTER 3
        {  
         while(PINB.3 == 0);
         if(110 <= temp_voltage && temp_voltage <= 135)
         { 
         
            lcd_clear();
            lcd_gotoxy(0,0);
            lcd_puts("Voltage set to:");  
            lcd_gotoxy(4,1);
            lcd_putsf("V");
            show_volt();
            set_voltage = temp_voltage;
            flag = 11; 
            Screen = 30;
            
            xmitString("<014-"); 
                        
            putchar(temp_voltage/1000 + 48);
            temp_voltage %= 1000;
            putchar(temp_voltage/100 + 48);
            temp_voltage %= 100;
            putchar(temp_voltage/10 + 48);
            temp_voltage %= 10;
            putchar(temp_voltage + 48);
            temp_voltage = 0;
            
            putchar('>');
            
            delay_ms(500);
            //txSetVoltage(set_voltage);
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
            temp_voltage = 000;
            Screen = 30;
            flag = 11; 
            delay_ms(1000); 
         } 
                       
        }  
        
    if (PIND.2 == 0)                                            //ESCAPE 4
       {
        while(PIND.2 == 0);    
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
    if (PINE.7 == 0)                                            //UP     1
       {
        while(PINE.7 == 0);  
        if(change == 1)
        {temp_current = temp_current + (change);}
        else
        {temp_current = temp_current + 1 + (change);}
        temp_current = temp_current % 1000;
        show_current();      
        pointer_display_horiz();
       }
                                    
    if (PINE.5 == 0)                                            //Next   2
       {
        while(PINE.5 == 0);
        Pointer_horiz++;
        
        Pointer_horiz = Pointer_horiz % next;        
        pointer_display_horiz();
       }             

    if (PINB.3 == 0)                                             //ENTER 3
        {  
         while(PINB.3 == 0);
         if(10 <= temp_current && temp_current <= 20)
         { 
            lcd_clear();
            lcd_gotoxy(0,0);
            lcd_puts("Current set to:");
            lcd_gotoxy(3,1);
            lcd_putsf("A");
            show_current();
            set_current = temp_current;      
            flag = 11; 
            Screen = 30; 
           
          xmitString("<015-"); 
                        
            putchar(temp_current/1000 + 48);
            temp_current %= 1000;
            putchar(temp_current/100 + 48);
            temp_current %= 100;
            putchar(temp_current/10 + 48);
            temp_current %= 10;
            putchar(temp_current + 48);
            temp_current = 0;
            
            putchar('>');
           
            delay_ms(500);
            
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
            temp_current = 000;
            Screen = 30;
            flag = 11; 
            delay_ms(1000); 
         }               
        }  
       
    if (PIND.2 == 0)                                            //ESCAPE 4
       {
        while(PIND.2 == 0);    
        flag = 11;
        if(Screen > 100)
        {Screen = Screen/10;}
        else        
        {Screen = (Screen/10)-1;}
        //flag = 1;
       }
       
       
}


