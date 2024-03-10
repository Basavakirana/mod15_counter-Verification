class count_wr_mon;

        virtual count_if.WR_MON_MP wr_mon_if;

        count_trans data2rm;
        count_trans wr_data;

        mailbox #(count_trans) wrmon2rm;

        function new(virtual count_if.WR_MON_MP wr_mon_if,
                     mailbox #(count_trans) wrmon2rm);
                this.wr_mon_if = wr_mon_if;
                this.wrmon2rm = wrmon2rm;
                this.wr_data = new();
        endfunction


        virtual task monitor();
        @(wr_mon_if.wr_mon_cb)
        begin
                wr_data.reset = wr_mon_if.wr_mon_cb.reset;
                wr_data.data = wr_mon_if.wr_mon_cb.data;
                wr_data.load = wr_mon_if.wr_mon_cb.load;
                wr_data.mode = wr_mon_if.wr_mon_cb.mode;
                wr_data.display("data from write monitor");
        end
        endtask

        virtual task start();
                fork
                    forever
                           begin
                                monitor();
                                data2rm = new wr_data;
                                wrmon2rm.put(data2rm);
                           end
                join_none
        endtask
endclass
