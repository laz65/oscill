/*******************************************************
This program was created by the
CodeWizardAVR V3.12 Advanced
Automatic Program Generator
© Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
http://www.hpinfotech.com

Project : 
Version : 
Date    : 04.02.2015
Author  : 
Company : 
Comments: 


Chip type               : ATmega328P
Program type            : Application
AVR Core Clock frequency: 8,000000 MHz
Memory model            : Small
External RAM size       : 0
Data Stack size         : 512
*******************************************************/

#include <mega328p.h>
#include <sleep.h>
#include <delay.h>
#include "glcdfont.c"
// Declare your global variables here
int i,a,n,time, met, x, y, x0 = 0, y0 = 32, maxr, maxl, kof;
unsigned char rx_data[1],bufer[129], tx_data0[50] = {0x80, 0xAE, 0x80, 0xD5,0x80, 0x80,0x80, 0xA8,0x80, 0x3F,0x80, 0xD3,
0x80, 0x0,0x80, 0x40,0x80, 0x8D,0x80, 0x14,0x80, 0x20,0x80, 0x00,0x80,  0xA1, 0x80, 0xC8,0x80, 
0xDA,0x80, 0x12,0x80, 0x81,0x80, 0xCF,0x80, 0xD9,0x80, 0xF1,0x80, 0xDB,0x80, 0x40,0x80, 0xA4,
0x80, 0xA6, 0x80, 0xAF };
// Voltage Reference: AVCC pin
#define ADC_VREF_TYPE ((0<<REFS1) | (1<<REFS0) | (0<<ADLAR))

// Read the AD conversion result
unsigned int read_adc(unsigned char adc_input)
{
ADMUX=adc_input | ADC_VREF_TYPE;
// Delay needed for the stabilization of the ADC input voltage
delay_us(10);
// Start the AD conversion
ADCSRA|=(1<<ADSC);
// Wait for the AD conversion to complete
while ((ADCSRA & (1<<ADIF))==0);
ADCSRA|=(1<<ADIF);
return ADCW;
}


// TWI functions
#include <twi.h>

void display(void)
{
    bufer[0] = 0x80; 
    bufer[1] = 0x21;
    bufer[2] = 0x80;
    bufer[3] = 0; 
    bufer[4] = 0x80;
    bufer[5] = 127;
    bufer[6] = 0x80;
    bufer[7] = 0x22; 
    bufer[8] = 0x80;
    bufer[9] = 0; 
    bufer[10] = 0x80;
    bufer[11] = 7  ;
    twi_master_trans(0x3C, bufer, 12, rx_data, 0) ;
 
       for (i=0; i<1024; ) {
      // send a bunch of data in one xmission
        bufer[0] = 0x40;  
        for (n=0; n<128; n++) {   
        bufer[n+1] = buffer[i++];
        }
      
        twi_master_trans(0x3C, bufer, 129, rx_data, 0) ;
    }
}


void main(void)
{
// Declare your local variables here
// Crystal Oscillator division factor: 1
#pragma optsize-
CLKPR=(1<<CLKPCE);
CLKPR=(0<<CLKPCE) | (0<<CLKPS3) | (0<<CLKPS2) | (0<<CLKPS1) | (0<<CLKPS0);
#ifdef _OPTIMIZE_SIZE_
#pragma optsize+
#endif

// Input/Output Ports initialization
// Port B initialization
// Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In 
DDRB=(0<<DDB7) | (0<<DDB6) | (0<<DDB5) | (0<<DDB4) | (3<<DDB3) | (0<<DDB2) | (0<<DDB1) | (0<<DDB0);
// State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T 
PORTB=(0<<PORTB7) | (0<<PORTB6) | (0<<PORTB5) | (0<<PORTB4) | (0<<PORTB3) | (0<<PORTB2) | (0<<PORTB1) | (0<<PORTB0);

// Port C initialization
// Function: Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In 
DDRC=(0<<DDC6) | (0<<DDC5) | (0<<DDC4) | (0<<DDC3) | (0<<DDC2) | (0<<DDC1) | (0<<DDC0);
// State: Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T 
PORTC=(0<<PORTC6) | (0<<PORTC5) | (0<<PORTC4) | (1<<PORTC3) | (0<<PORTC2) | (0<<PORTC1) | (0<<PORTC0);

// Port D initialization
// Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In 
DDRD=(0<<DDD7) | (0<<DDD6) | (0<<DDD5) | (0<<DDD4) | (1<<DDD3) | (0<<DDD2) | (0<<DDD1) | (0<<DDD0);
// State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T 
PORTD=(0<<PORTD7) | (0<<PORTD6) | (0<<PORTD5) | (0<<PORTD4) | (0<<PORTD3) | (0<<PORTD2) | (0<<PORTD1) | (0<<PORTD0);

// Timer/Counter 0 initialization
// Clock source: System Clock
// Clock value: Timer 0 Stopped
// Mode: Normal top=0xFF
// OC0A output: Disconnected
// OC0B output: Disconnected
TCCR0A=(0<<COM0A1) | (0<<COM0A0) | (0<<COM0B1) | (0<<COM0B0) | (0<<WGM01) | (0<<WGM00);
TCCR0B=(0<<WGM02) | (0<<CS02) | (0<<CS01) | (0<<CS00);
TCNT0=0x00;
OCR0A=0x00;
OCR0B=0x00;

// Timer/Counter 1 initialization
// Clock source: System Clock
// Clock value: Timer1 Stopped
// Mode: Normal top=0xFFFF
// OC1A output: Disconnected
// OC1B output: Disconnected
// Noise Canceler: Off
// Input Capture on Falling Edge
// Timer1 Overflow Interrupt: Off
// Input Capture Interrupt: Off
// Compare A Match Interrupt: Off
// Compare B Match Interrupt: Off
TCCR1A=(0<<COM1A1) | (0<<COM1A0) | (0<<COM1B1) | (0<<COM1B0) | (0<<WGM11) | (0<<WGM10);
TCCR1B=(0<<ICNC1) | (0<<ICES1) | (0<<WGM13) | (0<<WGM12) | (0<<CS12) | (0<<CS11) | (0<<CS10);
TCNT1H=0x00;
TCNT1L=0x00;
ICR1H=0x00;
ICR1L=0x00;
OCR1AH=0x00;
OCR1AL=0x00;
OCR1BH=0x00;
OCR1BL=0x00;

// Timer/Counter 2 initialization
// Clock source: System Clock
// Clock value: 16000,000 kHz
// Mode: Fast PWM top=0xFF
// OC2A output: Non-Inverted PWM
// OC2B output: Non-Inverted PWM
// Timer Period: 0,016 ms
// Output Pulse(s):
// OC2A Period: 0,016 ms Width: 0 us
// OC2B Period: 0,016 ms Width: 0 us
ASSR=(0<<EXCLK) | (0<<AS2);
TCCR2A=(1<<COM2A1) | (0<<COM2A0) | (1<<COM2B1) | (0<<COM2B0) | (1<<WGM21) | (1<<WGM20);
TCCR2B=(0<<WGM22) | (0<<CS22) | (0<<CS21) | (1<<CS20);
TCNT2=0x00;
OCR2A=0x00;
OCR2B=0x00;

// Timer/Counter 0 Interrupt(s) initialization
TIMSK0=(0<<OCIE0B) | (0<<OCIE0A) | (0<<TOIE0);

// Timer/Counter 1 Interrupt(s) initialization
TIMSK1=(0<<ICIE1) | (0<<OCIE1B) | (0<<OCIE1A) | (0<<TOIE1);

// Timer/Counter 2 Interrupt(s) initialization
TIMSK2=(0<<OCIE2B) | (0<<OCIE2A) | (0<<TOIE2);

// External Interrupt(s) initialization
// INT0: Off
// INT1: Off
// Interrupt on any change on pins PCINT0-7: Off
// Interrupt on any change on pins PCINT8-14: Off
// Interrupt on any change on pins PCINT16-23: Off
EICRA=(0<<ISC11) | (0<<ISC10) | (0<<ISC01) | (0<<ISC00);
EIMSK=(0<<INT1) | (0<<INT0);
PCICR=(0<<PCIE2) | (0<<PCIE1) | (0<<PCIE0);

// USART initialization
// USART disabled
UCSR0B=(0<<RXCIE0) | (0<<TXCIE0) | (0<<UDRIE0) | (0<<RXEN0) | (0<<TXEN0) | (0<<UCSZ02) | (0<<RXB80) | (0<<TXB80);

// Analog Comparator initialization
// Analog Comparator: Off
// The Analog Comparator's positive input is
// connected to the AIN0 pin
// The Analog Comparator's negative input is
// connected to the AIN1 pin
ACSR=(1<<ACD) | (0<<ACBG) | (0<<ACO) | (0<<ACI) | (0<<ACIE) | (0<<ACIC) | (0<<ACIS1) | (0<<ACIS0);
ADCSRB=(0<<ACME);
// Digital input buffer on AIN0: On
// Digital input buffer on AIN1: On
DIDR1=(0<<AIN0D) | (0<<AIN1D);

// ADC initialization
// ADC disabled
ADCSRA=(0<<ADEN) | (0<<ADSC) | (0<<ADATE) | (0<<ADIF) | (0<<ADIE) | (0<<ADPS2) | (0<<ADPS1) | (0<<ADPS0);

// SPI initialization
// SPI disabled
SPCR=(0<<SPIE) | (0<<SPE) | (0<<DORD) | (0<<MSTR) | (0<<CPOL) | (0<<CPHA) | (0<<SPR1) | (0<<SPR0);


// ADC initialization
// ADC Clock frequency: 1000,000 kHz
// ADC Voltage Reference: AVCC pin
// ADC Auto Trigger Source: ADC Stopped
// Digital input buffers on ADC0: On, ADC1: On, ADC2: On, ADC3: On
// ADC4: On, ADC5: On
DIDR0=(0<<ADC5D) | (0<<ADC4D) | (0<<ADC3D) | (0<<ADC2D) | (0<<ADC1D) | (0<<ADC0D);
ADMUX=ADC_VREF_TYPE;
ADCSRA=(1<<ADEN) | (0<<ADSC) | (0<<ADATE) | (0<<ADIF) | (0<<ADIE) | (0<<ADPS2) | (1<<ADPS1) | (1<<ADPS0);
ADCSRB=(0<<ADTS2) | (0<<ADTS1) | (0<<ADTS0);


// TWI initialization
// Mode: TWI Master
// Bit Rate: 400 kHz
twi_master_init(400);

// Global enable interrupts
#asm("sei")
twi_master_trans(0x3C, tx_data0, 50, rx_data, 0);  
time = 60;
kof =  read_adc(3);
met = kof/11;
kof = kof/7;
while ( time  >0)
{   
    clearDisplay();                        
    for(a = 63; a >= 0; a--)
    {   
        OCR2A = 0;
        OCR2B = a*4;
        x = read_adc(0);
        y = read_adc(1);   
        x = x-y;
        if (x<maxl) maxl = x;
        if (x>maxr) maxr = x;
        x = x/16+64;
        y = y/16;
        y = y + 32; 
        drawLine(x0,y0,x,y,1);
        x0 = x; y0 = y;  
    }
    for(a = 0; a < 64; a++)
    {   
        OCR2A = a*4;
        OCR2B = 0;
        y = read_adc(0);        
        x = read_adc(1);
        x = y-x; 
        if (x<maxl) maxl = x;
        if (x>maxr) maxr = x;
        x = x/16+64;
        y = y/16;        
        y = 32-y; 
        drawLine(x0,y0,x,y,1);
        x0 = x; y0 = y;  
        if(a == 0)
        { 
           x = read_adc(1);
           a = read_adc(0);
           x = (a-x)/4+256;
          if(x<256)
          {
            x = 256-x;
            drawChar(2,7,'-');
          } else x = x - 256;
            if(x>99)
            {
                drawChar(19,7,'L');
                drawChar(20,7,'V');        
            }
            else
            {
                if(x<10)        
                drawChar(3,7,0x30+x);
                else
                { 
                a = x/10;
                x = x - a*10;
                drawChar(3,7,0x30+a);
                drawChar(4,7,0x30+x);        
                }  
            }

        }
    }   
    drawPixel(64,0,1);   
    drawPixel(64,15,1);   
    drawPixel(64,30,1);   
    drawPixel(64,34,1);   
    drawPixel(64,49,1);   
    drawPixel(64,63,1);   
    drawPixel(64+met,30,1);   
    drawPixel(64+met,34,1);   
    drawPixel(64+met+met,30,1);   
    drawPixel(64+met+met,34,1);   
    drawPixel(64+met+met+met,30,1);   
    drawPixel(64+met+met+met,34,1);   
//    drawPixel(116,30,1);   
//    drawPixel(116,34,1);   
    drawPixel(64-met,30,1);                       
    drawPixel(64-met,34,1);   
    drawPixel(64-met-met,30,1);   
    drawPixel(64-met-met,34,1);  
    drawPixel(64-met-met-met,34,1);   
    drawPixel(64-met-met-met,30,1);   
//    drawPixel(12,30,1);   
//    drawPixel(12,34,1);   
    drawPixel(64+met,49,1);   
    drawPixel(64+met,15,1);   
    drawPixel(64-met,49,1);   
    drawPixel(64-met,15,1);       
    drawString(0,7,"Ф:",2);
    drawString(16,7,"Ф:",2);
    drawChar(0,0,'+');
    drawChar(20,0,'-');
    if((y>34)|(y<30)) time = 1800;
    time = time - 1;   
    delay_ms(44);
    delay_us(700);
    for(a = 63; a >= 0; a--)
    {   
        OCR2A = a*4;
        OCR2B = 0;
        x = read_adc(1);
        y = read_adc(0);        
        x = y-x;
        if (x<maxl) maxl = x;
        if (x>maxr) maxr = x;
        x = x/16+64;
        y = y/16;
        y = 32-y; 
        drawLine(x0,y0,x,y,1);
        x0 = x; y0 = y;  
    }
    for(a = 0; a < 64; a++)
    {   
        OCR2A = 0;
        OCR2B = a * 4;
        y = read_adc(1);        
        x = read_adc(0);
        x = x-y;
        if (x<maxl) maxl = x;
        if (x>maxr) maxr = x;
        x = x/16+64;
        y = y/16;
        y = y + 32 ; 
        drawLine(x0,y0,x,y,1);
        x0 = x; y0 = y;  
      if(a == 0)
      {                
           
            x = read_adc(0); 
            a = read_adc(1);
           x = (a-x)/4+256;
          if(x<256)
          {
            x = 256-x;
            drawChar(18,7,'-');
          } else x = x - 256;
            if(x>99)
            {
                drawChar(19,7,'L');
                drawChar(20,7,'V');        
            }
            else
            {
                if(x<10)        
                drawChar(19,7,0x30+x);
                else
                { 
                a = x/10;
                x = x - a*10;
                drawChar(19,7,0x30+a);
                drawChar(20,7,0x30+x);        
                }
            }     
      }                  
    }   
    x = -maxl/kof; 
                if(x<10) 
                {       
                    drawChar(16,0,'0');
                    drawChar(18,0,0x30+x);    
                }
                else
                { 
                    a = x/10;
                    x = x - a*10;
                    drawChar(16,0,0x30+a);
                    drawChar(18,0,0x30+x);        
                }  
                drawChar(17,0,'.');        
                drawChar(19,0,'v');        
    x = maxr/kof; 
                if(x<10)  
                {      
                    drawChar(1,0,'0');
                    drawChar(3,0,0x30+x);   
                }
                else
                { 
                    a = x/10;
                    x = x - a*10;
                    drawChar(1,0,0x30+a);
                    drawChar(3,0,0x30+x);        
                }
                drawChar(2,0,'.');        
                drawChar(4,0,'v');        
    display();
    if((y>34)|(y<30)) time = 1200;
    maxl = 0;
    maxr = 0;              
         
      // Place your code here 
      

} 
    bufer[0] = 0x80; 
    bufer[1] = 0xAE;
    twi_master_trans(0x3C, bufer, 2, rx_data, 0) ;

         #asm("cli")                     // дальше действия по выключению 
            TWCR = 0; 
            DDRC=DDRB=DDRD=0;
            PORTC=PORTD=0;
            PORTB=0x00;    
            ASSR=(0<<EXCLK) | (0<<AS2);
        TCCR2A=(0<<COM2A1) | (0<<COM2A0) | (0<<COM2B1) | (0<<COM2B0) | (0<<WGM21) | (0<<WGM20);
        TCCR2B=(0<<WGM22) | (0<<CS22) | (0<<CS21) | (0<<CS20);

            ADMUX=00;
            ADCSRA=0x00;
            MCUCR = 0x10;
    
            sleep_enable(); //разрешение спящего режима
            powerdown();
      
      
}
