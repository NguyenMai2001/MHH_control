/*
 * File:   final.c
 * Author: dtan
 *
 * Created on June 4, 2022, 8:49 AM
 */
#include <xc.h>
#include <stdint.h>

#pragma config FOSC = HS        // Oscillator Selection bits (XT oscillator)
#pragma config WDTE = OFF       // Watchdog Timer Enable bit (WDT disabled)
#pragma config PWRTE = ON       // Power-up Timer Enable bit (PWRT enabled)
#pragma config BOREN = ON       // Brown-out Reset Enable bit (BOR enabled)
#pragma config LVP = OFF        // Low-Voltage (Single-Supply) In-Circuit Serial Programming Enable bit (RB3 is digital I/O, HV on MCLR must be used for programming)
#pragma config CPD = OFF        // Data EEPROM Memory Code Protection bit (Data EEPROM code protection off)
#pragma config WRT = OFF        // Flash Program Memory Write Enable bits (Write protection off; all program memory may be written to by EECON control)
#pragma config CP = OFF         // Flash Program M
#define _XTAL_FREQ 20000000

//--------------------[ Servo ]-------------------------
#define WritePosOpenServo       RD0
#define OpenServo               RD1
#define SelectServo             RD2
#define WriteSelectServo        RD3

//--------------------[ LCD ]---------------------------
#define LCD_CLEAR               0x01
#define LCD_RETURN_HOME         0x02
#define LCD_TURN_ON             0x0C
#define LCD_TURN_OFF            0x08
#define LCD_SWAP                RD4

//PWM
#define Fpwm 3950 // tan so bam xung
#define ps 1 // prescaler = 1:1
/*------------------------------------------------khai bao ham-----------------------------------------------------*/

//servo
void Servo_Init();

// I2C 
void I2C_Master_Init();
void I2C_Master_Wait();
void I2C_Master_Start();
void I2C_Master_Stop();
void I2C_Master_Write(unsigned char data);

//LCD
void LCD_Init(unsigned char I2C_Add);
void IO_Expander_Write(unsigned char Data);
void LCD_Write_4Bit(unsigned char Nibble);
void LCD_CMD(unsigned char CMD);
void LCD_Write_Char(char Data);
void LCD_Write_String(char *Str);
void LCD_Set_Cursor(unsigned char ROW, unsigned char COL);
void LCD_Clear();

//PWM
void ADC_Init(); // config chan cho ADC
uint16_t ADC_Read(uint8_t ADC_channel); // doc du lieu ADC tu kenh
void init_PWM(); // config chan PWM
void setPWM_DutyCycle(uint16_t DC); 

//UART
void UART_send_char(char bt);
void UART_send_string(char* st_pt);
char UART_get_char() ;
void config_UART();

//EEPROM
uint8_t EEPROM_Read(uint8_t Address);
void EEPROM_Write(uint8_t Address, uint8_t Data);

/*-------------------------------------khai bao bien global------------------------------------------------------*/

//servo
uint8_t cnt = 0;
uint8_t pos = 2;

//LCD
unsigned char RS, i2c_add, BackLight_State = 0x08;
uint8_t LCD_SWAP_OLL = 0;

//timer
uint8_t counter0 =0;
uint8_t flag_timer_servor1 = 0;
uint8_t flag_timer_servor2 = 0;

//PWM
uint8_t flag_dc = 1;

//UART
uint16_t B_rate = 9600;
uint8_t flag_trans =0;
char result = '\0' ;

//EPROM
uint8_t count_sp1;
uint8_t count_sp2;
uint8_t count_sp3;
/*-------------------------------------------------ham void-----------------------------------------------------------*/
void main(void){
/*----------------------config cac chuc nang-----------------------------*/

//servo
    Servo_Init();

//I2C
    I2C_Master_Init();

//LCD
    LCD_Init(0x27); // Initialize LCD module with I2C address = 0x4E    

//PWM
	ADC_Init();
    // Init PWM mode for CCP1 module
    init_PWM();

//UART
    config_UART();

// khai bao bien local
uint8_t tmp;
count_sp1 = EEPROM_Read(0x00); // doc gia tri tu eeprom
count_sp2 = EEPROM_Read(0x01);
count_sp3 = EEPROM_Read(0x02);

// khai bao chan IO
//timer 
    TMR1IE  = 1;                 // Timer1 Interrupt enable bit
    TMR1IF = 0;                 // Clear the Interrupt flag bit for timer1 
    // Clear the Timer1 register to start counting from 0
    TMR1 = 0;                   
    // Clear the Timer1 clock select bit to choose local clock source
    TMR1CS = 0;                 
    // Prescaler ratio 1:1
    T1CKPS0 = 0;
    T1CKPS1 = 0;
    
    TMR1H = 0xBE; // thanh ghi bat dau dem
    TMR1L = 0xE4;
    // Switch ON Timer1
    TMR1ON = 1;

//PWM 0 la out , 1 la in
    TRISB0 = 1; // chan ngat
    TRISA0 = 1; // chan doc ADC tu bien tro
    TRISB1 = 0;// chan dat dc
    TRISB2 = 0;// chan d/c enable on off
    RB1 = 0;

    INTEDG = 1;                 // Interrupt edge config bit (HIGH value means interrupt occurs every rising edge)
    INTE = 1;                   // IRQ (Interrupt request pin RB0) Interrupt Enable bit
    GIE = 1;
// UART
//    TRISD0 = 1 ;
    TRISA3 = 0;
    TRISA4 = 0;
    TRISA5 = 0; 
    RA3 = 1;
    RA4 = 1;
    RA5 = 1;
//eeprom
    TRISB4 = 0;// den bao cong
    TRISB5 = 0;// den bao tru
    RB4 = 0;
    RB5 =0;
    
    
  
/*--------------------------------------------------------LOOP----------------------------------------------------------*/
while(1){
    //PWM
    RB1 = flag_dc;
    setPWM_DutyCycle(ADC_Read(0));
    //UART
        // ngat dong co -> gui check -> nhan duoc check -> if else servor va mo dong co
    
    //EEPROM
    if(RD1==0){ // hien tai dang cong vat ly, viet lai de cong theo ket qua phan loai dau ra
            RB5 = 1;
            __delay_ms(100);
            if(RD1==1){
            count_sp1 ++ ;
            EEPROM_Write(0x02,count_sp1);
            }           
        }
        else{
                RB5 =0;
            }
        if(RD2==0){ // tru
            __delay_ms(100);
            if(RD2==1){
            
            count_sp1 -- ;
            EEPROM_Write(0x02,count_sp1);
            }
        }
    
    //--------------------------------
    if (OpenServo == 1)
        {
            pos = 20;
        }
        else
        {
            pos = 10;
        }
        WriteSelectServo = SelectServo;

        if (LCD_SWAP == 0 && LCD_SWAP != LCD_SWAP_OLL)
        {
            LCD_Clear();
            LCD_Set_Cursor(1, 1);
            LCD_Write_String("SP1 SP2 SP3");
            LCD_Set_Cursor(2, 1);
            LCD_Write_String("0  .9  .10 ");
            LCD_SWAP_OLL = 0;
        }
        else
        {
            if (LCD_SWAP != LCD_SWAP_OLL)
            {
                LCD_Clear();
                LCD_Set_Cursor(1, 1);
                LCD_Write_String("Nam Lee");
                LCD_Set_Cursor(2, 1);
                LCD_Write_String("kakaka");
                LCD_SWAP_OLL = 1;
            }
        }
        WriteSelectServo = SelectServo;
}

}

/*---------------------------------------------NGAT------------------------------------------------------*/
void __interrupt() ISR(void){
    //Timer
    if(TMR1IF == 1){               // Check the flag bit 
        counter0 ++;  // counter0++ de tinh lan tran, can du thoi gian de dong servor
        if (counter0 == 60 ){ // them dieu kien cua servor nao
            counter0 = 0;
        } 
        
        TMR1H = 0xFD;
        TMR1L = 0xE8;
        TMR1IF = 0;                 // Clear interrupt bit for timer1
    }  

    //PWM
    if(INTF == 1){ // Check the flag bit neu co ngat thi dung dong co
        setPWM_DutyCycle(0);
        flag_dc =0;
        UART_send_string("check\n");
        INTF  =0 ;
    }

    //UART receive
    if(RCIF == 1){ //
        result = RCREG;
        if (result == 'a'){
            count_sp1 ++;
            EEPROM_Write(0x00,count_sp1);
            flag_timer_servor1 = 1;
            flag_timer_servor2 =0;
            TMR1H = 0xFD;
            TMR1L = 0xE8; // thoi gian ket thuoc mo sv 1
            // servor 1 bat trong bao lau thi tat bang timer
        }
        else if (result == 'b')
        {
            count_sp2 ++;
            EEPROM_Write(0x01,count_sp2);
            flag_timer_servor1 = 0;
            flag_timer_servor2 =1;
            TMR1H = 0xFD;
            TMR1L = 0xE8; // thoi gian ket thuoc mo sv 2
            //servor 2 bat trong bao lau thi tat bang timer
        }
        else if (result =='c')
        {
            count_sp3 ++;
            EEPROM_Write(0x02,count_sp3);
            flag_timer_servor1 = 0;
            flag_timer_servor2 =0;
        }
        flag_dc =1;
        setPWM_DutyCycle(ADC_Read(0)); // chay dong co
        result ='\0'; //khoi tao lai result
        
    RCIF =0;}   
    
    //Servo
    if (T0IF == 1) // phat hien co bao ngat
    {
        TMR0 = 5;
        T0IF = 0; // dua co bao ngat ve gia tri 0
        cnt++;

        if (cnt == pos) // khi timer dem du time
        {
            WritePosOpenServo = ~WritePosOpenServo;
        }

        if (cnt == 200 - pos) // khi timer dem du time 200 cnt = 20ms
        {
            WritePosOpenServo = ~WritePosOpenServo;
            cnt = 0; // reset gia tri cnt
        }
    }
} 

/*---------------------------------------detail function-----------------------------------------------*/

//PWM
void ADC_Init(){
    //------[There are 2 registers to configure ADCON0 and ADCON1]---------
    // ADCON0 = 0x41
    // Select clock option Fosc/8
    ADCS0 = 1;
    ADCS1 = 0;
    // Turn ADC on
    ADON = 1;
    
    //ADCON1 = 0x80
    // Result mode: Right justified
    ADFM = 1;
    // Select clock option Fosc/8
    ADCS2 = 1;
    // Configure all 8 channels are analog 
    PCFG0 = 0;
    PCFG1 = 0;
    PCFG2 = 0;
    PCFG3 = 0;
}

uint16_t ADC_Read(uint8_t ADC_channel){
    // Check channel number
    if(ADC_channel < 0 || ADC_channel > 7)
        return 0;
    
    // Write ADC__channel into register ADCON0
    CHS0 = (ADC_channel & 1) >> 0;
    CHS1 = (ADC_channel & 2) >> 1;
    CHS2 = (ADC_channel & 4) >> 2;
    
    // Wait the Acquisition time 
    __delay_us(25);
    
    // Start A/D conversion
    GO_DONE = 1;
    
    // (Polling) Wait for the conversion to complete
    while(GO_DONE);
    
    // Read the ADC result ("right justified" mode)
    uint16_t result = ((ADRESH << 8) + ADRESL);
    return result;
}

void init_PWM(){
    // Configure the CCP1 module for PWM operation
    CCP1M2 = 1;
    CCP1M3 = 1;
    // Set CCP1 pin as output
    TRISC2 = 0;
    // Set the Timer2 prescaler value and enable Timer2
    switch(ps){
        case 1: {T2CKPS0 = 0;   T2CKPS1 = 0;    break;}
        case 4: {T2CKPS0 = 1;   T2CKPS1 = 0;    break;}
        case 16: T2CKPS1 = 0;   
    }
    TMR2ON = 1;
    // Set the PWM period 
    PR2 = ((float)(_XTAL_FREQ/Fpwm))/(4*ps)-1;
    // --------[Warning: Check if PR2 value fits in 8-bit register (0-255)]---------]
}

void setPWM_DutyCycle(uint16_t DC){
    // DC means % (Ex: DC = 50 means Duty Cycle = 50%)
    // uint16_t val = ((float)_XTAL_FREQ/(float)Fpwm)*((float)DC/(float)100)/ps;
    // Write to CCP1CON<5:4>
    CCP1Y = DC & (1<<0);
    CCP1X = DC & (1<<1);
    // Write to CCPR1L register
    CCPR1L = DC >> 2;
}

//UART
void UART_send_char(char bt)  
{
    while(!TRMT);  // hold the program till TX buffer is free
    TXREG = bt; //Load the transmitter buffer with the received value
}

void UART_send_string(char* st_pt)
{
    while(*st_pt) //if there is a char
        UART_send_char(*st_pt++); //process it as a byte data
}

void config_UART(){
     // Baud rate configuration
    BRGH = 1; // highspeed baundrate
    SPBRG = 129; //( ( _XTAL_FREQ/16 ) / B_rate) - 1 ;
    // Enable Asynchronous Serial Port
    SYNC = 0;
    SPEN = 1;
    // Configure Rx-Tx pin for UART 
    TRISC6 = 1;
    TRISC7 = 1;
    // Enable UART Transmission
    TXEN = 1;
    CREN =1;
    // select 8-bit mode
    // Enable Interrupt Rx 
    RCIE = 1;
    PEIE = 1;
    GIE = 1;
    
    TX9 =0;
    RX9 =0;
}

//EEPROM
uint8_t EEPROM_Read(uint8_t Address){
    EEADR = Address;
    EEPGD = 0;
    EECON1bits.RD = 1;
    return EEDATA;
}
void EEPROM_Write(uint8_t Address, uint8_t Data){
    while(WR); // cho chuong trinh nap truoc do neu co
    EEADR = Address;
    EEDATA = Data;
    EEPGD = 0;
    EECON1bits.WREN = 1;
    GIE =0;
    EECON2 = 0x55;
    EECON2 = 0xAA;
    EECON1bits.WR =1;
    GIE = 1;
    EECON1bits.WREN = 0;
    EECON1bits.WR =0;
}

//--------------------[ Servo ]-------------------------
void Servo_Init()
{
    // config timer 0
    PSA = 0; // chon bo chia truoc cho timer 0

    PS2 = 0;
    PS1 = 0;
    PS0 = 0; // chon bo chia truoc 2

    T0CS = 0; // chon nguon xung clock noi

    GIE = 1;  // cho phep ngat
    T0IE = 1; // cho phep ngat timer 0
    T0IF = 0; // ghi gia tri co ngat = 0



    TRISD0 = 0; // OUT D0,3 set OUTPUT, D1,2,4 INPUT
    TRISD1 = 1;
    TRISD2 = 1;
    TRISD3 = 0;
    TRISD4 = 1;

    RD0 = 1; 
    RD1 = 0;
    RD2 = 0;
    RD3 = 0;
    RD4 = 0;
   
}

void interrupt_servo()
{
    if (T0IF == 1) // phat hien co bao ngat
    {
        TMR0 = 5;
        T0IF = 0; // dua co bao ngat ve gia tri 0
        cnt++;
        if (cnt == pos) // khi timer dem du time
        {
            WritePosOpenServo = ~WritePosOpenServo;
        }

        if (cnt == 200 - pos) // khi timer dem du time 200 cnt = 20ms
        {
            WritePosOpenServo = ~WritePosOpenServo;
            cnt = 0; // reset gia tri cnt
        }
    }
}

//======================================================
//--------------------[ I2C ]---------------------------
void I2C_Master_Init()
{
    SSPCON = 0x28; // dat pic la master, clock = FOSC/(4 * (SSPADD + 1))
    SSPCON2 = 0x00;
    SSPSTAT = 0x00;
    SSPADD = ((_XTAL_FREQ / 4) / 100000) - 1; // I2C_BaudRate           100000

    TRISC3 = 1; // SCL
    TRISC4 = 1; // SDA
}

void I2C_Master_Wait()
{
    while ((SSPSTAT & 0x04) || (SSPCON2 & 0x1F)) // cho den khi du lieu truyen xong
        ;
}

void I2C_Master_Start()
{
    I2C_Master_Wait();
    SEN = 1; // bat dau su dung i2C
}

void I2C_Master_Stop()
{
    I2C_Master_Wait();
    PEN = 1; // ket thuc su dung i2C
}

void I2C_Master_Write(unsigned char data) // ghi du lieu vao bo nho dem SSPBUF
{
    I2C_Master_Wait();
    SSPBUF = data; // khi nhan duoc 1 byte hoan chinh, bit SSIF == 1
    while (!SSPIF)
        ; // doi du lieu day
    SSPIF = 0;
}

//======================================================
//--------------------[ LCD ]---------------------------
void LCD_Init(unsigned char I2C_Add)
{
    i2c_add = I2C_Add;
    IO_Expander_Write(0x00);
    __delay_ms(5);
    
    LCD_CMD(LCD_RETURN_HOME);
    __delay_ms(5);
    LCD_CMD(0x20 | (2 << 2));
    __delay_ms(5);
    LCD_CMD(LCD_TURN_ON);
    __delay_ms(50);
    LCD_CMD(LCD_CLEAR);
    __delay_ms(50);
}

void IO_Expander_Write(unsigned char Data)
{
    I2C_Master_Start();
    I2C_Master_Write(i2c_add);
    I2C_Master_Write(Data | BackLight_State);
    I2C_Master_Stop();
}

void LCD_Write_4Bit(unsigned char Nibble)
{
    // Get The RS Value To LSB OF Data
    Nibble |= RS;
    IO_Expander_Write(Nibble | 0x04);
    IO_Expander_Write(Nibble & 0xFB);
    //	__delay_us(50);
}

void LCD_CMD(unsigned char CMD)
{
    RS = 0; // Command Register Select
    LCD_Write_4Bit(CMD & 0xF0);
    LCD_Write_4Bit((CMD << 4) & 0xF0);
}

void LCD_Write_Char(char Data)
{
    RS = 1; // Data Register Select
    LCD_Write_4Bit(Data & 0xF0);
    LCD_Write_4Bit((Data << 4) & 0xF0);
}

void LCD_Write_String(char *Str)
{
    for (int i = 0; Str[i] != '\0'; i++)
        LCD_Write_Char(Str[i]);
}

void LCD_Set_Cursor(unsigned char ROW, unsigned char COL)
{
    switch (ROW)
    {
    case 2:
        LCD_CMD(0xC0 + COL - 1); //
        break;
    // Case 1
    default:
        LCD_CMD(0x80 + COL - 1); // 1100.0000 D7=1 co dinh, hang 1 bat dau tu 0x00 nen tro thanh 0x80
        break;
    }
}

void LCD_Clear()
{
    LCD_CMD(LCD_CLEAR);
    	__delay_us(40);
}
