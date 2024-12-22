// SM : Task 2 A : ADC
/*
Instructions
-------------------
Students are not allowed to make any changes in the Module declaration.
This file is used to design ADC Controller.

Recommended Quartus Version : 19.1
The submitted project file must be 19.1 compatible as the evaluation will be done on Quartus Prime Lite 19.1.

Warning: The error due to compatibility will not be entertained.
-------------------
*/

//ADC Controller design
//Inputs  : clk_50 : 50 MHz clock, dout : digital output from ADC128S022 (serial 12-bit)
//Output  : adc_cs_n : Chip Select, din : Ch. address input to ADC128S022, adc_sck : 2.5 MHz ADC clock,
//				d_out_ch5, d_out_ch6, d_out_ch7 : 12-bit output of ch. 5,6 & 7,
//				data_frame : To represent 16-cycle frame (optional)

//////////////////DO NOT MAKE ANY CHANGES IN MODULE//////////////////
module adc_control(
	input  clk_50,				//50 MHz clock
	input  dout,				//digital output from ADC128S022 (serial 12-bit)
	output adc_cs_n,			//ADC128S022 Chip Select
	output din,					//Ch. address input to ADC128S022 (serial)
	output adc_sck,			//2.5 MHz ADC clock
	output [11:0]d_out_ch5,	//12-bit output of ch. 5 (parallel)
	output [11:0]d_out_ch6,	//12-bit output of ch. 6 (parallel)
	output [11:0]d_out_ch7,	//12-bit output of ch. 7 (parallel)
	output [1:0]data_frame	//To represent 16-cycle frame (optional)
);
	
////////////////////////WRITE YOUR CODE FROM HERE////////////////////


reg [5:0]count = 6'd0;         //counter for clk for scaling down

reg [4:0]counter = 5'd0;			// counter for sck

reg [11:0]data = 12'd0;				// input data storage 

reg [11:0]temp7 = 12'd0;			// for holding current valaues of channel 7 

reg [11:0]temp6 = 12'd0;			// for holding current valaues of channel 6

reg [11:0]temp5 = 12'd0;			// for holding current valaues of channel 5

reg [1:0]ans = 1;						// for data frame

reg [2:0]dinchannel = 5;			// output channel value

reg [2:0]nextchannel = 7;			// next channel value 

reg [2:0]currentchannel ;			// current channel value






reg tempdin = 0;						// temp for din


always@(negedge clk_50)
	begin
		if( count == 20)				// clk counter reset
			count = 0;
		
		count = count + 1;			// clk counter increament 
		
	end	
	
assign adc_sck = ( count <= 10 ) ? 0:1;	// scaling down logical expression


always@(negedge adc_sck)						// for channel address sending  at -ve falling edge
begin
	
		if( counter == 16)								// sclk counter reset , data frame increament 
		
			begin												
				counter = 0;
				if( ans == 3)								
					ans = 1;
				else
					ans = ans + 1;
					
					currentchannel = nextchannel;			
				
				nextchannel = dinchannel;
					
				if( dinchannel == 7)
					dinchannel = 5;
				else
					dinchannel = dinchannel+ 1;			// channel increament
				
			end	
			
		counter = counter + 1;								// sclk couter increamnet
		

		
		
					if(counter > 2 && counter <6)
						tempdin = dinchannel[5 - counter] ;			// for storing value of channel
					else 
						tempdin = 0;
		
	
	
end
	
always@(posedge adc_sck)							// for taking dout values at + ve edge of clock
begin

		if( counter >= 5)	
			data[16 - counter] = dout;				// taking value
			
		
		temp7 = d_out_ch7 ;
		
		temp6 = d_out_ch6 ;
		
		temp5 = d_out_ch5 ;
		

end	
		
	
	

		assign d_out_ch7 = (counter == 1)?((currentchannel == 7) ? data : temp7): temp7;
		
		assign d_out_ch6 = (counter == 1)?((currentchannel == 6) ? data : temp6): temp6;
		
		assign d_out_ch5 = (counter == 1)?((currentchannel == 5) ? data : temp5): temp5;
		
		assign data_frame = ans; 
		
		
	
		assign din = tempdin;
	
		assign adc_cs_n = 0;
	


////////////////////////YOUR CODE ENDS HERE//////////////////////////
endmodule
///////////////////////////////MODULE ENDS///////////////////////////