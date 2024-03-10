class count_model;

        count_trans wr_mon_data;

        logic[3:0] ref_count;

        mailbox #(count_trans) wrmon2rm;
        mailbox #(count_trans) rm2sb;

        function new(mailbox #(count_trans) wrmon2rm,
                     mailbox #(count_trans) rm2sb);
                this.wrmon2rm = wrmon2rm;
                this.rm2sb = rm2sb;
        endfunction

        virtual task count_mod (count_trans wr_mon_data);
                begin
//                if(wr_data.load==1)
//                   ref_count <= wr_data.wr_mon_data;
                repeat(20)
                        wait(wr_mon_data.load == 0);
                         begin
                                 if(wr_mon_data.mode ==1)
                                   begin
                                        if(ref_count == 14)
                                           ref_count <=0;
                                        else
                                           ref_count <= ref_count + 1'b1;
                                   end
                                else if(wr_mon_data.mode == 0)
                                    begin
                                        if(ref_count ==0)
                                           ref_count <=14;
                                        else
                                           ref_count <= ref_count - 1'b1;
                                     end
                            end
                end
        endtask

        virtual task start();
                fork
                    begin
                         forever
                                begin
                                     wrmon2rm.get(wr_mon_data);
                                     count_mod(wr_mon_data);
                                     wr_mon_data.data_out =  ref_count;
                                     rm2sb.put(wr_mon_data);
                                end
                    end
                join_none
        endtask
endclass
