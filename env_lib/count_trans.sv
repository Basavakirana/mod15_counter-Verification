class count_trans;

        rand bit reset;
        rand bit mode;
        rand bit load;
        rand bit [3:0] data;
         logic [3:0] data_out;

        static int trans_id;
        static int no_of_up_trans;
        static int no_of_down_trans;

        constraint crst{reset dist{0 :=90,1 :=10};}
        constraint cload{load dist{0 :=70,1 :=30};}
        constraint cmode{mode dist{0 :=50,1 :=50};}
        constraint cdata{data inside{[0:14]};}

        virtual function void display(input string message);
            begin
                $display("----------------------------------------------");
                $display("%s",message);
                $display("\trst =%d",reset);
                $display("\tload =%d",load);
                $display("\tmode =%d",mode);
                $display("\tdata =%d",data);
                $display("\tdata_out =%d",data_out);
                $display("\t trasanction no =%d",trans_id);
                $display("\t up trasanction no =%d",no_of_up_trans);
                $display("\t down trasanction no =%d",no_of_down_trans);
                $display("------------------------------------------------");
             end
        endfunction

        function void post_randomize();
                if(this.mode ==0)
                        no_of_down_trans++;
                if(this.mode ==1)
                        no_of_up_trans++;
                this.display("\t randomized data");
        endfunction

        function bit compare(input count_trans rcv,output string message);
        repeat(20)
                compare = '0;
                begin
                        if(this.data_out != rcv.data_out)
                            begin
                                 $display($time);
                                 message = "--------data_out not matches--------";
                                 return(0);
                            end
                     begin
                                message = "------successfully compared------";
                                return(1);
                     end
                end
        endfunction
endclass
