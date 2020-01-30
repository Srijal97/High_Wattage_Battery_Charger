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
    sprintf(disp_volt,"%03d",voltage);
    lcd_gotoxy(0,1);
    lcd_puts(disp_volt);
}
void show_current()
{
    sprintf(disp_current,"%03d",current);
    lcd_gotoxy(0,1);
    lcd_puts(disp_current);
}
