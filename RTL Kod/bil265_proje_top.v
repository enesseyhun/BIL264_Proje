`timescale 1ns / 1ps

module bil265_proje_top
(
input clk, // clock
input rst_n, // active-low reset
input btnl_i, // Left button
input btnu_i, // Upper button
input btnr_i, // Right button
input btnd_i, // Down button
input rx_i, // UART receive
output tx_o // UART transmit
);

localparam RCA = 2'b00;
localparam CLA = 2'b01;
localparam CSEA = 2'b10;
localparam CSA = 2'b11;


integer state;
integer counter;
reg [7:0] checksum;
reg [7:0] checksum_expected;


wire btnl_db,btnu_db,btnr_db,btnd_db;

//sayi1 ve sayi2yi toplamak için giriþ çýkýþlar için tanýmlar
reg [63:0] a;
reg [63:0] b;
reg cin;
reg [1:0] adder_select;
wire cout;
wire [63:0] sum;

//uart için atamalar
wire rx_received;
wire [7:0] rx_data_in;
wire tx_busy,tx_done;
reg tx_start;
reg [7:0] tx_data_out;

//debouncer atamalarý
debouncer db1(btnl_db,btnl_i,clk,rst_n);
debouncer db2(btnu_db,btnu_i,clk,rst_n);
debouncer db3(btnr_db,btnr_i,clk,rst_n);
debouncer db4(btnd_db,btnd_i,clk,rst_n);


// mux kullanarak modulleri çaðýrma
adders_muxed adders_muxed_inst(
.a(a),
.b(b),
.cin(cin),
.adder_select(adder_select),
.cout(cout),
.sum(sum)
);

uart_rx uart_rx_inst
  (
   .i_Clock(clk),
   .i_Rx_Serial(rx_i),
   .o_Rx_DV(rx_received),
   .o_Rx_Byte(rx_data_in)
   );

// uart tx
uart_tx uart_tx_inst
  (
   .i_Clock(clk),
   .i_Tx_DV(tx_start),
   .i_Tx_Byte(tx_data_out), 
   .o_Tx_Active(tx_busy),
   .o_Tx_Serial(tx_o),
   .o_Tx_Done(tx_done)
   );


always @(posedge clk or negedge rst_n)
begin
    if(~rst_n)
    begin
        state = 0;
        counter = 0;
        a = 0;
        b = 0;
        cin = 0;
        adder_select = 0;
        checksum = 0;
        checksum_expected = 0;
        tx_data_out = 0;
        tx_start = 0;
    end
    else begin
        case(state)
            0: begin //baþlýk bilgisini beklediði durum
                if(rx_received)
                    if(rx_data_in == 8'hFD)
                    begin
                        state = 1;
                        checksum_expected = 8'hFD;
                    end
                    else
                    begin
                        state = 0;
                        checksum_expected = 0;
                    end
            end
            1: begin
                if(rx_received) // baþlýðý beklendiði durum
                    if(rx_data_in == 8'hBA) // baþlýk geldiði durum
                        begin
                            state = 3;
                            counter = 0;
                            checksum_expected = checksum_expected + 8'hBA;
                        end
                    else // baþlýk gelmediði durum 
                        state = 0;        
            end
            2:begin 
                if(rx_received)
                begin
                    case(counter)
                        0: a[7:0] = rx_data_in;
                        1: a[15:7] = rx_data_in;
                        2: a[23:16] = rx_data_in;
                        3: a[31:24] = rx_data_in;
                        4: a[39:32] = rx_data_in;
                        5: a[47:40] = rx_data_in;
                        6: a[55:48] = rx_data_in;
                        7: a[63:56] = rx_data_in;
                    endcase
                    checksum_expected = checksum_expected + rx_data_in;
                    if(counter < 7)
                        counter = counter + 1;
                    else
                    begin
                        state = 3;
                        counter = 0;
                    end
                end
            end
            3: begin //b sayýsý geldi
                if(rx_received)
                begin
                    case(counter)
                        0: b[7:0] = rx_data_in;
                        1: b[15:7] = rx_data_in;
                        2: b[23:16] = rx_data_in;
                        3: b[31:24] = rx_data_in;
                        4: b[39:32] = rx_data_in;
                        5: b[47:40] = rx_data_in;
                        6: b[55:48] = rx_data_in;
                        7: b[63:56] = rx_data_in;
                    endcase
                    checksum_expected = checksum_expected + rx_data_in;
                    if(counter < 7)
                        counter = counter + 1;
                    else
                    begin
                        state = 4;
                        counter = 0;
                    end
                end
            end    
            4: begin // checksum geldiði durum
                if(rx_received)
                begin
                    checksum = rx_data_in;
                    if(checksum == checksum_expected)
                        state = 5;
                    else
                        state = 12;
                end
            end
            5: begin 
                if(btnl_db)
                begin
                    adder_select = RCA;             
                    state = 6;
                end
                else if(btnu_db)
                begin
                    adder_select = CLA;
                    state = 6;
                end
                else if(btnr_db)
                begin
                    adder_select = CSEA;
                    state = 6;
                end
                else if(btnd_db)
                begin
                    adder_select = CSA;
                    state = 6;
                end
            end
            6: begin // sonucu iletmeye baþla
                tx_data_out = 8'hFD;
                tx_start = 1;
                checksum = 0;
                state = 7;
            end
            7: begin
                tx_start = 0;
                if(tx_done)
                begin
                    checksum = 8'hFD;
                    state = 8;
                end
            end
            8: begin
                tx_data_out = 8'hBA;
                tx_start = 1;
                state = 9;
            end
            9: begin
                tx_start = 0;
                if(tx_done)
                begin
                    checksum = checksum + 8'hBA;
                    state = 10;
                    counter = 0;
                end  
            end
            10: begin
                if(tx_done || counter == 0) 
                begin
                    case(counter)
                        0: tx_data_out = sum[7:0];
                        1: tx_data_out = sum[15:7];
                        2: tx_data_out = sum[23:16];
                        3: tx_data_out = sum[31:24];
                        4: tx_data_out = sum[39:32];
                        5: tx_data_out = sum[47:40];
                        6: tx_data_out = sum[55:48];
                        7: tx_data_out = sum[63:56];
                    endcase
                    checksum = checksum + tx_data_out;
                    if(counter < 7)
                    begin
                        counter = counter + 1;
                        tx_start = 1;      
                    end
                    else begin
                        state = 11;
                    end
                end
                else begin
                    tx_start = 0;
                end
            end
            11: begin 
                if(tx_done==0)
                begin
                    tx_data_out = checksum;
                    tx_start = 1;
                end
                else begin
                    state = 0;
                end
                
            end
            12: begin // checksum hata
                tx_data_out = 8'hEE;
                tx_start = 1;
                state = 13;
          end
        endcase
    end
end

endmodule
