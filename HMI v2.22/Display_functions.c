//#include <variables.h>

void pointer_display_horiz()                          //checks the cursor position. 
{
    lcd_gotoxy(0,2);
    lcd_putsf(" ");
    lcd_gotoxy(1,2);
    lcd_putsf(" ");
    lcd_gotoxy(2,2);
    lcd_putsf(" ");
    lcd_gotoxy(3,2);
    lcd_putsf(" "); 
    lcd_gotoxy(4,2);
    lcd_putsf(" ");
    lcd_gotoxy(5,2);
    lcd_putsf(" ");
    lcd_gotoxy(6,2);
    lcd_putsf(" ");
    lcd_gotoxy(7,2);
    lcd_putsf(" ");
    lcd_gotoxy(8,2);
    lcd_putsf(" ");
    lcd_gotoxy(9,2);
    lcd_putsf(" ");
    lcd_gotoxy(10,2);
    lcd_putsf(" ");
    lcd_gotoxy(11,2);
    lcd_putsf(" ");
    lcd_gotoxy(Pointer_horiz,2);                      //Pointer displays arrow at that position
    lcd_putsf("^");
}

void pointer_display_vert()                          //checks the cursor position. 
{
    lcd_gotoxy(0,0);
    lcd_putsf(" ");
    lcd_gotoxy(0,1);
    lcd_putsf(" ");
    lcd_gotoxy(0,2);
    lcd_putsf(" ");
    lcd_gotoxy(0,3);
    lcd_putsf(" ");
    lcd_gotoxy(0,Pointer_vert);                      //Pointer displays arrow at that position
    lcd_putsf(">");
}



void show_volt()
{
    sprintf(disp_volt,"%03d",temp_voltage);
    lcd_gotoxy(0,1);
    lcd_puts(disp_volt);
}
void show_current()
{
    sprintf(disp_current,"%02d",temp_current);
    lcd_gotoxy(0,1);
    lcd_puts(disp_current);
}

void show_time()
{
    sprintf(disp_temp_time,"%02d:%02d:%02d",temp_hour,temp_minute,temp_second);
    lcd_gotoxy(0,1);
    lcd_puts(disp_temp_time);
}

void show_date()
{
    sprintf(disp_temp_date,"%02d/%02d/%02d",temp_date,temp_month,temp_year);
    lcd_gotoxy(0,1);
    lcd_puts(disp_temp_date);
}