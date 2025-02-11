module freq_divider_100Hz (  
    input wire clk_in,    
    output reg clk_out    
);  
    reg [25:0] counter = 0;   

    initial begin  
        clk_out = 0;  
    end  
//40000000/(2*100) == 200000
    always @ (posedge clk_in) begin  
        if (counter == 200000 - 1) begin  
            counter <= 0;  
            clk_out <= ~clk_out;  
        end else begin  
            counter <= counter + 1;   
        end  
    end  
endmodule
// این فرکانس دیوایدر جدید رو ساختم که به اف اس ام و دیبانسر پاس بدم تا بهتر و درست تر کار کنند
module freq_divider_100Hz (  
    input wire clk_in,    
    output reg clk_out    
);  
    reg [25:0] counter = 0;   

    initial begin  
        clk_out = 0;  
    end  
//40000000/(2*1000) == 20000
    always @ (posedge clk_in) begin  
        if (counter == 20000 - 1) begin  
            counter <= 0;  
            clk_out <= ~clk_out;  
        end else begin  
            counter <= counter + 1;   
        end  
    end  
endmodule
//دیبانسر رو بدون ماژول فلیپ فلاپ نوشتم بلکه دستی ان را درست کردم (assign کردم)
// در پایین تر توضیح دادم که کلاک ورودی دیبانسر را فرکانسش را 1000 هرتز کردم
module DB ( input clk, input reset, input sig, output reg sig_debounced);

reg q0, q1, q2;
always @(posedge clk or posedge reset)
	begin if (reset)
begin
q2 <= 0; 
q1 <= 0;
q0 <= 0;
sig_debounced <= 0;
end else begin
 q2 <= q1;
 q1 <= q0;
 q0 <= sig;
sig_debounced <= q0 && q1 && ~q2;
end
end endmodule


// دیبانسر active low هست بخاطر همین درست مار نمیکرد چون من ورودی رو باید قرینه میکردم و به دیبانسر میدادم اما قرینه نکردم 
//داخلی این کد ورودی رو قرینه میکنم و به دیبانسر میدم در این صورت دیبانسر درست کار میکند 
//ویدیو ای تهیه کردم از کارکرد درست دیبانسرم اگر مایل بودید تماشا کنین
module FSM(
    input wire clk,
    input wire o,           
    input wire e,           
    input wire [1:0]s,   //switch    
    input wire reset,
    output reg [3:0] LED,
    output reg [2:0] all_num,     
    output reg [2:0] best_num,    
    output reg realopen,        
    output reg realfull        
); 
    parameter S0 = 4'b0000 , S1 = 4'b0001 , S2 = 4'b0010 , S3 = 4'b0011 , S4 = 4'b0100 , S5 = 4'b0101 , S6 = 4'b0110 
    , S7 = 4'b0111 , S8 = 4'b1000 ,  S9 = 4'b1001 , S10 = 4'b1010 , S11 = 4'b1011 , S12 = 4'b1100 , S13 = 4'b1101 
    , S14 = 4'b1110 , S15 = 4'b1111;   

    reg [3:0] current_state, next_state;  
    reg open , full ;

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            current_state <= S0;   
        end else begin  
            current_state <= next_state;  
            realopen <= open;
            realfull <= full;
        end  
    end  
 
    always @(*) begin
    case(current_state)
        S0: begin
            if (o) next_state = S1;
            else next_state = S0;
        end

        S1: begin
            if (o) next_state = S3;
            else if (e && ~s[1] && ~s[0]) next_state = S0;
            else next_state = S1;
        end

        S2: begin
            if (o) next_state = S3;
            else if (e && ~s[1] && s[0]) next_state = S0;
            else next_state = S2;
        end

        S3: begin
            if (o) next_state = S7;
            else if (e && ~s[1] && ~s[0]) next_state = S2;
            else if (e && ~s[1] && s[0]) next_state = S1;
            else next_state = S3;
        end

        S4: begin
            if (o) next_state = S5;
            else if (e && s[1] && ~s[0]) next_state = S0;
            else next_state = S4;
        end

        S5: begin
            if (o) next_state = S7;
            else if (e && ~s[1] && ~s[0]) next_state = S4;
            else if (e && s[1] && ~s[0]) next_state = S1;
            else next_state = S5;
        end

        S6: begin
            if (o) next_state = S7;
            else if (e && ~s[1] && s[0]) next_state = S4;
            else if (e && s[1] && ~s[0]) next_state = S2;
            else next_state = S6;
        end

        S7: begin
            if (o) next_state = S15;
            else if (e && ~s[1] && ~s[0]) next_state = S6;
            else if (e && ~s[1] && s[0]) next_state = S5;
            else if (e && s[1] && ~s[0]) next_state = S3;
            else next_state = S7;
        end

        S8: begin
            if (o) next_state = S9;
            else if (e && s[1] && s[0]) next_state = S0;
            else next_state = S8;
        end

        S9: begin
            if (o) next_state = S11;
            else if (e && ~s[1] && ~s[0]) next_state = S8;
            else if (e && s[1] && s[0]) next_state = S1;
            else next_state = S9;
        end

        S10: begin
            if (o) next_state = S11;
            else if (e && ~s[1] && s[0]) next_state = S8;
            else if (e && s[1] && s[0]) next_state = S2;
            else next_state = S10;
        end

        S11: begin
            if (o) next_state = S15;
            else if (e && ~s[1] && ~s[0]) next_state = S10;
            else if (e && ~s[1] && s[0]) next_state = S9;
            else if (e && s[1] && s[0]) next_state = S3;
            else next_state = S11;
        end

        S12: begin
            if (o) next_state = S13;
            else if (e && s[1] && ~s[0]) next_state = S8;
            else if (e && s[1] && s[0]) next_state = S4;
            else next_state = S12;
        end

        S13: begin
            if (o) next_state = S15;
            else if (e && ~s[1] && ~s[0]) next_state = S12;
            else if (e && s[1] && ~s[0]) next_state = S9;
            else if (e && s[1] && s[0]) next_state = S5;
            else next_state = S13;
        end

        S14: begin
            if (o) next_state = S15;
            else if (e && ~s[1] && s[0]) next_state = S12;
            else if (e && s[1] && ~s[0]) next_state = S10;
            else if (e && s[1] && s[0]) next_state = S6;
            else next_state = S14;
        end

        S15: begin
            if (o) next_state = S15;
            else if (e && ~s[1] && ~s[0]) next_state = S14;
            else if (e && ~s[1] && s[0]) next_state = S13;
            else if (e && s[1] && ~s[0]) next_state = S11;
            else if (e && s[1] && s[0]) next_state = S7;
            else next_state = S15;
        end
        default : next_state = S0;
        
    endcase
end
    always @(current_state) begin
        case(current_state)
            S0: begin
                LED = 4'b0000;
                all_num = 3'b100;
                best_num = 3'b000;
                if(o) begin
                open = 1;
                end 
                else begin 
                open = 0;
                end  
                full = 0;
            end

            S1: begin
                LED = 4'b0001;
                all_num = 3'b011;
                best_num = 3'b001;
                if(o || (e && ~s[1] && ~s[0])) begin
                open = 1;
                end
                else begin 
                open = 0;
                end  
                full = 0;
            end

            S2: begin
                LED = 4'b0010;
                all_num = 3'b011;
                best_num = 3'b000;
                if(o || (e && ~s[1] && s[0])) begin
                open = 1;
                end
                else begin 
                open = 0;
                end  
                full = 0;
            end

            S3: begin
                LED = 4'b0011;
                all_num = 3'b010;
                best_num = 3'b010;
                if(o || (e && ~s[1] && ~s[0]) || (e && ~s[1] && s[0])) begin
                open = 1;
                end
                else begin 
                open = 0;
                end  
                full = 0;
            end

            S4: begin
                LED = 4'b0100;
                all_num = 3'b011;
                best_num = 3'b000;
                if(o || (e && s[1] && ~s[0])) begin
                open = 1;
                end
                else begin 
                open = 0;
                end  
                full = 0;
            end

            S5: begin
                LED = 4'b0101;
                all_num = 3'b010;
                best_num = 3'b001;
                if(o || (e && ~s[1] && ~s[0]) || (e && s[1] && ~s[0])) begin
                open = 1;
                end
                else begin 
                open = 0;
                end  
                full = 0;
            end

            S6: begin
                LED = 4'b0110;
                all_num = 3'b010;
                best_num = 3'b000;
                if(o || (e && ~s[1] && s[0]) || (e && s[1] && ~s[0])) begin
                open = 1;
                end
                else begin 
                open = 0;
                end  
                full = 0;
            end

            S7: begin
                LED = 4'b0111;
                all_num = 3'b001;
                best_num = 3'b011;
                if(o || (e && ~s[1] && ~s[0])|| (e && ~s[1] && s[0]) || (e && s[1] && ~s[0])) begin
                open = 1;
                end
                else begin 
                open = 0;
                end  
                full = 0;
            end

            S8: begin
                LED = 4'b1000;
                all_num = 3'b011;
                best_num = 3'b000;
                if(o || (e && s[1] && s[0])) begin
                open = 1;
                end
                else begin 
                open = 0;
                end  
                full = 0;
            end

            S9: begin
                LED = 4'b1001;
                all_num = 3'b010;
                best_num = 3'b001;
                if(o || (e && ~s[1] && ~s[0]) || (e && s[1] && s[0])) begin
                open = 1;
                end
                else begin 
                open = 0;
                end  
                full = 0;
            end

            S10: begin
                LED = 4'b1010;
                all_num = 3'b010;
                best_num = 3'b000;
                if(o || (e && ~s[1] && s[0]) || (e && s[1] && s[0])) begin
                open = 1;
                end
                else begin 
                open = 0;
                end  
                full = 0;
            end

            S11: begin
                LED = 4'b1011;
                all_num = 3'b001;
                best_num = 3'b010;
                if(o || (e && ~s[1] && ~s[0]) || (e && ~s[1] && s[0]) ||(e && s[1] && s[0])) begin
                open = 1;
                end
                else begin 
                open = 0;
                end  
                full = 0;
            end

            S12: begin
                LED = 4'b1100;
                all_num = 3'b010;
                best_num = 3'b000;
                if(o || (e && s[1] && ~s[0]) || (e && s[1] && s[0])) begin
                open = 1;
                end
                else begin 
                open = 0;
                end  
                full = 0;
            end

            S13: begin
                LED = 4'b1101;
                all_num = 3'b001;
                best_num = 3'b001;
                if(o ||  (e && ~s[1] && ~s[0]) || (e && s[1] && ~s[0]) || (e && s[1] && s[0])) begin
                open = 1;
                end
                else begin 
                open = 0;
                end  
                full = 0;
            end

            S14: begin
                LED = 4'b1110;
                all_num = 3'b001;
                best_num = 3'b000;
                if(o || (e && ~s[1] && s[0]) || (e && s[1] && ~s[0])|| (e && s[1] && s[0])) begin
                open = 1;
                end
                else begin 
                open = 0;
                end  
                full = 0;
            end

            S15: begin
                LED = 4'b1111;
                all_num = 3'b000; 
                best_num = 3'b101; //-
                if(o) begin
                open = 0;
                full = 1;
                end
                else if((e && ~s[1] && ~s[0])|| (e && ~s[1] && s[0])||(e && s[1] && ~s[0]) || (e && s[1] && s[0])) begin
                open = 1;
                full = 0;
                end
                else begin
                open = 0;
                full = 0;
                end
            end

        endcase
    end
endmodule

module multiplex_7segment(
	input clk,
	input reset,
	input [2:0] best_num,
	input [2:0] all_num,
	output reg [4:0] sel_seg,
	output reg [7:0] seg_data
    );

	reg select_en;
	
	always @(posedge clk or posedge reset) begin

		if(reset) begin
			sel_seg <= 5'b00000;
			seg_data <= 8'b00000000;
			select_en <= 1'b0;
		end else begin 
				select_en <= ~select_en;
				if (select_en) begin
					sel_seg <= 5'b00001;
					case (best_num)
						3'b000: seg_data <= 8'b00111111;
						3'b001: seg_data <= 8'b00000110;
						3'b010: seg_data <= 8'b01011011;
						3'b011: seg_data <= 8'b01001111; 
						default: seg_data <= 8'b01000000;
					endcase	
				end
				else begin
					sel_seg <= 5'b00100;
					case(all_num)
						3'b000: seg_data <= 8'b00111111;
						3'b001: seg_data <= 8'b00000110;
						3'b010: seg_data <= 8'b01011011;
						3'b011: seg_data <= 8'b01001111;
						3'b100: seg_data <= 8'b01100110;
						default: seg_data <= 8'b01100110;
					endcase	
				end
		end
	end	
endmodule


module top_module(  
    input wire clk,  
    input wire sensor_Entry,     
    input wire sensor_Exit,     
    input wire [1:0] exit_place,   
    output wire [4:0] seg_sel,
    output wire [7:0] data_seg,  
    output wire open,         
    output wire full,          
    output wire [3:0] LED,  
    output reg open_door,  
    output reg full_light,  
    input wire reset  
);  
  
    wire clk_out1, clk_out2  ;  
    wire [2:0] all_num, best_num;   

    wire debounced_entry, debounced_exit;
    wire [1:0]exits;  
     
    freq_divider_100Hz fd100(clk , clk_out1);   
    //فرکانس دیوایدر جدید رو فراخوانی کردم و به ورودی دیبانسر ها و اف اس ام دادم
    freq_divider_1000Hz fd1000(clk , clk_out2);  
    // اینجا باید نقیض ورودی را به دیبانسر بدهیم 

    DB db_entry(clk_out2, reset, ~sensor_Entry, debounced_entry);  
    DB db_exit(clk_out2, reset, ~sensor_Exit, debounced_exit);  
    

    FSM fsm(  
        clk_out2,  
        debounced_entry,     
        debounced_exit,    
        exit_place,  
        reset,
        LED,  
        all_num,  
        best_num,  
        open,  
        full  
    );  

    multiplex_7segment mux(  
			clk_out1,
			reset,
			best_num,
			all_num,
			seg_sel,
			data_seg
    );  
    // در اینجا تابع ال ای دی چشمک زن باید فراخوانی شود . من ورودی های اشتباهی به ان داده بودم به همین دلیل به اشتباه چشمک میخورد 
    //در این ورژن اشتباهمو رفع کردم و ویدیو گرفتم امیدوارم مورد قبولتون باشه
    led_blinker lb1(clk , reset , open , full , open_door , full_light );
    
endmodule


module led_blinker ( 
    input clk,              
    input reset,               
    input door_open,      
    input full_parking,        
    output reg door_open_led,  
    output reg full_led       
); 
 
 
    reg [31:0] clk_counter; 
    reg [4:0]  counter; 
    reg door_blinking, full_blinking; 
 
   initial begin 
            clk_counter = 0; 
            counter = 0; 
            door_open_led = 0; 
            full_led = 0; 
            door_blinking = 0; 
            full_blinking = 0; 
   end 
     
    always @(posedge clk or posedge reset) begin 
        if (reset) begin 
            clk_counter <= 0; 
            counter <= 0; 
            door_open_led <= 0; 
            full_led <= 0; 
            door_blinking <= 0; 
            full_blinking <= 0; 
        end else begin 
            if (door_open && !full_parking) begin 
                door_blinking <= 1; 
                full_blinking <= 0; 
                counter <= 0; 
            end else if (full_parking) begin 
                full_blinking <= 1; 
                door_blinking <= 0; 
                counter <= 0; 
            end 
         
        if (door_blinking) begin 
                if (clk_counter == 20000000 - 1) begin 
                    clk_counter <= 0; 
                    door_open_led <= ~door_open_led;  
                    counter <=  counter + 1; 
                    if (counter == 20) begin  
                        door_blinking <= 0; 
                        door_open_led <= 0; 
                    end 
               
                end else begin 
                    clk_counter <= clk_counter + 1; 
                end 
            end else if (full_blinking) begin 
                if (clk_counter == 40000000 - 1) begin 
                    clk_counter <= 0; 
                    full_led <= ~full_led; 
                    counter <= counter + 1; 
                    if ( counter == 6) begin  
              full_blinking <= 0; 
                        full_led <= 0; 
                    end 
                end else begin 
                    clk_counter <= clk_counter + 1; 
                end 
            end else begin 
                clk_counter <= 0; 
            end 
        end 
    end 
 
endmodule