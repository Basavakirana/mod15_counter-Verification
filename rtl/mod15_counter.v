module mod15_counter (clk,rst,mode,load,data,data_out);
input clk,rst,mode,load;
input [3:0]data;
output reg [3:0] data_out;
always@(posedge clk)
begin
        if(rst)
                data_out<=0;
        else if(load)
                data_out<=data;
        else if(data_out==4'd14)
                data_out<=0;
        else if(mode==1)
                data_out<=data_out +1'b1;
        else
                data_out<=data_out -1'b1;
end
end
endmodule
