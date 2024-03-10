class count_sb;

//         rand bit reset;
  //      rand bit mode;
    //    rand bit load;
      //  rand bit [3:0] data;
        // logic [3:0] data_out;


        event DONE;

        count_trans rm_data;
        count_trans rd_mon_data;
        count_trans cov_data;

        int data_verified = 0;
        int ref_data = 0;
        int mon_data = 0;

        mailbox #(count_trans) rm2sb;
        mailbox #(count_trans) rdmon2sb;

        covergroup mem_coverage;
            option.per_instance = 1;

//              RST : coverpoint reset;
//              MD : coverpoint mode;
//              LD : coverpoint load;
//              DATA : coverpoint data {
//                              ignore_bins I1 = {15};}
//              RSTxLDxDATA : cross RST,LD,DATA;

                RST : coverpoint cov_data.reset{
                        bins ZERO   ={[0:1]};}

                MD : coverpoint cov_data.mode{
                        bins ZERO   ={[0:1]};}

                LD : coverpoint cov_data.load{
                        bins ZERO   ={[0:1]};}

                DATA : coverpoint cov_data.data{
                        bins ZERO   ={[0:14]};}
                //      bins ONE    ={[1:4]};
                //      bins TWO    ={[5:9]};
                //      bins THREE  ={[10:14]};}
        endgroup

        function new(mailbox #(count_trans) rm2sb,
                     mailbox #(count_trans) rdmon2sb);
                this.rm2sb = rm2sb;
                this.rdmon2sb = rdmon2sb;
                mem_coverage = new();
        endfunction

        virtual task start();
                fork
                    forever
                           begin
                                rm2sb.get(rm_data);
                                ref_data++;
                                rdmon2sb.get(rd_mon_data);
                                mon_data++;

                                check(rd_mon_data);
                           end
                join_none
        endtask

        virtual task check (count_trans r_mon_data);
                string diff;
                if(r_mon_data.data_out >= 15)
                   $display("SB :random data not written");
                else if(r_mon_data.data_out < 15)
                  begin
                        if(!r_mon_data.compare(r_mon_data,diff))
                            begin
                                r_mon_data.display("SB : received data");
                                rm_data.display("SB : data sent to DUT");
                                $display("%s\n%m\n\n",diff);
                            end
                        else
                                $display("SB :%s\n%m\n\n",diff);
                  end
                  cov_data = new rm_data;
                  mem_coverage.sample();
                data_verified++;
                if(data_verified >= number_of_transactions);
                        begin
                             ->DONE;
                        end
        endtask

        virtual function void report();
                $display("-------------scoreboard report-----------");
                $display("data generated = %d",ref_data);
                $display("received data = %d",mon_data);
                $display("data verified = %d",data_verified);
                $display("----------------------------------------");
        endfunction
endclass
