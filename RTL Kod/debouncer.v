`timescale 1ns / 1ps

module debouncer(button_out,button_in,clk,rst);
input button_in,clk,rst;
output reg button_out;

reg [1:0] state;
integer sayac;

localparam sayac_limit = 10; 

always @(posedge clk or negedge rst)
begin
    if(~rst)
    begin
        sayac = 0;
        button_out = 0;
        state = 0;
    end
    else
    begin
        case(state)
        2'd0: begin 
            if(button_in) 
            begin
                sayac = 0;
                state = 2'd1;
            end
        end
        2'd1: begin 
            if(sayac < sayac_limit)
            begin
                if(button_in)
                    sayac = sayac + 1;
                else
                    state = 2'd0;
            end
            else
            begin
                state = 2'd2;
                button_out = 1;
            end
        end
        2'd2: 
        begin
            button_out = 0;
            if(button_in==0)
            begin
                state = 2'd3;
                sayac = 0;
            end
        end
        2'd3: 
        begin
            if(sayac<sayac_limit)
            begin
                if(button_in==0)
                    sayac = sayac + 1;
                else
                    state = 2'd2;
            end
            else begin
                state = 2'd0;
            end
        end
        endcase
    end
end



endmodule
