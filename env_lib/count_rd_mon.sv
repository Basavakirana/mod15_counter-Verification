class count_rd_mon;

        virtual count_if.RD_MON_MP rd_mon_if;

        count_trans rd_data;
        count_trans data2sb;

        mailbox #(count_trans) rdmon2sb;

        function new(virtual count_if.RD_MON_MP rd_mon_if,
                     mailbox #(count_trans) rdmon2sb);
                this.rd_mon_if = rd_mon_if;
                this.rdmon2sb = rdmon2sb;
                this.rd_data = new();
        endfunction

        virtual task monitor();
        @(rd_mon_if.rd_mon_cb)
                begin
                      rd_data.data_out = rd_mon_if.rd_mon_cb.data_out;
                      rd_data.display("data from read monitor");
                end
        endtask

        virtual task start();
                fork
                    forever
                           begin
                                monitor();
                                data2sb = new rd_data;
                                rdmon2sb.put(data2sb);
                           end
                join_none
        endtask
endclass
